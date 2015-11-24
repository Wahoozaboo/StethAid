//
//  PlaybackViewController.h
//  Stethaid
//
//  Created by Administrator on 4/10/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FDWaveformView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "HeartSoundItem.h"
#import "EZAudioPlotGL.h"
#import "EZAudioFile.h"
#import "PatientItem.h"
#import "LocationChangeViewController.h"
#import "PatientInfoViewController.h"


@class HeartSoundItem;

@interface PlaybackViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate>

//A reference to the patient item of interest
@property (nonatomic, strong) PatientItem *patientItem;

@property NSString *location;
@property int indexInHSAray;

@property (nonatomic, strong) HeartSoundItem *HSitem;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet EZAudioPlotGL *audioPlot;
@property EZAudioFile *audioFile;

@end
