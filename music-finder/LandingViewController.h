//
//  LandingViewController.h
//  music-finder
//
//  Created by ryan on 3/10/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YTPlayerView.h>

@interface LandingViewController : UIViewController<YTPlayerViewDelegate>

@property (strong, nonatomic) NSString *genreSignup;

@end
