//
//  ViewController.h
//  DiStills
//
//  Created by Administrator on 2/4/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FDWaveformView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "HeartSoundItem.h"
//#include "RETrimControl.h"

@interface RecordingViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate>

//Audio file name
@property (nonatomic) NSString* fileName;

//A placeholder for the waveform display
@property (weak, nonatomic) IBOutlet UIImageView *waveformPlaceholder;

//The real waveform display
@property (weak, nonatomic) IBOutlet FDWaveformView *waveformBox;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UIView *mainView;


// The audio controls
@property (weak, nonatomic) IBOutlet UIProgressView *audioProgress;
@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *analyzeButton;
@property (weak, nonatomic) IBOutlet UIButton *cropButton;

- (IBAction)cropTapped:(id)sender;
- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;
- (IBAction)playTapped:(id)sender;
- (IBAction)emailTapped:(id)sender;
- (IBAction)changeSwitch:(id)sender;

-(BOOL)isHeadsetPluggedIn;
 
@end

