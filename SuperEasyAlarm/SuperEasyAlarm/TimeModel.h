//
//  TimeModel.h
//  SuperEasyAlarm
//
//  Created by Lei Jing on 22/08/12.
//  Copyright (c) 2012 UWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeModel : NSObject
{
    NSTimer *timer;
    NSDate *destDate;
    NSInteger DEFAULT_SECONDS;
    NSString *presetsPath;
}

@property (nonatomic) NSInteger seconds;
@property (nonatomic) NSInteger minutes;
@property (nonatomic) NSInteger hours;

@property (nonatomic) NSInteger totalSeconds;

@property (nonatomic) NSString *notificationName;

@property (nonatomic) bool isStarted;

@property (nonatomic) NSMutableArray *presetTimeArray;

+ (TimeModel *)sharedModel;

- (NSString *)secondsString;
- (NSString *)minutesString;
- (NSString *)hoursString;

- (NSString *)totalSecondsString; //interval time string
- (NSString *)destDateString; 

- (void)set1800;

- (void)startStopCountDown;

- (BOOL)isPassedDestDate;

- (void)saveCurrentTotalSeconds;

- (NSString *)intToString2: (NSInteger)i;

@end
