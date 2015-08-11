//
//  LoginViewController.m
//  music-finder
//
//  Created by ryan on 3/10/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "LoginViewController.h"
#import <Mixpanel/Mixpanel.h>
#import <Mixpanel/MPTweakInline.h>

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameLogin;
@property (strong, nonatomic) IBOutlet UITextField *passwordLogin;
- (IBAction)submitLogin:(UIButton *)sender;
- (IBAction)backLogin:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
     // Track event that the user landed on the Login screen
    [mixpanel track:@"Viewed Screen" properties:@{@"Screen": @"Login", @"Test": @"True", @"Distinct Id":mixpanel.distinctId}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)submitLogin:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // If the text fields have data, let's do some magic
    if(self.usernameLogin.text.length!=0 && self.passwordLogin.text.length!=0){
        
        // Since this is login, we identify the user with their aliased identifier
        [mixpanel identify:self.usernameLogin.text];
        
        // Once we have the identity management in order, let's set some people properties for the user
        [mixpanel.people set:@{@"$username":self.usernameLogin.text, @"Password":self.passwordLogin.text}];
        [mixpanel.people increment: @{@"Logins": @1}];
        
        // Track an event that the user successfully logged into our app
        [mixpanel track:@"Logged In" properties:@{@"Distinct Id":mixpanel.distinctId}];
    }

}

- (IBAction)backLogin:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Track an event that the user went backwards from the Login screen
    [mixpanel track:@"Login Back" properties:@{@"Username":self.usernameLogin.text, @"Password":self.passwordLogin.text, @"Distinct Id":mixpanel.distinctId}];
}

@end
