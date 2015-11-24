//
//  RollingAudioViewController.h
//  Stethaid
//
//  Created by Administrator on 6/11/15.
//  Copyright (c) 2015 Sheikh Zayed Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "IosAudioController.h"
#import "HeartSoundList.h"
#import "HeartSoundListViewController.h"
#import "PatientItem.h"
#import "PatientInfoViewController.h"

// Import EZAudio header
#import "EZAudio.h"

// Import AVFoundation to play the file (will save EZAudioFile and EZOutput for separate example)
#import <AVFoundation/AVFoundation.h>

// By default this will record a file to the application's documents directory (within the application's sandbox)
#define kAudioFilePath @"RecordingTest_"

@interface RollingAudioViewController : UIViewController <AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate, EZMicrophoneDelegate>

//A reference to the patient item of interest
@property (nonatomic, strong) PatientItem *item;

//Audio file name
@property (nonatomic) NSString* fileName;

//Location on the chest of the recording
@property NSString *location;

//Real-time playback while recording 
-(BOOL)isHeadsetPluggedIn;

//Did the user come to record by clicking "Quick Listen?"
@property (nonatomic, assign) BOOL quickListen;

/**
 Use a OpenGL based plot to visualize the data coming in
 */
@property (nonatomic,retain) IBOutlet EZAudioPlotGL *audioPlot;

/**
 A flag indicating whether we are recording or not
 */
@property (nonatomic,assign) BOOL isRecording;

/**
 The microphone component
 */
@property (nonatomic,strong) EZMicrophone *microphone;

- (IBAction)emailTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

/**
 The recorder component
 */
@property (nonatomic,strong) EZRecorder *recorder;

#pragma mark - Actions
/**
 Stops the recorder and starts playing whatever has been recorded.
 */
-(IBAction)playFile:(id)sender;

//Starts and stops recording audio
- (IBAction)recordPauseTapped:(id)sender;

- (void) saveFile;

@property (nonatomic, assign) BOOL fileSaved;

@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;

- (IBAction)resetTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)backTapped:(id)sender;



@end
