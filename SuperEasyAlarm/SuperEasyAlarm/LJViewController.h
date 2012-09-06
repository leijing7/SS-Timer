//
//  LJViewController.h
//  SuperEasyAlarm
//
//  Created by Lei Jing on 11/07/12.
//  Copyright (c) 2012 UWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *destTimeLabel;

@property (weak, nonatomic) IBOutlet UISlider *secondSliderObj;
@property (weak, nonatomic) IBOutlet UISlider *minuteSliderObj;
@property (weak, nonatomic) IBOutlet UISlider *hourSliderObj;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)secondSlider:(id)sender;
- (IBAction)minuteSlider:(id)sender;
- (IBAction)hourSlider:(id)sender;
- (IBAction)startCountDown:(id)sender;
- (IBAction)savePresetInterval:(id)sender;

@end
