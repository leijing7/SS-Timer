//
//  TimeModel.m
//  SuperEasyAlarm
//
//  Created by Lei Jing on 22/08/12.
//  Copyright (c) 2012 UWS. All rights reserved.
//

#import "TimeModel.h"

@implementation TimeModel

@synthesize seconds, minutes, hours, totalSeconds;
@synthesize notificationName;
@synthesize isStarted;
@synthesize presetTimeArray;

+ (TimeModel *)sharedModel
{
    static TimeModel *sharedModel = nil;
    if (!sharedModel) {
        sharedModel = [[super allocWithZone:nil] init];
    }
    return sharedModel;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedModel];
}

- (id)init
{
    self = [super init];
    if (self) {
        DEFAULT_SECONDS = 1800;
        [self set1800];
        notificationName = @"timeDecrease";
        isStarted = false;
        
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [documentDirectories objectAtIndex:0];
        presetsPath = [documentDirectory stringByAppendingPathComponent:@"presets.archive"];
        if (presetsPath) {
            presetTimeArray = [NSKeyedUnarchiver unarchiveObjectWithFile:presetsPath];
        }
    }
    return self;
}

- (void)set1800
{
    self.totalSeconds = DEFAULT_SECONDS; //main view is the 30minutes as default
}

- (void)setTotalSeconds:(NSInteger)s
{
    totalSeconds = s; 
    [self updateSMH];
}

- (void)setSeconds:(NSInteger)s
{
    seconds = s;
    [self updateTotalSeconds];
}
- (void)setMinutes:(NSInteger)m
{
    minutes = m;
    [self updateTotalSeconds];
}
- (void)setHours:(NSInteger)h
{
    hours = h;
    [self updateTotalSeconds];
}

- (NSString *)secondsString
{
    return [self intToString2: seconds];
}

- (NSString *)minutesString
{
    return [self intToString2: minutes];
}

- (NSString *)hoursString
{
    return [self intToString2: hours];
}

- (NSString *)totalSecondsString
{
    return [NSString stringWithFormat:@"%@%@%@%@%@", [self hoursString], @":", [self minutesString], @":", [self secondsString]];
}

- (NSString *)destDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    return [dateFormatter stringFromDate:destDate];
}

////////////////////////////auxillary function

- (void)cancelAllAppLocalNotifications
{
    UIApplication *app = [UIApplication sharedApplication];
    
    //remove all prior notifications
    NSArray *scheduled = [app scheduledLocalNotifications];
    if (scheduled.count) {
        [app cancelAllLocalNotifications];
    }
}

- (void)createLocalNotification
{
    [self cancelAllAppLocalNotifications];
    
    UIApplication *app = [UIApplication sharedApplication];
    
    //create a new notification
    UILocalNotification* alarmLN = [[UILocalNotification alloc] init];
    if (alarmLN) {
        alarmLN.fireDate = [NSDate dateWithTimeIntervalSinceNow:totalSeconds];
        alarmLN.timeZone = [NSTimeZone defaultTimeZone];
        alarmLN.repeatInterval = 0;
        alarmLN.alertBody = @"Time is up";
        alarmLN.soundName = @"watchalarm.aif";
        [app scheduleLocalNotification:alarmLN];
    }
}

- (void)startStopCountDown
{
    if (isStarted) {
        [timer invalidate];
        [self cancelAllAppLocalNotifications];
        isStarted = false;
    } else {
        if (totalSeconds > 0) {
            timer = [self createTimer];
            destDate = [NSDate dateWithTimeIntervalSinceNow:totalSeconds];
            [self createLocalNotification];
            isStarted = true;
        }
    }
}

- (NSTimer *)createTimer
{
    return [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
}

- (void)timerTicked:(NSTimer*)tmr
{
    if (totalSeconds > 0) {
        self.totalSeconds--;
        
        NSNotification *note = [NSNotification notificationWithName:notificationName object:self];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
    else {
        [tmr invalidate];
    }
}

//////////////////////////////////////////////////////////////internal methods

- (void)updateTotalSeconds
{
    totalSeconds = seconds + 60*minutes + 3600*hours;
    
    destDate = [NSDate dateWithTimeIntervalSinceNow:totalSeconds];
    [self cancelAllAppLocalNotifications];
    [self createLocalNotification];
}

- (void)updateSMH
{
    hours = totalSeconds / 3600;
    minutes = (totalSeconds - hours*3600) / 60;
    seconds = totalSeconds - hours*3600 - minutes*60;
}

//to make NSInteger to 2 letters string
- (NSString *)intToString2: (NSInteger)i
{
    NSString *str = nil;
    if (0 <= i && i < 10) {
        str = [NSString stringWithFormat:@"0%d", i];
    }
    if (10 <= i && i < 100) {
        str = [NSString stringWithFormat:@"%d", i];
    }
    return str;
}

- (BOOL)isPassedDestDate
{
    totalSeconds = [destDate timeIntervalSinceNow];
    //less that 0 means the destination time is up
    if (totalSeconds<=0) {
        [timer invalidate];
        isStarted = false;
        [self set1800];
        return true;
    } else {
        return false;
    }
}

- (void)saveCurrentTotalSeconds
{
    if (!presetTimeArray) {
        presetTimeArray = [[NSMutableArray alloc] initWithCapacity:4];
        [presetTimeArray insertObject:[NSNumber numberWithInteger:0] atIndex:0];
        [presetTimeArray insertObject:[NSNumber numberWithInteger:0] atIndex:1];
        [presetTimeArray insertObject:[NSNumber numberWithInteger:0] atIndex:2];
        [presetTimeArray insertObject:[NSNumber numberWithInteger:0] atIndex:3];
    }
    [presetTimeArray insertObject:[NSNumber numberWithInteger:totalSeconds] atIndex:0];

    while(presetTimeArray.count>4) {
        [presetTimeArray removeLastObject];
    }
    
    bool isSaveSuccessful = [NSKeyedArchiver archiveRootObject:presetTimeArray toFile:presetsPath];
    if(isSaveSuccessful)
    {
        NSLog(@"save presets successful");
    } else {
        NSLog(@"save presets unsuccessful");
    }       
}
@end
