//
//  InterfaceController.m
//  music-finder WatchKit Extension
//
//  Created by ryan on 4/28/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "InterfaceController.h"
#import <Mixpanel/Mixpanel.h>

@interface InterfaceController()

- (IBAction)sendButton;
- (IBAction)peopleButton;
- (IBAction)changeIdButton;

@end


@implementation InterfaceController

// Set your Mixpanel token as variable MIXPANEL_TOKEN -- you must change this to your Mixpanel project token
#define MIXPANEL_TOKEN @"ryanios"

- (void)awakeWithContext:(id)context {
    
    // Initialize the library with your Mixpanel project token, MIXPANEL_TOKEN
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
    [super awakeWithContext:context];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)sendButton {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Track an event sent from the watch
    [mixpanel track:@"Watch Event" properties:@{@"Screen": @"Main", @"Test": @"True", @"Distinct Id":mixpanel.distinctId}];
}

- (IBAction)peopleButton {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Track that the current user has an Apple Watch on their people profile
    [mixpanel identify:mixpanel.distinctId];
    [mixpanel.people set:@{@"Watch": @"True"}];
    
}

- (IBAction)changeIdButton {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Randomize the distinct id being sent to Mixpanel
    NSString *uuid = [[NSUUID UUID] UUIDString];
    [mixpanel identify:uuid];
    
    // Send an event that the user's id has been reset from the Apple Watch
    [mixpanel track:@"Watch Reset" properties:@{@"Screen": @"Main", @"Test": @"True", @"Distinct Id":uuid}];
    
    // Send the new distinct id back to the app to ensure distinct id remains consistent
    NSDictionary *applicationData = @{@"NewID": uuid};
    [WKInterfaceController openParentApplication:applicationData reply:^(NSDictionary *replyInfo, NSError *error) {}];
}

@end
