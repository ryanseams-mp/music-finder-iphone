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
    // Do any additional setup after loading the view.
    
    self.playerView.delegate = self;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed Screen" properties:@{@"Screen": @"Landing", @"Test": @"True", @"Distinct Id":mixpanel.distinctId}];
    
    NSString *videoId;
    
    if ([self.genreSignup isEqual: @"Country"]) {
        videoId = @"WySgNm8qH-I";
    }
    else if ([self.genreSignup isEqual: @"Pop"]) {
        videoId = @"JV2s0UIPOQY";
    }
    else if ([self.genreSignup isEqual: @"Rap"]) {
        videoId = @"O8S-snMP4PM";
    }
    else if ([self.genreSignup isEqual: @"Rock"]) {
        videoId = @"Vy1duFfHfb4";
    }
    else {
        videoId = @"kKnxcvNqrCo";
    }
    
    [self.playerView loadWithVideoId:videoId];
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

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
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
    //let's make this do a reset for testing sake?
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Signed Out" properties:@{@"Distinct Id":mixpanel.distinctId}];
}

@end
