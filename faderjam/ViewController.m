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
@property (weak, nonatomic) IBOutlet UILabel *activeInstrumentLabel;
@property (strong, nonatomic) IBOutletCollection(UIProgressView) NSArray *drumProgress;
@property (strong, nonatomic) IBOutletCollection(UIProgressView) NSArray *bassProgress;
@property (strong, nonatomic) IBOutletCollection(UIProgressView) NSArray *leadProgress;
@property (strong, nonatomic) IBOutletCollection(UIProgressView) NSArray *padsProgress;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *mainSliders;
@end

@implementation ViewController

- (void) startAudioEngine {
    NSLog(@"VC: Starting Audio Engine");
    self.audioController = [[PdAudioController alloc] init];
    [self.audioController configurePlaybackWithSampleRate:SAMPLE_RATE numberChannels:SOUND_OUTPUT_CHANNELS inputEnabled:NO mixingEnabled:YES];
    [self.audioController configureTicksPerBuffer:TICKS_PER_BUFFER];
//    [self openPdPatch];
    [PdBase setDelegate:self];
    [PdBase subscribe:@"toGUI"];
    [PdBase subscribe:@"c1"];
    [PdBase subscribe:@"c5"];
    [PdBase subscribe:@"c9"];
    [PdBase subscribe:@"c13"];
    [PdBase openFile:PATCH_NAME path:[[NSBundle mainBundle] bundlePath]];
    [self.audioController setActive:YES];
    [self.audioController print];
    NSLog(@"VC: Ticks Per Buffer: %d",self.audioController.ticksPerBuffer);
}

#pragma mark - Pd Send/Receive Methods
-(void) receivePrint:(NSString *)message {
    NSLog(@"Pd: %@",message);
}

-(void) receiveList:(NSArray *)list fromSource:(NSString *)source {
    if ([source isEqualToString:@"toGUI"]) {
        if([(NSString *) list[0] isEqualToString:@"/currentlabel"]) {
            [self.activeInstrumentLabel setText:(NSString *) list[1]];
        }
    } else if ([source isEqualToString:@"c1"]) {
        NSString *label = (NSString *) list[0];
        NSNumber *value = (NSNumber *) list[1];
        NSArray *progressViews = self.drumProgress;
        if([label isEqualToString:@"/vol"]) {
            [((UIProgressView *) progressViews[0]) setProgress:[value floatValue]/127.0];
        } else if([label isEqualToString:@"/int"]) {
            [((UIProgressView *) progressViews[1]) setProgress:[value floatValue]/127.0];
        } else if([label isEqualToString:@"/hap"]) {
            [((UIProgressView *) progressViews[2]) setProgress:[value floatValue]/127.0];
        } else if([label isEqualToString:@"/jaz"]) {
            [((UIProgressView *) progressViews[3]) setProgress:[value floatValue]/127.0];
        }
        
    } else if ([source isEqualToString:@"c5"]) {
        NSString *label = (NSString *) list[0];
        NSNumber *value = (NSNumber *) list[1];
        NSArray *progressViews = self.bassProgress;
        if([label isEqualToString:@"/vol"]) {
            [((UIProgressView *) progressViews[0]) setProgress:[value floatValue]/127.0];
        } else if([label isEqualToString:@"/int"]) {
            [((UIProgressView *) progressViews[1]) setProgress:[value floatValue]/127.0];
        } else if([label isEqualToString:@"/hap"]) {
            [((UIProgressView *) progressViews[2]) setProgress:[value floatValue]/127.0];
        } else if([label isEqualToString:@"/jaz"]) {
            [((UIProgressView *) progressViews[3]) setProgress:[value floatValue]/127.0];
        }
        
    } else if ([source isEqualToString:@"c9"]) {
        NSString *label = (NSString *) list[0];
        NSNumber *value = (NSNumber *) list[1];
        NSArray *progressViews = self.leadProgress;
        if([label isEqualToString:@"/vol"]) {
            [((UIProgressView *) progressViews[0]) setProgress:[value floatValue]/127.0];
        } else if([label isEqualToString:@"/int"]) {
            [((UIProgressView *) progressViews[1]) setProgress:[value floatValue]/127.0];
        } else if([label isEqualToString:@"/hap"]) {
            [((UIProgressView *) progressViews[2]) setProgress:[value floatValue]/127.0];
        } else if([label isEqualToString:@"/jaz"]) {
            [((UIProgressView *) progressViews[3]) setProgress:[value floatValue]/127.0];
        }
        
    } else if ([source isEqualToString:@"c13"]) {
        NSString *label = (NSString *) list[0];
        NSNumber *value = (NSNumber *) list[1];
        NSArray *progressViews = self.padsProgress;
        if([label isEqualToString:@"/vol"]) {
            [((UIProgressView *) progressViews[0]) setProgress:[value floatValue]/127.0];
        } else if([label isEqualToString:@"/int"]) {
            [((UIProgressView *) progressViews[1]) setProgress:[value floatValue]/127.0];
        } else if([label isEqualToString:@"/hap"]) {
            [((UIProgressView *) progressViews[2]) setProgress:[value floatValue]/127.0];
        } else if([label isEqualToString:@"/jaz"]) {
            [((UIProgressView *) progressViews[3]) setProgress:[value floatValue]/127.0];
        }

        
    }
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

- (IBAction)volSliderChanged:(UISlider *)sender {
    [PdBase sendList:@[@"/slider1",[NSNumber numberWithFloat:[sender value]]] toReceiver:@"fromGUI"];
}
- (IBAction)intSliderChanged:(UISlider *)sender {
    [PdBase sendList:@[@"/slider2",[NSNumber numberWithFloat:[sender value]]] toReceiver:@"fromGUI"];
}
- (IBAction)hapSliderChanged:(UISlider *)sender {
    [PdBase sendList:@[@"/slider3",[NSNumber numberWithFloat:[sender value]]] toReceiver:@"fromGUI"];
}
- (IBAction)jazSliderChanged:(UISlider *)sender {
    [PdBase sendList:@[@"/slider4",[NSNumber numberWithFloat:[sender value]]] toReceiver:@"fromGUI"];
}
- (IBAction)changeButtonTap:(UIButton *)sender {
    [PdBase sendList:@[@"/change",@1] toReceiver:@"fromGUI"];
    [PdBase sendList:@[@"/slider1",[NSNumber numberWithFloat:[(UISlider *) self.mainSliders[0] value]]] toReceiver:@"fromGUI"];
    [PdBase sendList:@[@"/slider2",[NSNumber numberWithFloat:[(UISlider *) self.mainSliders[1] value]]] toReceiver:@"fromGUI"];
    [PdBase sendList:@[@"/slider3",[NSNumber numberWithFloat:[(UISlider *) self.mainSliders[2]  value]]] toReceiver:@"fromGUI"];
    [PdBase sendList:@[@"/slider4",[NSNumber numberWithFloat:[(UISlider *) self.mainSliders[3]  value]]] toReceiver:@"fromGUI"];
    for (UISlider * slider in self.mainSliders) {
        [slider setEnabled:YES];
    }
}
- (IBAction)autoButtonTap:(UIButton *)sender {
    [PdBase sendList:@[@"/auto",@1] toReceiver:@"fromGUI"];
    for (UISlider * slider in self.mainSliders) {
        [slider setEnabled:NO];
    }
}

@end
