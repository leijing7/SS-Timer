//
//  sharedViewController.m
//  SuperEasyAlarm
//
//  Created by Lei Jing on 26/08/12.
//  Copyright (c) 2012 UWS. All rights reserved.
//

#import "SharedViewController.h"
#import "TimeModel.h"

@implementation SharedViewController

+ (SharedViewController *)sharedController
{
    static SharedViewController* sharedController = nil;
    if (!sharedController) {
        sharedController = [[super allocWithZone:nil] init];
    }
    return sharedController;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedController];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *startImageName = @"start.png";
        NSString *pauseImageName = @"pauseb.png";
        
        startImage = [UIImage imageNamed:startImageName];
        pauseImage = [UIImage imageNamed:pauseImageName];
    }
    return self;
}

- (void)loadTotalTimeLabel:(UILabel *)ttLabel destTimeLabel:(UILabel *)dtLabel startStopButton:(UIButton *)ssButton
{
    if ([[TimeModel sharedModel] isStarted]) {
        [self loadStartedTotalTimeLabel:ttLabel destTimeLabel:dtLabel startStopButton:ssButton];
    } else {
        [self loadStoppedTotalTimeLabel:ttLabel destTimeLabel:dtLabel startStopButton:ssButton];
    }
}

//refresh totalTime label and destination time label and start stop button to 'already running' mode
- (void)loadStartedTotalTimeLabel:(UILabel *)ttLabel destTimeLabel:(UILabel *)dtLabel startStopButton:(UIButton *)ssButton
{
    [ttLabel setText:[[TimeModel sharedModel] totalSecondsString]];
    UIColor *darkBlueColor = [UIColor colorWithRed:0.1f green:0.3f blue:0.6f alpha:1.0f];
    [ttLabel setTextColor:darkBlueColor];
    [dtLabel setText:[[TimeModel sharedModel] destDateString]];
    [ssButton setImage:pauseImage forState:UIControlStateNormal];
}


//refresh totalTime label and destination time label and start stop button to 'Ready to run' mode
- (void)loadStoppedTotalTimeLabel:(UILabel *)ttLabel destTimeLabel:(UILabel *)dtLabel startStopButton:(UIButton *)ssButton
{
    [ttLabel setText:[[TimeModel sharedModel] totalSecondsString]];
    [ttLabel setTextColor:[UIColor blackColor]];
    [dtLabel setText:@""];
    [ssButton setImage:startImage forState:UIControlStateNormal];
}

//start or stop running
- (void)startPauseTotalTimeLabel:(UILabel *)ttLabel destTimeLabel:(UILabel *)dtLabel startStopButton:(UIButton *)ssButton
{
    [[TimeModel sharedModel] startStopCountDown];
    [self loadTotalTimeLabel:ttLabel destTimeLabel:dtLabel startStopButton:ssButton];
}

@end
