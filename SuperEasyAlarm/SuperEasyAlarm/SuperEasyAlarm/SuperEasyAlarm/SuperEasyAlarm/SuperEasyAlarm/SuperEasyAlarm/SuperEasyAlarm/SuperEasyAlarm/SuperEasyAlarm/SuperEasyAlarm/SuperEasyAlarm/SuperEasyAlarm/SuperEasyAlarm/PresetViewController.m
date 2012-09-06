//
//  PresetViewController.m
//  SuperEasyAlarm
//
//  Created by Lei Jing on 22/08/12.
//  Copyright (c) 2012 UWS. All rights reserved.
//

#import "PresetViewController.h"
#import "TimeModel.h"

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
        
        startImage = [UIImage imageNamed:@"start.png"];
        pauseImage = [UIImage imageNamed:@"pauseb.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *noteName = [[TimeModel sharedModel] notificationName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAllChanges) name:noteName object:[TimeModel sharedModel]];
    [startStopButton setImage:startImage forState:UIControlStateNormal];
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
    if ([[TimeModel sharedModel] isStarted]) {
        [startStopButton setImage:pauseImage forState:UIControlStateNormal];
        [destTimeLabel setText:[[TimeModel sharedModel] destDateString]];
    } else {
        [startStopButton setImage:startImage forState:UIControlStateNormal];
        [destTimeLabel setText:@""];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)set3m:(id)sender {
    [self startCountDown:180];
}

- (IBAction)set5m:(id)sender {
    [self startCountDown:300];
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
    [self startCountDown:set1];
}

- (IBAction)set2:(id)sender {
    [self startCountDown:set2];
}

- (IBAction)set3:(id)sender {
    [self startCountDown:set3];
}

- (IBAction)set4:(id)sender {
    [self startCountDown:set4];
}

- (IBAction)startStopButton:(id)sender {
    if ([[TimeModel sharedModel] isStarted]) {
        [startStopButton setImage:startImage forState:UIControlStateNormal];
        [[TimeModel sharedModel] stopCountDown];
        [[TimeModel sharedModel] setIsStarted:false];
        [destTimeLabel setText:@""];
    }
    else {
        [[TimeModel sharedModel] startCountDown];
        [startStopButton setImage:pauseImage forState:UIControlStateNormal];
        [destTimeLabel setText:[[TimeModel sharedModel] destDateString]];
        [[TimeModel sharedModel] setIsStarted:true];
    }    
}

- (void)updateAllChanges
{
//    if ([[TimeModel sharedModel] totalSeconds] <= 0) {
//        isStarted = false;
//        [[SoundModel sharedModel] start];
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Time is up" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alertView  show];
//        return;
//    }
    [totalTimeLabel setText:[[TimeModel sharedModel] totalSecondsString]];
    
}

- (void)updateInForground
{
//    if ([[TimeModel sharedModel] isPassedDestDate]) {
//        isStarted = false;
//        [startStopButton setImage:startImage forState:UIControlStateNormal];
//        [destTimeLabel setText:@""];
//        [[TimeModel sharedModel] setTotalSeconds:1800];
//    }
//    [self updateAllChanges];
}

- (void)startCountDown:(NSInteger)tSeconds
{
    [[TimeModel sharedModel] setTotalSeconds:tSeconds];
    [[TimeModel sharedModel] startCountDown];
    //[startStopButton setImage:stopImage forState:UIControlStateNormal];
    [destTimeLabel setText:[[TimeModel sharedModel] destDateString]];
    [[TimeModel sharedModel] setIsStarted:true];
}

@end
