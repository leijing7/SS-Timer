//
//  PresetViewController.m
//  SuperEasyAlarm
//
//  Created by Lei Jing on 22/08/12.
//  Copyright (c) 2012 UWS. All rights reserved.
//

#import "PresetViewController.h"
#import "TimeModel.h"
#import "SoundModel.h"
#import "SharedViewController.h"

@interface PresetViewController ()

@end

@implementation PresetViewController
@synthesize setButton1;
@synthesize setButton2;
@synthesize setButton3;
@synthesize setButton4;
@synthesize startStopButton;
@synthesize totalTimeLabel;
@synthesize destTimeLabel;
@synthesize set1,set2,set3,set4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Preset"];
        [tbi setImage:[UIImage imageNamed:@"preset.png"]];
        set1 = set2 = set3 = set4 = 0;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand"]]];
    
    [[SharedViewController sharedController] loadStoppedTotalTimeLabel:totalTimeLabel destTimeLabel:destTimeLabel startStopButton:startStopButton];
}

- (void)viewDidUnload
{
    [self setSetButton1:nil];
    [self setSetButton2:nil];
    [self setSetButton3:nil];
    [self setSetButton4:nil];
    [self setTotalTimeLabel:nil];
    [self setDestTimeLabel:nil];
    [self setStartStopButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updatePreset];
    
    [[SharedViewController sharedController] loadTotalTimeLabel:totalTimeLabel destTimeLabel:destTimeLabel startStopButton:startStopButton];
    NSString *noteName = [[TimeModel sharedModel] notificationName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAllChanges) name:noteName object:[TimeModel sharedModel]];

}

- (NSString *)secondsToSmhString:(NSInteger) tSeconds
{
    NSInteger hours = tSeconds / 3600;
    NSInteger minutes = (tSeconds - hours*3600) / 60;
    NSInteger seconds = tSeconds - hours*3600 - minutes*60;
    
    return [NSString stringWithFormat:@"%@%@%@%@%@", [[TimeModel sharedModel] intToString2:hours], @":", [[TimeModel sharedModel] intToString2:minutes], @":", [[TimeModel sharedModel] intToString2:seconds]];
}

- (void)updatePreset
{
    NSMutableArray *setArr = [[TimeModel sharedModel] presetTimeArray];
    set1 = [[setArr objectAtIndex:0] integerValue];
    set2 = [[setArr objectAtIndex:1] integerValue];
    set3 = [[setArr objectAtIndex:2] integerValue];
    set4 = [[setArr objectAtIndex:3] integerValue];
    
    if (set1 != 0) {
        [setButton1 setTitle:[self secondsToSmhString:set1] forState:UIControlStateNormal];
    }
    if (set2 != 0) {
        [setButton2 setTitle:[self secondsToSmhString:set2] forState:UIControlStateNormal];
    }
    if (set3 != 0) {
        [setButton3 setTitle:[self secondsToSmhString:set3] forState:UIControlStateNormal];
    }
    if (set4 != 0) {
        [setButton4 setTitle:[self secondsToSmhString:set4] forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)set3m:(id)sender {
    [self startCountDown:180];
    //[self startCountDown:6];
}

- (IBAction)set5m:(id)sender {
    [self startCountDown:300];
    //[self startCountDown:6];
}

- (IBAction)set8m:(id)sender {
    [self startCountDown:480];
}

- (IBAction)set10m:(id)sender {
    [self startCountDown:600];
}

- (IBAction)set15m:(id)sender {
    [self startCountDown:900];
}

- (IBAction)set20m:(id)sender {
    [self startCountDown:1200];
}


- (IBAction)set30m:(id)sender {
    [self startCountDown:1800];
}

- (IBAction)set45m:(id)sender {
    [self startCountDown:2700];
}


- (IBAction)set1hr:(id)sender {
    [self startCountDown:3600];
}

- (IBAction)set1hrAndHalf:(id)sender {
    [self startCountDown:5400];
}

- (IBAction)set2hr:(id)sender {
    [self startCountDown:7200];
}

- (IBAction)set8hr:(id)sender {
    [self startCountDown:28800];
}

- (IBAction)set1:(id)sender {
    if (set1>0) {
        [self startCountDown:set1];
    }
}

- (IBAction)set2:(id)sender {
    if (set2>0) {
        [self startCountDown:set2];
    }
}

- (IBAction)set3:(id)sender {
    if (set3>0) {
        [self startCountDown:set3];
    }
}

- (IBAction)set4:(id)sender {
    if (set4>0) {
        [self startCountDown:set4];
    }
}

- (IBAction)startStopButton:(id)sender {
    [[SharedViewController sharedController] startPauseTotalTimeLabel:totalTimeLabel destTimeLabel:destTimeLabel startStopButton:startStopButton];
}

- (void)updateAllChanges
{
    [totalTimeLabel setText:[[TimeModel sharedModel] totalSecondsString]];
    
    if ([[TimeModel sharedModel] totalSeconds] <= 0 && [[TimeModel sharedModel] isStarted]) {
        [[TimeModel sharedModel] startStopCountDown];
        [[SoundModel sharedModel] start];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Time is up" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView  show];
        return;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[SoundModel sharedModel] stop];
    
    [[TimeModel sharedModel] set1800];
    [[SharedViewController sharedController] loadStoppedTotalTimeLabel:totalTimeLabel destTimeLabel:destTimeLabel startStopButton:startStopButton];
    [self updateAllChanges];
}

- (void)updateInForground
{
    if ([[TimeModel sharedModel] isPassedDestDate]) {
        [[SharedViewController sharedController] loadTotalTimeLabel:totalTimeLabel destTimeLabel:destTimeLabel startStopButton:startStopButton];
    }
    [self updateAllChanges];
}

- (void)startCountDown:(NSInteger)tSeconds
{
    if ([[TimeModel sharedModel] isStarted]) { //if is started, stop it
        [[TimeModel sharedModel] startStopCountDown];
    }
    [[TimeModel sharedModel] setTotalSeconds:tSeconds];
    [[SharedViewController sharedController] startPauseTotalTimeLabel:totalTimeLabel destTimeLabel:destTimeLabel startStopButton:startStopButton];
}

@end
