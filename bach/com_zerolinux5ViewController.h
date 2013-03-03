//
//  com_zerolinux5ViewController.h
//  bach
//
//  Created by Adrian Avendano on 02/03/2013.
//  Copyright (c) 2013 Jesus Magana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface com_zerolinux5ViewController : UIViewController <UIAccelerometerDelegate, AVAudioPlayerDelegate> {

    AVAudioPlayer *audioPlayer;
    float y_value;
    int x_value;
    float z_value;
    int capSequence;
    
    int sequencePlay;   
    NSArray *allItems;
    NSMutableArray *savedNotes;
    AVQueuePlayer *queuePlayer;
}


@property int capSequence;
@property int sequencePlay;
@property float y_value;
@property int x_value;
@property float z_value;
@property (nonatomic, retain) AVQueuePlayer *queuePlayer;
@property (nonatomic, retain) NSMutableArray *savedNotes;
@property (nonatomic, retain) NSArray *allItems;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@end
