//
//  PresetViewController.h
//  SuperEasyAlarm
//
//  Created by Lei Jing on 22/08/12.
//  Copyright (c) 2012 UWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeModel;

@interface PresetViewController : UIViewController
{
    UIImage *startImage;
    UIImage *pauseImage;
}

- (IBAction)set3m:(id)sender;
- (IBAction)set5m:(id)sender;
- (IBAction)set8m:(id)sender;
- (IBAction)set10m:(id)sender;

- (IBAction)set15m:(id)sender;
- (IBAction)set20m:(id)sender;
- (IBAction)set30m:(id)sender;
- (IBAction)set45m:(id)sender;

- (IBAction)set1hr:(id)sender;
- (IBAction)set1hrAndHalf:(id)sender;
- (IBAction)set2hr:(id)sender;
- (IBAction)set8hr:(id)sender;

- (IBAction)set1:(id)sender;
- (IBAction)set2:(id)sender;
- (IBAction)set3:(id)sender;
- (IBAction)set4:(id)sender;

- (IBAction)startStopButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *setButton1;
@property (weak, nonatomic) IBOutlet UIButton *setButton2;
@property (weak, nonatomic) IBOutlet UIButton *setButton3;
@property (weak, nonatomic) IBOutlet UIButton *setButton4;

@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *destTimeLabel;

@property (nonatomic) NSInteger set1,set2,set3,set4;

@end
