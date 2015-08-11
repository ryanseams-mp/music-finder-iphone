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

// Set your Mixpanel token as variable MIXPANEL_TOKEN -- you must change this to your Mixpanel project token
#define MIXPANEL_TOKEN @"ryanios"
    
    // Initialize the library with your Mixpanel project token, MIXPANEL_TOKEN
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
    // Once initialized, you can get your instance with
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Grab A/B testing Tweak variables and register as super properties
    int numLives = MPTweakValue(@"Number of lives", 5);
    NSLog(@(numLives).stringValue);
    [mixpanel registerSuperProperties:@{@"Num Lives": @(numLives).stringValue}];
    
    int numLives1 = MPTweakValue(@"Number of lives 1", 20);
    NSLog(@(numLives1).stringValue);
    [mixpanel registerSuperProperties:@{@"Num Lives 1": @(numLives1).stringValue}];
    
    // Ensure Mixpanel looks for new A/B testing experiments and joins then when available
    mixpanel.checkForVariantsOnActive = true;
    [mixpanel joinExperimentsWithCallback:^{
        // Here you can use tweaks to do UX mods like control the next view, sequence of views, etc.
    }];
    
    // Add code to handle registering for push notifications to Mixpanel, need different code for post and pre iOS 8
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
    
    return YES;
}

// Code for handling deep linking from Mixpanel notifications
#pragma mark - Deep linking

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if([[url host] isEqualToString:@"signup"] && [[url path] isEqualToString:@"/signup"]) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIViewController *view = [mainStoryboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        [self.window.rootViewController presentViewController:view animated:YES completion:nil];
    }
    return YES;
}

// Code for handling registering push token to Mixpanel after user agress
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
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Track the session timings as the app goes to the background
    [mixpanel track:@"$app_open"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Start session timings on each app open
    [mixpanel timeEvent:@"$app_open"];
    
    // Track an incremental super property for number of app opens
    [mixpanel registerSuperPropertiesOnce:@{@"App Opens": @1}];
    NSNumber *current = [[mixpanel currentSuperProperties] objectForKey:@"App Opens"];
    NSInteger *value = [current integerValue] + 1;
    current = [NSNumber numberWithInteger:value];
    [mixpanel registerSuperProperties:@{@"App Opens": current}];
    
    // Track a people property for number of app opens -- identify is required to send updates to Mixpanel
    [mixpanel identify:mixpanel.distinctId];
    [mixpanel.people increment:@{@"App Opens": @1}];
    
    // Set a super property to indicate this is now a returning user
    [mixpanel registerSuperProperties:@{@"Returning User": @"true"}];
    
    // Track an event for the user landing on the Home screen
    [mixpanel track:@"Viewed Screen" properties:@{@"Screen": @"Home", @"Test": @"True", @"Image": @"iPod", @"Color":@"Blue", @"Distinct Id":mixpanel.distinctId}];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply
{
    // Start the background task started to process watch data
    __block UIBackgroundTaskIdentifier realBackgroundTask;
    realBackgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        reply(nil);
        [[UIApplication sharedApplication] endBackgroundTask:realBackgroundTask];
    }];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Retrieve the new distinct id from the watch and then apply it to Mixpanel
    NSString *uuid = userInfo[@"NewID"];
    [mixpanel identify:uuid];
    
    // End the background task started to process watch data
    reply(nil);
    [[UIApplication sharedApplication] endBackgroundTask:realBackgroundTask];
}

@end
