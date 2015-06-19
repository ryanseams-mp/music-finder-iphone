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
    // Do any additional setup after loading the view, typically from a nib.
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed Screen" properties:@{@"Screen": @"Home", @"Test": @"True", @"Image": @"iPod", @"Color":@"Blue", @"Distinct Id":mixpanel.distinctId}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Login Button Clicked" properties:@{@"Test": @"True", @"Image": @"iPod", @"Color":@"Blue", @"Distinct Id":mixpanel.distinctId}];
}

- (IBAction)signupButton:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Sign Up Button Clicked" properties:@{@"Test": @"True", @"Image": @"iPod", @"Color":@"Blue", @"Distinct Id":mixpanel.distinctId}];
}

@end
