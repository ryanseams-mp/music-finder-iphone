//
//  SignUpViewController.m
//  music-finder
//
//  Created by ryan on 3/10/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "SignUpViewController.h"
#import "LandingViewController.h"
#import <Mixpanel/Mixpanel.h>
#import <Mixpanel/MPTweakInline.h>

@interface SignUpViewController ()

@property (strong, nonatomic) IBOutlet UITextField *nameSignup;
@property (strong, nonatomic) IBOutlet UITextField *emailSignup;
@property (strong, nonatomic) IBOutlet UITextField *usernameSignup;
@property (strong, nonatomic) IBOutlet UITextField *passwordSignup;
- (IBAction)submitSignup:(UIButton *)sender;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) NSString *genreSignup;
- (IBAction)backSignup:(UIButton *)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed Screen" properties:@{@"Screen": @"Sign Up", @"Test": @"True", @"Distinct Id":mixpanel.distinctId}];
    [mixpanel timeEvent:@"Profile Image Upload"];
    
    // Initialize Data
    _pickerData = @[@"Country", @"Pop", @"Rap", @"Rock", @"Top 40"];
    
    // Connect data
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.nameSignup.delegate = self;
    self.usernameSignup.delegate = self;
    self.emailSignup.delegate = self;
    self.passwordSignup.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    self.genreSignup = _pickerData[row];
}

//close the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        // Get reference to the destination view controller
        LandingViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.genreSignup = self.genreSignup;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)submitSignup:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    if(self.nameSignup.text.length!=0 && self.emailSignup.text.length!=0 && self.usernameSignup.text.length!=0 && self.passwordSignup.text.length!=0){
        [mixpanel createAlias:self.usernameSignup.text forDistinctID:mixpanel.distinctId];
        [mixpanel identify:self.usernameSignup.text];
        [mixpanel.people set:@{@"$name": self.nameSignup.text, @"$email": self.emailSignup.text, @"$username":self.usernameSignup.text, @"Password":self.passwordSignup.text, @"Alias": self.usernameSignup.text}];
        [mixpanel registerSuperProperties:@{@"Name": self.nameSignup.text, @"Email": self.emailSignup.text, @"Username":self.usernameSignup.text, @"Password":self.passwordSignup.text, @"Alias": self.usernameSignup.text}];
        [mixpanel track:@"Signed Up" properties:@{@"Genre": self.genreSignup, @"Distinct Id":mixpanel.distinctId}];
    }
}

- (IBAction)backSignup:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Sign Up Back" properties:@{@"Name": self.nameSignup.text, @"Email": self.emailSignup.text, @"Username":self.usernameSignup.text, @"Password":self.passwordSignup.text, @"Alias": self.usernameSignup.text, @"Distinct Id":mixpanel.distinctId}];
}

@end