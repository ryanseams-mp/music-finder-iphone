//
//  AppDelegate.m
//  music-finder
//
//  Created by ryan on 3/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "AppDelegate.h"
#import <Mixpanel/Mixpanel.h>
#import "Mixpanel/MPTweakInline.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#define MIXPANEL_TOKEN @"ryanios"
    
    // Initialize the library with your
    // Mixpanel project token, MIXPANEL_TOKEN
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
    // Later, you can get your instance with
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel registerSuperPropertiesOnce:@{@"PROP_NAME": @0}];
    NSNumber *current = [[mixpanel currentSuperProperties] objectForKey:@"PROP_NAME"];
    NSInteger *value = [current integerValue] + 1;
    current = [NSNumber numberWithInteger:value];
    [mixpanel registerSuperProperties:@{@"PROP_NAME": current}];
    
    [mixpanel track:@"Viewed Screen" properties:@{@"Screen": @"Home", @"Test": @"True", @"Image": @"iPod", @"Color":@"Blue", @"Distinct Id":mixpanel.distinctId}];
    
    [mixpanel registerSuperProperties:@{@"$app_release": [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"], @"$app_version": [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]}];
    
    NSLog(@"TESTING");
    
    // Let's now identify the user
    [mixpanel identify:mixpanel.distinctId];
    [mixpanel.people increment:@{@"Logins": @1}];
    if( MPTweakValue(@"show alternate view", NO) ) {
        NSLog(@"NO");
    } else {
        NSLog(@"YES");
    }
    
    int numLives = MPTweakValue(@"number of lives", 5);
    NSLog(@(numLives).stringValue);
    
    BOOL showQuickStartMenu = MPTweakValue(@"showQuickStartMenu", NO);
    if (showQuickStartMenu) {
        NSLog(@"Tweak enabled");
    }
    
    /*increment super props
     [mixpanel registerSuperPropertiesOnce:@{@"PROP_NAME": 0}];
     NSNumber *current = [[mixpanel currentSuperProperties] objectForKey:@"PROP_NAME"];
     NSInteger *value = [current integerValue] + 1;
     current = [NSNumber numberWithInteger:value];
     [mixpanel registerSuperProperties:@{@"PROP_NAME": current}];*/
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
    UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:userNotificationSettings];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:userNotificationSettings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
    
    // Override point for customization after application launch.
    return YES;
}

#pragma mark - Deep linking

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if([[url host] isEqualToString:@"signup"] && [[url path] isEqualToString:@"/signup"]) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIViewController *view = [mainStoryboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        [self.window.rootViewController presentViewController:view animated:YES completion:nil];
    }
    return YES;
}

#pragma mark - Push notifications

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    if ([identifier isEqualToString:@"declineAction"]) {
        NSLog(@"%@ user declined push notification action", self);
        
    } else if ([identifier isEqualToString:@"answerAction"]) {
        NSLog(@"%@ user answered push notification action", self);
    }
}
#endif

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel.people addPushDeviceToken:devToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"%@ push registration error is expected on simulator", self);
#else
    NSLog(@"%@ push registration error: %@", self, err);
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Show alert for push notifications recevied while the app is running
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:userInfo[@"aps"][@"alert"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
#else
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:userInfo[@"aps"][@"alert"]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
#endif
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel trackPushNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply
{
    // Temporary fix, I hope.
    // --------------------
    __block UIBackgroundTaskIdentifier bogusWorkaroundTask;
    bogusWorkaroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bogusWorkaroundTask];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endBackgroundTask:bogusWorkaroundTask];
    });
    // --------------------
    
    __block UIBackgroundTaskIdentifier realBackgroundTask;
    realBackgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        reply(nil);
        [[UIApplication sharedApplication] endBackgroundTask:realBackgroundTask];
    }];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    NSString *uuid = userInfo[@"NewID"];
    [mixpanel identify:uuid];
    
    reply(nil);
    [[UIApplication sharedApplication] endBackgroundTask:realBackgroundTask];
}


/*OLD CODE FOR RECEIVING DATA FROM WATCH THEN SENDING TO MIXPANEL
 
 DATA SEND WAS ON THE ACTION BELOW TO QUEUE TO THE WATCH:
 - (IBAction)peopleButton {
 
 NSDictionary *applicationData = @{@"Type": @"People", @"$device": @"Apple Watch", @"Test": @"True"};
 
 [WKInterfaceController openParentApplication:applicationData reply:^(NSDictionary *replyInfo, NSError *error) {}];
 
 }
 
 THEN THIS CODE BELOW IS RUN TO ACTUALLY SEND DATA:
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply
{
    // Temporary fix, I hope.
    // --------------------
    __block UIBackgroundTaskIdentifier bogusWorkaroundTask;
    bogusWorkaroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bogusWorkaroundTask];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endBackgroundTask:bogusWorkaroundTask];
    });
    // --------------------
    
    __block UIBackgroundTaskIdentifier realBackgroundTask;
    realBackgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        reply(nil);
        [[UIApplication sharedApplication] endBackgroundTask:realBackgroundTask];
    }];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    NSString *typeString = userInfo[@"Type"];
    
    NSLog(typeString);
    if([typeString isEqualToString:@"Event"]) {
        NSString *categoryString = userInfo[@"Event"];
        [mixpanel track:categoryString properties:userInfo];
    }
    if([typeString isEqualToString:@"People"]) {
        [mixpanel identify:mixpanel.distinctId];
        [mixpanel.people set:userInfo];
    }
    if([typeString isEqualToString:@"Reset"]) {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [mixpanel identify:uuid];
        [mixpanel track:@"Watch Reset" properties:userInfo];
    }
    
    reply(nil);
    [[UIApplication sharedApplication] endBackgroundTask:realBackgroundTask];
}*/


@end
