//
//  sharedViewController.h
//  SuperEasyAlarm
//
//  Created by Lei Jing on 26/08/12.
//  Copyright (c) 2012 UWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedViewController : NSObject
{
    UIImage *startImage;
    UIImage *pauseImage;
}

+ (SharedViewController *)sharedController;

- (void)loadTotalTimeLabel:(UILabel *)ttLabel destTimeLabel:(UILabel *)dtLabel startStopButton:(UIButton *)ssButton;
- (void)loadStartedTotalTimeLabel:(UILabel *)ttLabel destTimeLabel:(UILabel *)dtLabel startStopButton:(UIButton *)ssButton;
- (void)loadStoppedTotalTimeLabel:(UILabel *)ttLabel destTimeLabel:(UILabel *)dtLabel startStopButton:(UIButton *)ssButton;

- (void)startPauseTotalTimeLabel:(UILabel *)ttLabel destTimeLabel:(UILabel *)dtLabel startStopButton:(UIButton *)ssButton;

@end
