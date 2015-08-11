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
    
    // Track event that the user landed on the Signup screen
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed Screen" properties:@{@"Screen": @"Sign Up", @"Test": @"True", @"Distinct Id":mixpanel.distinctId}];
    
    // Initialize data for the genre picker wheel
    _pickerData = @[@"Country", @"Pop", @"Rap", @"Rock", @"Top 40"];
    
    // Connect data from the outlets to the view
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.nameSignup.delegate = self;
    self.usernameSignup.delegate = self;
    self.emailSignup.delegate = self;
    self.passwordSignup.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// The number of columns of data for the picker wheel
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data for the picker wheel
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) for the picker wheel
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

// Close the keyboard when the user is done typing and presses return
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

// Prepare to send the genre to other views upon segue
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        // Get reference to the destination view controller
        LandingViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.genreSignup = self.genreSignup;
    }
}

- (IBAction)submitSignup:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // If the text fields have data, let's do some magic
    if(self.nameSignup.text.length!=0 && self.emailSignup.text.length!=0 && self.usernameSignup.text.length!=0 && self.passwordSignup.text.length!=0){
        
        // Since this is signup, we alias the user with a unique identifier, like username here
        [mixpanel createAlias:self.usernameSignup.text forDistinctID:mixpanel.distinctId];
        
        // After we alias, we need to identify the user to flush the people queue
        [mixpanel identify:self.usernameSignup.text];
        
        // Once we have the identity management in order, let's register some people and super properties for the user
        [mixpanel.people set:@{@"$name": self.nameSignup.text, @"$email": self.emailSignup.text, @"$username":self.usernameSignup.text, @"Password":self.passwordSignup.text, @"Alias": self.usernameSignup.text}];
        [mixpanel registerSuperProperties:@{@"Name": self.nameSignup.text, @"Email": self.emailSignup.text, @"Username":self.usernameSignup.text, @"Password":self.passwordSignup.text, @"Alias": self.usernameSignup.text}];
        
        // Track an event that the user successfully signed up for our app
        [mixpanel track:@"Signed Up" properties:@{@"Genre": self.genreSignup, @"Distinct Id":mixpanel.distinctId}];
    }
}

- (IBAction)backSignup:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Track an event that the user went backwards from the Signup screen
    [mixpanel track:@"Sign Up Back" properties:@{@"Name": self.nameSignup.text, @"Email": self.emailSignup.text, @"Username":self.usernameSignup.text, @"Password":self.passwordSignup.text, @"Alias": self.usernameSignup.text, @"Distinct Id":mixpanel.distinctId}];
}

@end
