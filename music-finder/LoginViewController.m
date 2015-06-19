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
    // Do any additional setup after loading the view.
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed Screen" properties:@{@"Screen": @"Login", @"Test": @"True", @"Distinct Id":mixpanel.distinctId}];
    [mixpanel track:@"Profile Image Upload"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitLogin:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    if(self.usernameLogin.text.length!=0 && self.passwordLogin.text.length!=0){
        [mixpanel identify:self.usernameLogin.text];
        [mixpanel.people set:@{@"$username":self.usernameLogin.text, @"Password":self.passwordLogin.text}];
        [mixpanel track:@"Logged In" properties:@{@"Distinct Id":mixpanel.distinctId}];
        [mixpanel.people increment: @{@"Logins": @1}];
    }

}

- (IBAction)backLogin:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Login Back" properties:@{@"Username":self.usernameLogin.text, @"Password":self.passwordLogin.text, @"Distinct Id":mixpanel.distinctId}];
}

@end