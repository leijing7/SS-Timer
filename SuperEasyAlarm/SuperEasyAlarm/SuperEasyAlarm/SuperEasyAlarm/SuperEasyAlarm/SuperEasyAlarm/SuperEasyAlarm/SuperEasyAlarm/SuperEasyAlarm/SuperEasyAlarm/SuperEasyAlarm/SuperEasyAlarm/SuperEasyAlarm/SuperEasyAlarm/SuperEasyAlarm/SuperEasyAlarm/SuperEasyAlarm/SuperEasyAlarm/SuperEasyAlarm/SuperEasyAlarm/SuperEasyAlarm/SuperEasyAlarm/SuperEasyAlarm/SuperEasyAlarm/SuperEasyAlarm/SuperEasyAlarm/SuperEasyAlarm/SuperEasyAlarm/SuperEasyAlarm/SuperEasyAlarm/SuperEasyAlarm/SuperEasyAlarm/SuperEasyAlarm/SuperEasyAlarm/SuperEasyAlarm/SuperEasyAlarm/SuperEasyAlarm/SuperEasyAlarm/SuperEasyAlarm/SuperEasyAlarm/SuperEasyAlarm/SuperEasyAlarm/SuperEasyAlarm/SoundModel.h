//
//  SoundModel.h
//  SuperEasyAlarm
//
//  Created by Lei Jing on 24/08/12.
//  Copyright (c) 2012 UWS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SoundModel : NSObject
{
    SystemSoundID soundID;
    MPMusicPlayerController *musicPlayer;
}

+ (SoundModel *)sharedModel;

- (void)start;
- (void)stop;

@end
