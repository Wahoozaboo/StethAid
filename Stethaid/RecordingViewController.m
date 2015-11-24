//
//  RecordingViewController.m
//  DiStills
//
//  Created by Administrator on 2/4/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

#import "RecordingViewController.h"
#import "HeartSoundList.h"
#import "HeartSoundListViewController.h"
#import "IosAudioController.h"

@interface RecordingViewController () <UITextFieldDelegate, UIAlertViewDelegate>
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    NSURL *outputfileURL;
    NSString* pathToSave;
    NSString* pathExtension;
    NSInteger buttonLogic;
    AVAudioSession *session;
}


@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@property MFMailComposeViewController *mailViewController;
@property (weak, nonatomic) IBOutlet UIView *mpVolumeViewParentView;


@end

@implementation RecordingViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Stethaid Logo.png"]];
    //UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yourimage2.jpg"]]];
    //self.navigationItem.rightBarButtonItem = item;
    
    // Set buttons when application launches
    self.saveButton.enabled = NO;
    self.playButton.enabled = NO;
    self.emailButton.enabled = NO;
    self.audioProgress.progress = 0;
    self.audioProgress.hidden = YES;
    self.analyzeButton.enabled = NO;
    
    //Set the logo image
    _logoImage.image = [UIImage imageNamed:@"heart_beat_logo.png"];
    
    // Some settings for the waveform display
    self.waveformBox.doesAllowStretchAndScroll = YES;
    self.waveformBox.doesAllowScrubbing = YES;
    
    //Volume control
    self.mpVolumeViewParentView.backgroundColor = [UIColor clearColor];
    MPVolumeView *myVolumeView = [[MPVolumeView alloc] initWithFrame: self.mpVolumeViewParentView.bounds];
    [self.mpVolumeViewParentView addSubview: myVolumeView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Clear first responder
    [self.view endEditing:YES];
    
    [player stop];
    //Set the play button back to Play
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    UIImage *playImage = [UIImage imageNamed:@"PlayIcon.png"];
    [self.playButton setImage:playImage forState:UIControlStateNormal];
    
    [iosAudio stop];
    
    [recorder stop];
    //Set the record button back to Record
    UIImage *recordImage = [UIImage imageNamed:@"RecordRed256.png"];
    [self.recordPauseButton setImage:recordImage forState:UIControlStateNormal];
    buttonLogic = 2;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//Low-Pass filter the wav file
/*
- (void)processDataWithInBuffer:(const int16_t *)buffer outBuffer:(int16_t *)outBuffer sampleCount:(int)len {
    BOOL positive;
    for(int i = 0; i < len; i++) {
        positive = (buffer[i] >= 0);
        currentFilteredValueOfSampleAmplitude = LOWPASSFILTERTIMESLICE * (float)abs(buffer[i]) + (1.0 - LOWPASSFILTERTIMESLICE) * previousFilteredValueOfSampleAmplitude;
        previousFilteredValueOfSampleAmplitude = currentFilteredValueOfSampleAmplitude;
        outBuffer[i] = currentFilteredValueOfSampleAmplitude * (positive ? 1 : -1);
    }
}
*/


- (IBAction)saveTapped:(id)sender {
    
    //NSLog(@"Save tapped!");
    
    //Get a file name from a UIAlert with a textfield
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"Please enter a name for the file:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 12;
    
    [alert addButtonWithTitle:@"Ok"];
    [alert show];
    
    
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 12) {
        if (buttonIndex == 1) {
            UITextField *textfield = [alertView textFieldAtIndex:0];
            self.fileName = textfield.text;
            //NSLog(@"Filename: %@", textfield.text);
            
            //Create an entry in the Heart Sound Recording directory
            [[HeartSoundList sharedList] createHeartSoundItemWithName: self.fileName subtitleText:NULL pathForAudio:pathExtension];
        }
    }
}

 
- (IBAction)playTapped:(id)sender {
    
    //NSLog(@"Play tapped!");
    
     //overrideOutputAudioPort: error: (use this method to make the iPhone speaker the default output)
    
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        UIButton* playButton = (UIButton*)sender;
        
        if(![playButton.titleLabel.text  isEqual: @"Play"]){//player.playing){
            [player pause];
            [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
            UIImage *playImage = [UIImage imageNamed:@"PlayIcon.png"];
            [self.playButton setImage:playImage forState:UIControlStateNormal];
            
            self.audioProgress.hidden = NO;
            self.recordPauseButton.enabled = YES;
            self.saveButton.enabled = YES;
            self.analyzeButton.enabled = YES;
        } else {
            [player setNumberOfLoops: -1];
            [player play];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                          target:self
                                                        selector:@selector(updateProgress)
                                                        userInfo:nil
                                                         repeats:YES];
            self.audioProgress.hidden = NO;
            self.recordPauseButton.enabled = NO;
            self.saveButton.enabled = NO;
            self.analyzeButton.enabled = NO;
            
            [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
            UIImage *pauseImage = [UIImage imageNamed:@"PauseIcon.png"];
            [self.playButton setImage:pauseImage forState:UIControlStateNormal];
        }
        
    }
}

