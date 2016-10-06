//
//  ViewController.h
//  faderjam
//
//  Created by Charles Martin on 6/10/16.
//  Copyright © 2016 Charles Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdAudioController.h"
#import "PdBase.h"
#import "PdFile.h"


@interface ViewController : UIViewController <PdReceiverDelegate>
@property (strong, nonatomic) PdAudioController *audioController;
@property (strong, nonatomic) PdFile *openFile;
@end

