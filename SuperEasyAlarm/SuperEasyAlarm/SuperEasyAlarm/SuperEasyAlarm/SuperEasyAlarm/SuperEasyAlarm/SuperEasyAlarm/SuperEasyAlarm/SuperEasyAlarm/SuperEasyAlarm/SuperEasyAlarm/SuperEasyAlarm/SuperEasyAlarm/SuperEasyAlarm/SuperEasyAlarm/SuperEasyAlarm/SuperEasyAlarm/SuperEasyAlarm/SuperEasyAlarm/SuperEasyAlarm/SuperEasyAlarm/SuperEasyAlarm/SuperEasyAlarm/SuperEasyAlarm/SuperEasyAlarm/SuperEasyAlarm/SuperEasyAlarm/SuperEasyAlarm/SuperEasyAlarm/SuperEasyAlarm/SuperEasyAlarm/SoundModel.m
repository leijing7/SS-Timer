//
//  SoundModel.m
//  SuperEasyAlarm
//
//  Created by Lei Jing on 24/08/12.
//  Copyright (c) 2012 UWS. All rights reserved.
//

#import "SoundModel.h"

@implementation SoundModel

+ (SoundModel *)sharedModel
{
    static SoundModel *sharedModel = nil;
    if (!sharedModel) {
        sharedModel = [[super allocWithZone:nil] init];
    }
    return sharedModel;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedModel];
}

- (void)start
{
    NSString *soundFileName = @"watchalarm";
    NSString *extension = @"aif";
    if (!soundID) {
    NSString *sndpath = [[NSBundle mainBundle] pathForResource:soundFileName ofType:extension];
    CFURLRef baseURL = (__bridge CFURLRef)[NSURL fileURLWithPath:sndpath];
    
    AudioServicesCreateSystemSoundID(baseURL, &soundID);
	AudioServicesPropertyID flag = 0;  // 0 means always play
	AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &soundID, sizeof(AudioServicesPropertyID), &flag);
    
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    if (musicPlayer.playbackState == MPMusicPlaybackStatePlaying)
		AudioServicesPlayAlertSound(soundID);
	else
		AudioServicesPlaySystemSound(soundID);
    //CFRelease(baseURL);  //release this will crash WHEN dispose the audio.
    //the basrURL and sndpath NSURL is the same object. don't release it.
    } else {
        NSLog(@"sound already started");
    }
}


- (void)stop
{
    if (soundID){
        AudioServicesDisposeSystemSoundID(soundID);
        soundID = 0;
        musicPlayer = nil;
    }
}

@end