- (IBAction)cropTapped:(id)sender {
    self.waveformBox.clipsToBounds = YES;
}

- (BOOL)isHeadsetPluggedIn
{
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
    
    BOOL headphonesLocated = NO;
    for( AVAudioSessionPortDescription *portDescription in route.outputs )
    {
        headphonesLocated |= ( [portDescription.portType isEqualToString:AVAudioSessionPortHeadphones] );
    }
    return headphonesLocated;
}

- (IBAction)recordPauseTapped:(id)sender {
    
     //NSLog(@"Record/pause tapped!");
    
    // Setup audio session
    session = [AVAudioSession sharedInstance];
    NSLog(@"The current AV category is: %@", session.category);
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    NSLog(@"The current AV category is: %@", session.category);
    
    [session setMode: AVAudioSessionModeDefault error:NULL];
    //[session setMode: AVAudioSessionModeMeasurement error:NULL]; //Added to disable AGC and high-pass filtering
    
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];}
    
    //Keep track of the button state (Recording (1) vs. Stoppped (2))
    if (!(buttonLogic == 1) && !(buttonLogic == 2)) {
        buttonLogic = 2;}
    
    NSLog(@"ButtonLogic = %ld", (long)buttonLogic);
    
    switch (buttonLogic) {
        case 1:
            {
            // Pause recording
            //[recorder pause];
            //[self.recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
            //UIImage *recordImage = [UIImage imageNamed:@"RecordIcon.png"];
            //[self.recordPauseButton setImage:recordImage forState:UIControlStateNormal];
            
            //Stop recording
            [recorder stop];
            //NSLog(@"Stopped recording!");
                
            //Stop playing
            [iosAudio stop];
        
            [session setActive:NO error:nil];
            
            //Set the record button back to Record
            UIImage *recordImage = [UIImage imageNamed:@"RecordRed256.png"];
            [self.recordPauseButton setImage:recordImage forState:UIControlStateNormal];
            buttonLogic = 2;
            
            //Ditch the logo, that was just a place holder
            _logoImage.image = nil;
            
            //Display the waveform
                self.waveformBox.audioURL = outputfileURL;
                NSLog(@"WFURL: %@", self.waveformBox.audioURL);
            self.saveButton.enabled = YES;
            self.audioProgress.hidden = NO;
            self.playButton.enabled = YES;
            self.emailButton.enabled = YES;

                break;
            }
    
        case 2:
            {
                
                //Prepare a path to save the audio file in the sandbox
                NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentPath_ = [searchPaths objectAtIndex: 0];
                //NSLog(@"Document path: %@", documentPath_);
                
                //pathToSave = [documentPath_ stringByAppendingPathComponent:[self dateString]]; //OLD VERSION
                pathExtension = [self dateString];
                pathToSave = [documentPath_ stringByAppendingPathComponent:pathExtension];
                
                // File URL
                
                outputfileURL = [NSURL fileURLWithPath:pathToSave];//FILEPATH];
                
                //BOOL gainSet = session.isInputGainSettable;
                //NSLog(@"Is input gain settable? %@", gainSet ? @"YES" : @"NO");
                //[session setInputGain:1.00 error:NULL];
                //[session setOutputGain:1.00 error:NULL];
                
                //CGFloat currentGain = [session inputGain];
                //NSLog(@"The current input gain is: %f", currentGain);
                //CGFloat currentVol = [session outputVolume];
                //NSLog(@"The current volume is: %f", currentVol);
                
                /*
                 CGFloat gain = sender.value;
                 NSError* error;
                 self.audioSession = [AVAudioSession sharedInstance];
                 if (self.audioSession.isInputGainSettable) {
                 BOOL success = [self.audioSession setInputGain:gain
                 error:&error];
                 if (!success){} //error handling
                 } else {
                 NSLog(@"ios6 - cannot set input gain");
                 }
                 */
                
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
                
                
                // Define the recorder setting
                NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
                
                [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
                [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
                [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
                
                // Initiate and prepare the recorder
                recorder = [[AVAudioRecorder alloc] initWithURL:outputfileURL settings:recordSetting error:nil];
                recorder.delegate = self;
                recorder.meteringEnabled = YES;
                [recorder prepareToRecord];
            //AVAudioSession *session = [AVAudioSession sharedInstance];
                
            [session setActive:YES error:nil];
                
            // Start recording
            [recorder record];
                
            //Start playing TRIAL CODE
                //insert if statement to detect headphones
                if ([self isHeadsetPluggedIn]) {
                    [iosAudio start];
                }
                
                
            //NSLog(@"RECORDING!");
            if (recorder.recording) {NSLog(@"Really, though. Recorder.recording = YES!");};
            //Erase any previous waveform image
            //_waveformBox.audioURL = NULL;
            //[self.recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
            UIImage *pauseImage = [UIImage imageNamed:@"StopRed256.png"];
            [self.recordPauseButton setImage:pauseImage forState:UIControlStateNormal];
            buttonLogic = 1;
            self.saveButton.enabled = NO;
            self.audioProgress.hidden = YES;
            self.playButton.enabled = NO;
            self.emailButton.enabled = NO;
                
                break;
            }
            
        default:
            {
            NSLog(@"Houston, we have a problem.");
            break;
            }
    }
    
}

/*
- (BOOL)isHeadsetPluggedIn {
    UInt32 routeSize = sizeof (CFStringRef);
    CFStringRef route;
    
    OSStatus error = AudioSessionGetProperty (kAudioSessionProperty_AudioRoute,
                                              &routeSize,
                                              &route);
    
     Known values of route:
     * "Headset"
     * "Headphone"
     * "Speaker"
     * "SpeakerAndMicrophone"
     * "HeadphonesAndMicrophone"
     * "HeadsetInOut"
     * "ReceiverAndMicrophone"
     * "Lineout"
 
    
    if (!error && (route != NULL)) {
        
        NSString* routeStr = (__bridge NSString*)route;
        
        NSRange headphoneRange = [routeStr rangeOfString : @"Head"];
        
        if (headphoneRange.location != NSNotFound) return YES;
        
    }
    
    return NO;
}

*/



- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [self.recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    self.audioProgress.progress = 0;
    self.audioProgress.hidden = NO;
    self.saveButton.enabled = YES;
    self.playButton.enabled = YES;
    self.emailButton.enabled = YES;
    self.analyzeButton.enabled = YES;
    
    [recorder stop];
    [recorder prepareToRecord];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)avplayer successfully:(BOOL)flag{
    
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    UIImage *playImage = [UIImage imageNamed:@"PlayIcon.png"];
    [self.playButton setImage:playImage forState:UIControlStateNormal];
    
    self.audioProgress.hidden = NO;
    self.recordPauseButton.enabled = YES;
    self.saveButton.enabled = NO;
    self.emailButton.enabled = YES;
    self.analyzeButton.enabled = YES;
    
    [player stop];
    [player prepareToPlay];
    
}

- (void)updateProgress
{
    
    //NSLog(@"The current duration is: %f", player.duration);
    float timeLeft = player.currentTime/player.duration;
    // upate the UIProgress
    self.audioProgress.progress= timeLeft;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//Experimental file saving code, for creating unique file names
- (NSString *) dateString
{
    // return a formatted string for a file name
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ddMMMYY_hhmmssa";
    return [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".wav"];
}


- (IBAction)emailTapped:(id)sender {
    
    [self emailAudio];
}

- (IBAction)changeSwitch:(id)sender {
    
    if([sender isOn]){
        NSLog(@"AGC is ON");
        [[AVAudioSession sharedInstance] setMode: AVAudioSessionModeDefault error:NULL];
        //[session setMode: AVAudioSessionModeDefault error:NULL];
    } else{
        NSLog(@"AGC is OFF");
        [[AVAudioSession sharedInstance] setMode: AVAudioSessionModeMeasurement error:NULL];
        //[session setMode: AVAudioSessionModeMeasurement error:NULL];
    }
    //[session setMode: AVAudioSessionModeDefault error:NULL];
    //[session setMode: AVAudioSessionModeMeasurement error:NULL];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self.mailViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)emailAudio
{
    self.mailViewController = [[MFMailComposeViewController alloc] init];
    
    if (!self.mailViewController)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"The email could not be sent."
                                                            message: @"Please make sure an email account is properly setup on this device."
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    self.mailViewController.mailComposeDelegate = self;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    
    [self.mailViewController setSubject:@"Stethaid Audio Recording"];
    
    NSString *messageBody = @"This audio file was recorded with the Stethaid mobile medical application.";
    
    [self.mailViewController setMessageBody:messageBody isHTML:NO];
    
    // Setup path and filename
    NSData *theAudioData = [NSData dataWithContentsOfFile:pathToSave];
    //NSLog(@"This file is: %@", theAudioData);
    
    // Attach the audio
    [self.mailViewController addAttachmentData:theAudioData mimeType:@"audio/wav" fileName:self.fileName];
    
    [self presentViewController:self.mailViewController animated:YES completion:^(){}];
}

@end
