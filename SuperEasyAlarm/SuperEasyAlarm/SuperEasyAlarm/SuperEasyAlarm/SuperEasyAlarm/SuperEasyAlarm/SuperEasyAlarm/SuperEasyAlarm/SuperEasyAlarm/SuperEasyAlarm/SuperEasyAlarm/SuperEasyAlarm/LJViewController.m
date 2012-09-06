//
//  LJViewController.m
//  SuperEasyAlarm
//
//  Created by Lei Jing on 11/07/12.
//  Copyright (c) 2012 UWS. All rights reserved.
//

#import "LJViewController.h"
#import "TimeModel.h"
#import "SoundModel.h"
#import "SharedViewController.h"

@interface LJViewController ()

@end

@implementation LJViewController

@synthesize saveButton;
@synthesize startStopButton;

@synthesize secondLabel;
@synthesize minuteLabel;
@synthesize hourLabel;
@synthesize destTimeLabel;
@synthesize secondSliderObj;
@synthesize minuteSliderObj;
@synthesize hourSliderObj;
@synthesize totalTimeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
     
    if (self) {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Set Time"];
        [tbi setImage:[UIImage imageNamed:@"Time.png"]];
        
        defaultTotalSeconds = 1800; //30 minutes
        
        [[SharedViewController sharedController] setStartStopButton:startStopButton];
        
    }
    return self;
}

- (void)updateAllChanges
{
    [secondLabel setText:[[TimeModel sharedModel] secondsString]];
    [minuteLabel setText:[[TimeModel sharedModel] minutesString]];
    [hourLabel setText:[[TimeModel sharedModel] hoursString]];
    [totalTimeLabel setText:[[TimeModel sharedModel] totalSecondsString]];
    
    [secondSliderObj setValue:[[TimeModel sharedModel] seconds]];
    [minuteSliderObj setValue:[[TimeModel sharedModel] minutes]];
    [hourSliderObj setValue:[[TimeModel sharedModel] hours]];
    
    if ([[TimeModel sharedModel] totalSeconds] <= 0) {
        //isStarted = false;
        [[TimeModel sharedModel] stopCountDown];
        [[SoundModel sharedModel] start];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Time is up" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView  show];
        return;
    }    
}

//remember to handle memory warning situation
//this app won't reload when received memory warning
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[self view] setBackgroundColor:[UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1]];
    //[[self view] setBackgroundColor:[UIColor colorWithRed:0.3f green:0.4f blue:0.6f alpha:1.0f]];
    
    [[TimeModel sharedModel] setTotalSeconds:defaultTotalSeconds];
    [self updateAllChanges];
    
    //[startStopButton setImage:startImage forState:UIControlStateNormal];

    UIImage *saveImg = [UIImage imageNamed:@"save.png"];
    [saveButton setImage:saveImg forState:UIControlStateNormal];
    //[saveButton setBackgroundColor:[UIColor colorWithRed:0.3f green:0.4f blue:0.4f alpha:1.0f]];
    
    NSString *noteName = [[TimeModel sharedModel] notificationName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAllChanges) name:noteName object:[TimeModel sharedModel]];
}

- (void)viewDidUnload
{
    [self setMinuteLabel:nil];
    [self setHourLabel:nil];
    [self setTotalTimeLabel:nil];
    [self setSecondLabel:nil];
    [self setStartStopButton:nil];
    [self setSecondSliderObj:nil];
    [self setMinuteSliderObj:nil];
    [self setHourSliderObj:nil];
    [self setDestTimeLabel:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)updateSliderChange
{
    [totalTimeLabel setText:[[TimeModel sharedModel] totalSecondsString]];
    //if (isStarted) {
    if ([[TimeModel sharedModel] isStarted]) {
        [destTimeLabel setText:[[TimeModel sharedModel] destDateString]];
    }
}

- (IBAction)secondSlider:(id)sender {
    UISlider *slider = sender;
    NSInteger s = (int)roundf(slider.value);
    [[TimeModel sharedModel] setSeconds:s];
    [secondLabel setText:[[TimeModel sharedModel] secondsString]];
    [self updateSliderChange];
}

- (IBAction)minuteSlider:(id)sender {
    UISlider *slider = sender;
    NSInteger m = (int)roundf(slider.value);
    [[TimeModel sharedModel] setMinutes:m];
    [minuteLabel setText:[[TimeModel sharedModel] minutesString]];
    [self updateSliderChange];
}

- (IBAction)hourSlider:(id)sender {
    UISlider *slider = sender;
    NSInteger h = (int)roundf(slider.value);
    [[TimeModel sharedModel] setHours:h];
    [hourLabel setText:[[TimeModel sharedModel] hoursString]];
    [self updateSliderChange];
}

- (IBAction)startCountDown:(id)sender {    
    //if (isStarted) {
    if ([[TimeModel sharedModel] isStarted]) {
   //     [startStopButton setImage:startImage forState:UIControlStateNormal];
        [[TimeModel sharedModel] stopCountDown];
        //isStarted = false;
        [[TimeModel sharedModel] setIsStarted:false];
        [destTimeLabel setText:@""];
    }
    else {
        [[TimeModel sharedModel] startCountDown];
   //     [startStopButton setImage:stopImage forState:UIControlStateNormal];
        [destTimeLabel setText:[[TimeModel sharedModel] destDateString]];
        //isStarted = true;
        [[TimeModel sharedModel] setIsStarted:true];
    }
}

- (IBAction)savePresetInterval:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Save this preset?"
                                  delegate:self
                                  cancelButtonTitle:@"No"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Yes", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( 0 == buttonIndex) {
        NSLog(@"yes pressed");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[SoundModel sharedModel] stop];
    
//    [startStopButton setImage:startImage forState:UIControlStateNormal];
    [[TimeModel sharedModel] setTotalSeconds:defaultTotalSeconds];
    [destTimeLabel setText:@""];
    [self updateAllChanges];

}

- (void)updateInForground
{
    if ([[TimeModel sharedModel] isPassedDestDate]) {
        //isStarted = false;
        [[TimeModel sharedModel] setIsStarted:false];
 //       [startStopButton setImage:startImage forState:UIControlStateNormal];
        [destTimeLabel setText:@""];
        [[TimeModel sharedModel] setTotalSeconds:1800];
    }
    [self updateAllChanges];
}
 
@end
