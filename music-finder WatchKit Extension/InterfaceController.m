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

#define MIXPANEL_TOKEN @"ryanios"

- (void)awakeWithContext:(id)context {
    
    // Initialize the library with your
    // Mixpanel project token, MIXPANEL_TOKEN
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
    [super awakeWithContext:context];

    // Configure interface objects here.
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
    [mixpanel track:@"Watch Event" properties:@{@"Screen": @"Main", @"Test": @"True", @"Distinct Id":mixpanel.distinctId}];
    
}

- (IBAction)peopleButton {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:mixpanel.distinctId];
    [mixpanel.people set:@{@"Watch": @"True"}];
    
}

- (IBAction)changeIdButton {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    [mixpanel identify:uuid];
    [mixpanel track:@"Watch Reset" properties:@{@"Screen": @"Main", @"Test": @"True", @"Distinct Id":uuid}];
    
    NSDictionary *applicationData = @{@"NewID": uuid};
    [WKInterfaceController openParentApplication:applicationData reply:^(NSDictionary *replyInfo, NSError *error) {}];
}

@end



