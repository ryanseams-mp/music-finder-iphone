//
//  ViewController.m
//  music-finder
//
//  Created by ryan on 3/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "ViewController.h"
#import <Mixpanel/Mixpanel.h>
#import <Mixpanel/MPTweakInline.h>

@interface ViewController ()

- (IBAction)loginButton:(UIButton *)sender;
- (IBAction)signupButton:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {   
    [super viewDidLoad];
    
    // Track event that the user landed on the Home screen
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed Screen" properties:@{@"Screen": @"Home", @"Test": @"True", @"Image": @"iPod", @"Color":@"Blue", @"Distinct Id":mixpanel.distinctId}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginButton:(UIButton *)sender {
    // Track event that the user clicked on the Login button
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Login Button Clicked" properties:@{@"Test": @"True", @"Image": @"iPod", @"Color":@"Blue", @"Distinct Id":mixpanel.distinctId}];
}

- (IBAction)signupButton:(UIButton *)sender {
    // Track event that the user clicked on the Signup button
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Sign Up Button Clicked" properties:@{@"Test": @"True", @"Image": @"iPod", @"Color":@"Blue", @"Distinct Id":mixpanel.distinctId}];
}

@end
