//
//  com_zerolinux5ViewController.m
//  bach
//
//  Created by Adrian Avendano on 02/03/2013.
//  Copyright (c) 2013 Jesus Magana. All rights reserved.
//

#import "com_zerolinux5ViewController.h"

@interface com_zerolinux5ViewController ()

@end

@implementation com_zerolinux5ViewController
@synthesize audioPlayer, x_value, y_value, z_value, allItems, sequencePlay, capSequence, savedNotes, queuePlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *aNote = [[NSBundle mainBundle] pathForResource:@"newpianoAMusic" ofType:@"mp3"];
    NSString *bNote = [[NSBundle mainBundle] pathForResource:@"newpianoBMusic" ofType:@"mp3"];
    NSString *cNote = [[NSBundle mainBundle] pathForResource:@"newpianomiddleCMusic" ofType:@"mp3"];
    NSString *dNote = [[NSBundle mainBundle] pathForResource:@"newpianoDMusic" ofType:@"mp3"];
    NSString *eNote = [[NSBundle mainBundle] pathForResource:@"newpianoEMusic" ofType:@"mp3"];
    NSString *fNote = [[NSBundle mainBundle] pathForResource:@"newpianoFMusic" ofType:@"mp3"];
    NSString *gNote = [[NSBundle mainBundle] pathForResource:@"newpianoGMusic" ofType:@"mp3"];        
   
    self.allItems = [[[NSArray alloc] initWithObjects:aNote, bNote, cNote, dNote, eNote, fNote, gNote, nil] autorelease];
    self.savedNotes = [[[NSMutableArray alloc] init] autorelease];
    
    UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
    accel.delegate = self;
    accel.updateInterval = .1;
    y_value = 0;
    x_value= 0;
    z_value = 0;
    sequencePlay = 0;
    capSequence = 3;    
}



- (void)playSound:(NSString*) mp3Url {
    self.audioPlayer = nil;        
    NSError *activationError = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:mp3Url] error:&activationError];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer setVolume:.8];
    [self.audioPlayer setDelegate:self];
    [self.audioPlayer setNumberOfLoops:1];      
    [self.audioPlayer play];
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration  {
    
    //NSLog(@" X value  %f: Y value %f: Z value:%f", acceleration.x, acceleration.y, acceleration.z);
   
    float y_valueTemp = ABS(acceleration.y);
    //NSLog(@"Y VALUE %f", y_valueTemp);
    
    //int y_valueTemp = ABS(acceleration.y);
    float x_valueTemp = ABS(acceleration.x);
    float z_valueTemp = ABS(acceleration.z);
    //NSLog(@"Z VALUE %f", z_valueTemp);
    
    float storedValueY = y_value;
    y_value = y_valueTemp;    
   
    z_value = z_valueTemp;
    
    NSLog(@"X value %f", x_valueTemp);
    
    if ((storedValueY - y_value) >= 0.75) {
       
        if (self.audioPlayer != nil){
            [self.audioPlayer stop];
        }        
        
        if (sequencePlay == capSequence) sequencePlay = 0;       
        NSLog(@"Y value increment has happened %f temp %f played sequence %i", y_value, y_valueTemp, sequencePlay);
        NSString *mp3Url = [self.allItems objectAtIndex:sequencePlay];
        [self playSound:mp3Url];
        sequencePlay++;
    }  
    
    if (x_valueTemp >= 0.72 && x_valueTemp <= 1.2){
        NSLog(@"Resetting sequence now X value");
        NSString *saving = [[NSBundle mainBundle] pathForResource:@"button-9" ofType:@"mp3"];
        [self playSound:saving];
        [self.savedNotes addObject:[self.allItems objectAtIndex:sequencePlay]];
    }
    
    //NSLog(@"Z VALUE stored %f temp %f", storedValueZ, z_value);
    if (z_valueTemp >= 0.76 && z_valueTemp <= 1.4){// reseting the loop sequence
        NSString *confirmation = [[NSBundle mainBundle] pathForResource:@"button-3" ofType:@"mp3"];
        [self playSound:confirmation];        
        
        NSLog(@"Resetting sequence now Z value");
        if (capSequence == 3) {
            capSequence = 7;
            sequencePlay = 3;
        } else {
            capSequence = 3;
            sequencePlay = 0;
        }
    }
    
    //self.audioPlayer
    
    
    
    //[self.audioPlayer play];
    //getting the file source 
      
}

- (IBAction)resetRecordedMusic {
    [self.savedNotes removeAllObjects];
}


- (IBAction)playRecordedMusic {    
    if ([savedNotes count] > 0) {        
        NSMutableArray *allSounds = [[[NSMutableArray alloc] init] autorelease];
        for (NSString *url in savedNotes) {
            NSURL *urlObj = [NSURL fileURLWithPath:url];
            AVPlayerItem *firstSound = [AVPlayerItem playerItemWithURL:urlObj];
            [allSounds addObject:firstSound];
        }
        
        self.queuePlayer = [AVQueuePlayer queuePlayerWithItems:allSounds];
        [self.queuePlayer play];
    }
}


- (void)dealloc {
    [queuePlayer release];
    [savedNotes release];
    [audioPlayer release];
    [super dealloc];
}



@end
