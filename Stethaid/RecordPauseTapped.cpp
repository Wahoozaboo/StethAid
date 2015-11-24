//
//  RecordPauseTapped.cpp
//  Stethaid
//
//  Created by Administrator on 7/14/15.
//  Copyright (c) 2015 Sheikh Zayed Institute. All rights reserved.
//

#include "RecordPauseTapped.h"

/*

//NSLog(@"Record/pause tapped!");

// Stop the audio player before recording
self.playingTextField.text = @"Not Playing";
if( self.audioPlayer )
{
    if( self.audioPlayer.playing )
    {
        [self.audioPlayer stop];
    }
    self.audioPlayer = nil;
}
self.playButton.hidden = NO;

//Keep track of the button state (Recording (1) vs. Stoppped (2))
if (!(buttonLogic == 1) && !(buttonLogic == 2)) {
    buttonLogic = 2;}

//NSLog(@"ButtonLogic = %ld", (long)buttonLogic);

switch (buttonLogic) {
    case 1:
    {
        // Pause recording
        //[recorder pause];
        //[self.recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
        //UIImage *recordImage = [UIImage imageNamed:@"RecordIcon.png"];
        //[self.recordPauseButton setImage:recordImage forState:UIControlStateNormal];
        
        //Stop recording
        [self.recorder closeAudioFile];
        [self.microphone stopFetchingAudio];
        self.microphoneTextField.text = @"Microphone Off";
        
        //NSLog(@"Stopped recording!");
        
        //Stop playing
        [iosAudio stop];
        
        //[session setActive:NO error:nil];
        
        //Set the record button back to Record
        UIImage *recordImage = [UIImage imageNamed:@"RecordRed256.png"];
        [self.recordPauseButton setImage:recordImage forState:UIControlStateNormal];
        buttonLogic = 2;
        
        //Ditch the logo, that was just a place holder
        //_logoImage.image = nil;
        
        //NSLog(@"WFURL: %@", _waveformBox.audioURL);
        self.saveButton.enabled = YES;
        //self.audioProgress.hidden = NO;
        self.playButton.enabled = YES;
        //self.emailButton.enabled = YES;
        
        break;
    }
        
    case 2:
    {
        
        // Make a path to save the audio file in the sandbox, but save the extension separately so that you can still find the file, should the sandbox change in the future.
        
        //Prepare a path to save the audio file in the sandbox
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath_ = [searchPaths objectAtIndex: 0];
        //NSLog(@"Document path: %@", documentPath_);
        
        //pathToSave = [documentPath_ stringByAppendingPathComponent:[self dateString]]; //OLD VERSION
        pathExtension = [self dateString];
        pathToSave = [documentPath_ stringByAppendingPathComponent:pathExtension];
        
        // File URL
        outputfileURL = [NSURL fileURLWithPath:pathToSave];//FILEPATH];
        
        
        //Set input gain
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //NSLog(@"Input gain is settable: %hhd", audioSession.isInputGainSettable);
        if (audioSession.isInputGainSettable) {
            NSLog(@"Input gain is settable");
            NSError *error = nil;
            BOOL success = [audioSession setInputGain:1.0 error:&error];
            if (!success) {
                NSLog(@"%@", error);
                
            }
            CGFloat currentGain = [audioSession inputGain];
            NSLog(@"The current input gain is: %f", currentGain);
        }
        else {
            NSLog(@"Cannot set input gain");
        }
        
        
        
        //Recorder
        self.recorder = [EZRecorder recorderWithDestinationURL:outputfileURL
                                                  sourceFormat:self.microphone.audioStreamBasicDescription
                                           destinationFileType:EZRecorderFileTypeWAV];
        NSLog(@"The original path is: %@", pathToSave);
        
        [self.microphone startFetchingAudio];
        self.microphoneSwitch.on = YES;
        self.microphoneTextField.text = @"Microphone On";
        
        //Change the color of the waveform
        self.audioPlot.color = [UIColor redColor];
        
        //Start playing TRIAL CODE
        //insert if statement to detect headphones
        if ([self isHeadsetPluggedIn]) {
            [iosAudio start];
        }
        
        
        //NSLog(@"RECORDING!");
        //if (self.recorder.IsRecording) //{NSLog(@"Really, though. Recorder.recording = YES!");};
        //[self.recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        UIImage *pauseImage = [UIImage imageNamed:@"StopRed256.png"];
        [self.recordPauseButton setImage:pauseImage forState:UIControlStateNormal];
        buttonLogic = 1;
        self.saveButton.enabled = NO;
        //self.audioProgress.hidden = YES;
        self.playButton.enabled = NO;
        //self.emailButton.enabled = NO;
        
        break;
    }
        
    default:
    {
        NSLog(@"Houston, we have a problem.");
        break;
    }
}

*/