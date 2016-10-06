//
//  ViewController.m
//  faderjam
//
//  Created by Charles Martin on 6/10/16.
//  Copyright © 2016 Charles Martin. All rights reserved.
//
#define BACKGROUND_SOUND_ALWAYS_ON YES
#define SAMPLE_RATE 44100
#define SOUND_OUTPUT_CHANNELS 2
#define TICKS_PER_BUFFER 4
#define PATCH_NAME @"fader-jam.pd"

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) startAudioEngine {
    NSLog(@"VC: Starting Audio Engine");
    self.audioController = [[PdAudioController alloc] init];
    [self.audioController configurePlaybackWithSampleRate:SAMPLE_RATE numberChannels:SOUND_OUTPUT_CHANNELS inputEnabled:NO mixingEnabled:YES];
    [self.audioController configureTicksPerBuffer:TICKS_PER_BUFFER];
//    [self openPdPatch];
    [PdBase openFile:PATCH_NAME path:[[NSBundle mainBundle] bundlePath]];
    [self.audioController setActive:YES];
    [self.audioController print];
    NSLog(@"VC: Ticks Per Buffer: %d",self.audioController.ticksPerBuffer);
    [PdBase setDelegate:self];
}

#pragma mark - Pd Send/Receive Methods
-(void) receivePrint:(NSString *)message {
    NSLog(@"Pd: %@",message);
}

- (void) shutdownSoundProcessing {
    if (!BACKGROUND_SOUND_ALWAYS_ON) {
        [self.audioController setActive:YES];
    }
}

- (void) restartSoundProcessing {
    if (!self.audioController.isActive) {
        [self openPdPatch];
        [self.audioController setActive:YES];
    }
}

- (void) openPdPatch {
    [[NSUserDefaults standardUserDefaults] synchronize];
    //NSInteger soundScheme = [[NSUserDefaults standardUserDefaults] integerForKey:@"sound"];
    NSString *patchName = PATCH_NAME;
    NSLog(@"PATCH OPENING: %@", patchName);
    
    if (![self.openFile.baseName isEqualToString:patchName]) {
        NSLog(@"PATCH OPENING: Patch not open, opening now.");
        [self.openFile closeFile];
        self.openFile = [PdFile openFileNamed:patchName path:[[NSBundle mainBundle] bundlePath]];
    } else {
        NSLog(@"PATCH OPENING: Patch already open, doing nothing.");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self startAudioEngine];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
