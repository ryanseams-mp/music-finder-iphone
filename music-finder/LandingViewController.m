//
//  LandingViewController.m
//  music-finder
//
//  Created by ryan on 3/10/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "LandingViewController.h"
#import <Mixpanel/Mixpanel.h>
#import <Mixpanel/MPTweakInline.h>
#import <YTPlayerView.h>

@interface LandingViewController ()

- (IBAction)signoutButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet YTPlayerView *playerView;

@end

@implementation LandingViewController

@synthesize genreSignup;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Track event that the user landed on the Landing screen
    [mixpanel track:@"Viewed Screen" properties:@{@"Screen": @"Landing", @"Test": @"True", @"Distinct Id":mixpanel.distinctId}];
    
    // Create the YouTube player and assign a video based on the genre chosen upon signup
    self.playerView.delegate = self;
    NSString *videoId;
    if ([self.genreSignup isEqual: @"Country"]) {
        videoId = @"WySgNm8qH-I";
    } else if ([self.genreSignup isEqual: @"Pop"]) {
        videoId = @"JV2s0UIPOQY";
    } else if ([self.genreSignup isEqual: @"Rap"]) {
        videoId = @"O8S-snMP4PM";
    } else if ([self.genreSignup isEqual: @"Rock"]) {
        videoId = @"Vy1duFfHfb4";
    } else {
        videoId = @"kKnxcvNqrCo";
    }
    [self.playerView loadWithVideoId:videoId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Track video play and stop events based on the user inputs on the YouTube object
    switch (state) {
        case kYTPlayerStatePlaying:
            [mixpanel track:@"Video Played" properties:@{@"Distinct Id":mixpanel.distinctId, @"Genre":self.genreSignup}];
            break;
        case kYTPlayerStatePaused:
            [mixpanel track:@"Video Stopped" properties:@{@"Distinct Id":mixpanel.distinctId, @"Genre":self.genreSignup}];
            break;
        default:
            break;
    }
}

- (IBAction)signoutButton:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Track that the user signed out and headed back to the Home screen
    [mixpanel track:@"Signed Out" properties:@{@"Distinct Id":mixpanel.distinctId}];
    
    // If many users utilize the same device, you may want to call
    // [mixpanel reset];
    // You will need to manually reset mixpanel.distinctId to a uuid in this scenario
}

@end
