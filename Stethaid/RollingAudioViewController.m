//
//  RollingAudioViewController.m
//  Stethaid
//
//  Created by Administrator on 6/11/15.
//  Copyright (c) 2015 Sheikh Zayed Institute. All rights reserved.
//

#import "RollingAudioViewController.h"
#import "IosAudioController.h"


#include <pthread.h>


@interface RollingAudioViewController () <UITextFieldDelegate, UIAlertViewDelegate>
{

    NSURL *outputfileURL;
    NSString* pathToSave;
    NSString* pathExtension;
    NSInteger buttonLogic;
    
}

// Using AVPlayer for example
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,weak) IBOutlet UIButton *playButton;
@property (nonatomic,weak) IBOutlet UILabel *playingTextField;
@property (nonatomic) NSTimer *timer;
@property (nonatomic, assign) CFTimeInterval ticks;

@property MFMailComposeViewController *mailViewController;


@end

@implementation RollingAudioViewController

@synthesize audioPlot;
@synthesize microphone;
@synthesize playButton;
@synthesize playingTextField;
@synthesize recorder;





#pragma mark - Initialization
-(id)init {
    self = [super init];
    if(self){
        [self initializeViewController];
            }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initializeViewController];
    }
    return self;
}

#pragma mark - Initialize View Controller Here
-(void)initializeViewController {
    // Create an instance of the microphone and tell it to use this view controller instance as the delegate
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    
    
    //TRIAL
    /* WAV file options
     0: mFormatId: lpcm, mFormatFlags: 8, mBitsPerChannel: 8
     1: mFormatId: lpcm, mFormatFlags: 12, mBitsPerChannel: 16
     2: mFormatId: lpcm, mFormatFlags: 12, mBitsPerChannel: 24
     3: mFormatId: lpcm, mFormatFlags: 12, mBitsPerChannel: 32
     4: mFormatId: lpcm, mFormatFlags: 9, mBitsPerChannel: 32
     5: mFormatId: lpcm, mFormatFlags: 9, mBitsPerChannel: 64
    
    
    struct AudioStreamBasicDescription {
        mSampleRate       = 8000.0; //changed from 44100
        mFormatID         = kAudioFormatLinearPCM;
        mFormatFlags      = kAudioFormatFlagsAudioUnitCanonical;
        mBytesPerPacket   = 1 * sizeof (AudioUnitSampleType);    // 8
        mFramesPerPacket  = 1;
        mBytesPerFrame    = 1 * sizeof (AudioUnitSampleType);    // 8
        mChannelsPerFrame = 2;
        mBitsPerChannel   = 8 * sizeof (AudioUnitSampleType);    // 32
        mReserved         = 0;
    };
    
    
    AudioStreamBasicDescription anASBD;
    anASBD.mSampleRate = 8000;
    anASBD.mFormatID = kAudioFormatLinearPCM;
    anASBD.mFormatFlags      = 8;
    anASBD.mBytesPerPacket   = 8;    // 8
    anASBD.mFramesPerPacket  = 1;
    anASBD.mBytesPerFrame    = 8;    // 8
    anASBD.mChannelsPerFrame = 2;
    anASBD.mBitsPerChannel   = 8;
    anASBD.mReserved         = 0;
    
    self.microphone = [EZMicrophone microphoneWithDelegate:self withAudioStreamBasicDescription:anASBD];
    //END TRIAL
    */
    
     [[AVAudioSession sharedInstance] setMode: AVAudioSessionModeMeasurement error:NULL];
    
}

#pragma mark - Customize the Audio Plot
-(void)viewDidLoad {
    
    NSLog(@"VIEWDIDLOAD CALLED");
    
    [super viewDidLoad];
    
    
    /*
     Customizing the audio plot's look
     */
    // Background color
    self.audioPlot.backgroundColor = [UIColor blackColor];
    // Waveform color
    self.audioPlot.color           = [UIColor whiteColor];
    // Plot type
    self.audioPlot.plotType        = EZPlotTypeRolling;
    // Fill
    self.audioPlot.shouldFill      = NO;
    // Mirror
    self.audioPlot.shouldMirror    = NO;
    //Gain
    self.audioPlot.gain            = 8.0;
    
    //Cut the rollingPlotHistory in half
    int historyLength = self.audioPlot.rollingHistoryLength;
    [self.audioPlot setRollingHistoryLength:historyLength/4];
    
    /*
     Set labels
     */
    self.playingTextField.text = @"Not Playing";
    
    // Hide the play and reset buttons
    self.playButton.hidden = YES;
    self.resetButton.hidden = YES;
    
    /*
     Log out where the file is being written to within the app's documents directory
     */
    //NSLog(@"File written to application sandbox's documents directory: %@",[self testFilePathURL]);
    
    
    //start the monitor
    iosAudio = [[IosAudioController alloc] init];
    [iosAudio start];
    
    // Start the microphone
    [self.microphone startFetchingAudio];
    NSLog(@"Mic fetching audio");
    
    
    
    //There is no saved file yet
    self.fileSaved = NO;
    
    //Set recording boolean to NO
    self.isRecording = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StethAidNavBarLogo.png"]];
    NSLog(@"VIEW WILL APPEAR CALLED");
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [iosAudio stop];
    
    NSLog(@"VIEW WILL DISAPPEAR CALLED");
    
}

#pragma mark - Actions
-(void)playFile:(id)sender
{
    
    //Turn off the real-time synchronous playback
    [iosAudio stop];
    
    // Update microphone state
    [self.microphone stopFetchingAudio];
    
    // Update recording state
    self.isRecording = NO;
    
    // Create Audio Player
    if( self.audioPlayer )
    {
        if( self.audioPlayer.playing )
        {
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
        UIImage *playimage = [UIImage imageNamed:@"PlayIcon.png"];
        [self.playButton setImage:playimage forState:UIControlStateNormal];
        self.playingTextField.text = @"Paused";
        return;
    }
    
    
    NSError *err;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: outputfileURL
                                                              error:&err];
    self.audioPlayer.numberOfLoops = -1;
    [self.audioPlayer play];
    
    self.audioPlayer.delegate = self;
    UIImage *pauseImage = [UIImage imageNamed:@"PauseIcon.png"];
    [self.playButton setImage:pauseImage forState:UIControlStateNormal];
    self.playingTextField.text = @"Playing";
    
}


- (IBAction)recordPauseTapped:(id)sender {
    
    NSLog(@"RECORD PAUSE TAPPED");
    
    self.playingTextField.text = @"Not Playing";
    if( self.audioPlayer )
    {
        if( self.audioPlayer.playing )
        {
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
    }
    
    
    if( self.isRecording == NO )
       
    {
        
        // Make a path to save the audio file in the sandbox, but save the extension separately so that you can still find the file, should the sandbox change in the future.
        
        //Prepare a path to save the audio file in the sandbox
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath_ = [searchPaths objectAtIndex: 0];

        pathExtension = [self dateString];
        pathToSave = [documentPath_ stringByAppendingPathComponent:pathExtension];
        
        // File URL
        outputfileURL = [NSURL fileURLWithPath:pathToSave];//FILEPATH];
        
        
        // Create the recorder
        //self.recorder = [EZRecorder recorderWithDestinationURL:outputfileURL
        //                                          sourceFormat:self.microphone.audioStreamBasicDescription
        //                                   destinationFileType:EZRecorderFileTypeWAV];
    
    
        //TRIAL CODE TO STOP THE CRASH
        /*
        if (0 == pthread_mutex_trylock(&outputAudioFileLock)) {
            NSLog(@"Got inside the if statement and made a recorder!!!!!");
         self.recorder = [EZRecorder recorderWithDestinationURL:outputfileURL
         sourceFormat:self.microphone.audioStreamBasicDescription
         destinationFileType:EZRecorderFileTypeWAV];
            } else {
            pthread_mutex_unlock(&outputAudioFileLock);
            }
        */
    
        //More trial code
        //pthread_mutex_lock(&outputAudioFileLock);
        self.recorder = [EZRecorder recorderWithDestinationURL:outputfileURL
                                                      sourceFormat:self.microphone.audioStreamBasicDescription
                                               destinationFileType:EZRecorderFileTypeWAV];
        NSLog(@"EZRecorder initialized");
        //pthread_mutex_unlock(&outputAudioFileLock);
        
       //Perhaps check to see if the microphone is already fetching audio?
       //[self.microphone startFetchingAudio];
       //  NSLog(@"Mic fetching audio");
        
       //start the monitor
        [iosAudio start];
        
        //start recordng
        self.isRecording = YES;
        UIImage *pauseImage = [UIImage imageNamed:@"StopRed256.png"];
        [self.recordPauseButton setImage:pauseImage forState:UIControlStateNormal];
        
        //start a timer
        //self.recordTimer = [[NSTimer alloc] init];
        //[self.recordTimer fire]; //fire?
        
        //Clear the plot
        [self.audioPlot clear];
        
        //Change the color of the waveform
        self.audioPlot.color = [UIColor redColor];
        
        //Start the timer
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        
    }
    else
    {
        
            //TRIAL CODE TO STOP THE CRASH
            //pthread_mutex_lock(&outputAudioFileLock);
            //[self.recorder closeAudioFile];
            //self.recorder = nil;
            //pthread_mutex_unlock(&outputAudioFileLock);
            //NSLog(@"Stopping Record");
        
        //Stop the timer
        [self.timer invalidate];
        
        [self.microphone stopFetchingAudio];
        NSLog(@"Mic NOT fetching audio");
        self.isRecording = NO;
        
        [self.recorder closeAudioFile];
        NSLog(@"Called closeAudioFile");
       
        self.playButton.hidden = NO;
        //Reset the image to the red recorder circle
        UIImage *recordImage = [UIImage imageNamed:@"RecordRed256.png"];
        [self.recordPauseButton setImage:recordImage forState:UIControlStateNormal];
        
        //Disable the button, because allowing the user to restart recording mid-file crashes the app
        self.recordPauseButton.enabled = NO;
        
        //Automatically prompt user to name the file to be saved
        [self saveFile];
        
        //Unhide the reset button
        self.resetButton.hidden = NO;
        
        //stop the monitor
        [iosAudio stop];
        
    }

    
}
- (IBAction)stopRecordingBeforeSegueToDirectory:(id)sender {
    if(self.isRecording == YES) {
        [self recordPauseTapped:self];}
    NSLog(@"Segue to directory");
}

- (IBAction)stopRecordingBeforeSegueToEmail:(id)sender {
    if(self.isRecording == YES) {
        [self recordPauseTapped:self];}
    NSLog(@"Segue to email");
    [self emailAudio];
    
}

- (void) saveFile
{
    //NSLog(@"Save file called!");
    
    //Get a file name from a UIAlert with a textfield
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"Please enter a name for the file:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 12;
    
    UITextField *textfield = [alert textFieldAtIndex:0];
    
    self.fileName = [self.location stringByAppendingString:pathExtension];
    
    textfield.placeholder = @"Type here";
    
    textfield.text = self.fileName;
    
    
    //TODO ...Is an object actually being added? No...
    [self.item.HSArray addObject:self.fileName];
    
    [alert addButtonWithTitle:@"Ok"];
    [alert show];
}

- (void) saveBeforeReset
{

    NSLog(@"SAVE BEFORE RESET CALLED");
    
    //Get a file name from a UIAlert with a textfield
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"Are you sure you want to erase this recording? If not, please enter a name for the file:" delegate:self cancelButtonTitle:@"Don't save" otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 13;
    
    UITextField *textfield = [alert textFieldAtIndex:0];
    
    self.fileName = [@"Rec_" stringByAppendingString:pathExtension];
    
    textfield.placeholder = @"Type here";
    
    textfield.text = self.fileName;
    
    [alert addButtonWithTitle:@"Ok"];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 12) {
        
        UITextField *textfield = [alertView textFieldAtIndex:0];
        
        textfield.placeholder = @"Placeholder";
        
        if (buttonIndex == 1) {
           
            self.fileName = textfield.text;
            
            
            NSLog(@"Filename: %@", textfield.text);
            
            
            
            //Create an entry in the Heart Sound Recording directory
            [[HeartSoundList sharedList] createHeartSoundItemWithName: self.fileName subtitleText:NULL pathForAudio:pathExtension];
            self.fileSaved = YES;
        }
        if (buttonIndex == 0) {
            self.fileSaved = NO;
        }
        
        
    }
    
        if (alertView.tag == 13) {
            if (buttonIndex == 1) {
                UITextField *textfield = [alertView textFieldAtIndex:0];
                self.fileName = textfield.text;
                //NSLog(@"Filename: %@", textfield.text);
                
                //Create an entry in the Heart Sound Recording directory
                [[HeartSoundList sharedList] createHeartSoundItemWithName: self.fileName subtitleText:NULL pathForAudio:pathExtension];
                self.fileSaved = YES;
        
        if (buttonIndex == 0) {
            self.fileSaved = NO;
        }
            }
    
        }
   }

#pragma mark - EZMicrophoneDelegate
#warning Thread Safety
// Note that any callback that provides streamed audio data (like streaming microphone input) happens on a separate audio thread that should not be blocked. When we feed audio data into any of the UI components we need to explicity create a GCD block on the main thread to properly get the UI to work.
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.
    
    // See the Thread Safety warning above, but in a nutshell these callbacks happen on a separate audio thread. We wrap any UI updating in a GCD block on the main thread to avoid blocking that audio flow.
    dispatch_async(dispatch_get_main_queue(),^{
        // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
        [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
}

-(void)microphone:(EZMicrophone *)microphone
    hasBufferList:(AudioBufferList *)bufferList
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    
    // Getting audio data as a buffer list that can be directly fed into the EZRecorder. This is happening on the audio thread - any UI updating needs a GCD main queue block. This will keep appending data to the tail of the audio file.
    if( self.isRecording ){
        [self.recorder appendDataFromBufferList:bufferList
                                 withBufferSize:bufferSize];
    }
    
}

#pragma mark - AVAudioPlayerDelegate
/*
 Occurs when the audio player instance completes playback
 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.audioPlayer = nil;
    self.playingTextField.text = @"Finished Playing";
    UIImage *playImage = [UIImage imageNamed:@"PlayIcon.png"];
    [self.playButton setImage:playImage forState:UIControlStateNormal];
    
    
}

#pragma mark - Utility
-(NSArray*)applicationDocuments {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
}

-(NSString*)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

/*

-(NSURL*)testFilePathURL {
    return [NSURL fileURLWithPath:[[NSString stringWithFormat:@"%@/%@",
                                   [self applicationDocumentsDirectory],
                                   kAudioFilePath] stringByAppendingString:[self dateString]]];
}

- (IBAction)changeSwitch:(id)sender {
    
    if([sender isOn]){
        NSLog(@"Switch is ON");
        [[AVAudioSession sharedInstance] setMode: AVAudioSessionModeDefault error:NULL];
        //[session setMode: AVAudioSessionModeDefault error:NULL];
    } else{
        NSLog(@"Switch is OFF");
        [[AVAudioSession sharedInstance] setMode: AVAudioSessionModeMeasurement error:NULL];
        //[session setMode: AVAudioSessionModeMeasurement error:NULL];
    }
    //[session setMode: AVAudioSessionModeDefault error:NULL];
    //[session setMode: AVAudioSessionModeMeasurement error:NULL];
    
}
*/
 
- (IBAction)emailTapped:(id)sender {
    
    
    //TODO: check DX first, and if DX, then email... else, segue to info page?
    [self emailAudio];
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
    
    //if ([self.item.diagnosis isEqualToString:@""]) {
        
    //Get a file name from a UIAlert with a textfield
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hold up!" message:@"You are about to send a recording without a diagnosis. Please type in your diagnosis into the email where indicated." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //}
        
        
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    NSArray *toRecipients = [[NSArray alloc] initWithObjects:@"data.said@moh.gov.ae", nil];
    
    [self.mailViewController setToRecipients:toRecipients];
    
    [self.mailViewController setSubject:@"Stethaid Audio Recording"];
    
    //NSString *messageBody = @"This audio file was recorded with the Stethaid mobile medical application.";
    
    //Create a time stamp
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-YYYY"];
    NSDate *timeOfEmail = [[NSDate alloc] init];
    NSString *timeOfEmailString = [formatter stringFromDate:timeOfEmail];
    
    NSString *messageBody = [NSString stringWithFormat:@"This audio file was recorded with the Stethaid mobile medical application.\n MRN: %@ \n Gender: %@ \n DOB: %@ \n Time of email: %@\n Diagnosis: %@ \n Notes: %@", _item.mrn, _item.gender, _item.dob, timeOfEmailString,_item.diagnosis, _item.notes];
    
    [self.mailViewController setMessageBody:messageBody isHTML:NO];
    
    // Setup path and filename
    
    //TODO
    NSData *theAudioData = [NSData dataWithContentsOfFile:pathToSave];
    //NSLog(@"This file is: %@", theAudioData);
    
    
    
    // Attach the audio
    [self.mailViewController addAttachmentData:theAudioData mimeType:@"audio/wav" fileName:[@"RecordingTest " stringByAppendingString:[self dateString]]];
    
    //Create a .txt or .xml file to attach to the email, with the XML version of the demographic info
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file path to write the data to using the documents directory:
    NSString *filePath = [NSString stringWithFormat:@"%@/PatientInfo.txt",
                          documentsDirectory];
    
    //create content for .xml file
    NSString *content = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<patient-info>\n<mrn>%@</mrn>\n<dob>%@</dob>\n<gender>%@</gender>\n<diagnosis>%@</diagnosis>\n<curr-date>%@</curr-date>\n<notes>%@</notes>\n</patient-info>", _item.mrn, _item.dob, _item.gender, _item.diagnosis, timeOfEmailString, _item.notes];
    
    //save content to the documents directory
    [content writeToFile:filePath
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
    NSData *dataToBeEncrypted = [NSData dataWithContentsOfFile:filePath];
    [self.mailViewController addAttachmentData:dataToBeEncrypted mimeType:@"text/xml" fileName:@"PatientInfo.xml"];

    
    [self presentViewController:self.mailViewController animated:YES completion:^(){}];
}

- (NSString *) dateString
{
    // return a formatted string for a file name
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ddMMMYY_hhmmssa";
    return [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".wav"];
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

- (IBAction)resetTapped:(id)sender {
    
    
    //Alert: allow the user to save the current file before deleting
    if (!self.fileSaved) {
        [self saveBeforeReset];
    }
    else {self.fileSaved = NO;}
    
    
    //NSLog(@"The recorder url before closeAudioFile is: %@", self.recorder.url);
    //Close the audio file to reset the recorder. I hope this is all that is necessary...
    //[recorder closeAudioFile];
    //NSLog(@"The recorder url after closeAudioFile is: %@", self.recorder.url);
    
    
    //NSLog(@"The recorder description before nullifying is: %@", self.recorder);
    //Try killing the recorder
    //self.recorder = NULL;
    //NSLog(@"The recorder description after nullifying is: %@", self.recorder);
    
    //NSLog(@"BEFORE nullifying, Microphone is: %@", microphone);
    
    //[microphone ...do something?
    //[self.microphone stopFetchingAudio];
    //NSLog(@"Mic NOT fetching audio");
    //microphone.microphoneDelegate = nil;
    //microphone = nil;
    //NSLog(@"AFTER nullifying, Microphone is: %@", microphone);
    
    //Initialize a microphone if there isn't one
    if (!self.microphone) {
        NSLog(@"No microphone!");
        self.microphone = [EZMicrophone microphoneWithDelegate:self];
        
        /*
        //TRIAL
        AudioStreamBasicDescription anASBD;
        anASBD.mSampleRate = 8000.0;
        anASBD.mFormatID = kAudioFormatLinearPCM;
        anASBD.mFormatFlags      = kAudioFormatFlagsAudioUnitCanonical;
        anASBD.mBytesPerPacket   = 1 * sizeof (AudioUnitSampleType);    // 8
        anASBD.mFramesPerPacket  = 1;
        anASBD.mBytesPerFrame    = 1 * sizeof (AudioUnitSampleType);    // 8
        anASBD.mChannelsPerFrame = 2;
        anASBD.mBitsPerChannel   = 8 * sizeof (AudioUnitSampleType);    // 32
        anASBD.mReserved         = 0;
        
        self.microphone = [EZMicrophone microphoneWithDelegate:self withAudioStreamBasicDescription:anASBD];
        //END TRIAL
        */
        
        //NSLog(@"AFTER initializing again, Microphone is: %@", microphone);
        
        /**
         Creates an instance of the EZMicrophone with a delegate to respond to the audioReceived callback. This will not start fetching the audio until startFetchingAudio has been called. Use microphoneWithDelegate:startsImmediately: to instantiate this class and immediately start fetching audio data.
         @param     delegate    A EZMicrophoneDelegate delegate that will receive the audioReceived callback.
         @param     audioStreamBasicDescription A custom AudioStreamBasicFormat for the microphone input.
         @return    An instance of the EZMicrophone class. This should be declared as a strong property!
         
        + (EZMicrophone *)microphoneWithDelegate:(id<EZMicrophoneDelegate>)delegate
         withAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription;
         */
         
         }
    
    //Reset the text and boolean related to recording states
    self.isRecording = NO;
    
    
    //Clear the waveform plot
    [audioPlot clear];
    //audioPlot = NULL;
    
    
    //Enable the recording button again
    self.recordPauseButton.enabled = YES;
    
    //This might work... just going to try it
    //[self viewDidLoad];
    //As a last resort, I would initialize a whole new RollingAudioViewController
    
    //Change the color of the waveform
    self.audioPlot.color = [UIColor whiteColor];
    NSLog(@"Changed the color!");
    
    //Change the fill of the plot
    self.audioPlot.shouldFill = NO;
    
    //Turn the mic on
    //[self.microphone startFetchingAudio];
    //NSLog(@"Mic fetching audio");
    //start the monitor
    //[iosAudio start];
    
    //Hide the reset button again
    self.resetButton.hidden = YES;
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    NSLog(@"The current segue: %@", [segue destinationViewController]);
    
    NSLog(@"Preparing for segue");
    
    if ([[segue identifier] isEqualToString:@"PIVC"] || [[segue identifier] isEqualToString:@"BACK"] )
    {
        
        NSLog(@"Preparing for seque and postively IDed");
        PatientInfoViewController *piVC = [segue destinationViewController];
        
        //if segue.identifier == "PickGame" {
        //  let gamePickerViewController = segue.destinationViewController as GamePickerViewController
        //  gamePickerViewController.selectedGame = game
        //}
        
        //Push it onto the top of the navigation controller's stack
        //[self.navigationController pushViewController:playbackVC animated:YES];
        
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        
        // Pass the selected object to the new view controller.
        //NSArray *items = [[HeartSoundList sharedList] allItems];
        //HeartSoundItem *selectedItem = items[indexPath.row];
        
        //Give PlaybackVC a pointer to the item object in row
        piVC.item = self.item;
    }
}

- (void)timerTick:(NSTimer *)timer {
    //NSDate *now = [NSDate date];
    
    //static NSDateFormatter *dateFormatter;
    //if (!dateFormatter) {
      //  dateFormatter = [[NSDateFormatter alloc] init];
      //  dateFormatter.dateFormat = @"mm:ss";  // very simple format  "8:47:22 AM"
        
        
    //}
    
    // Timers are not guaranteed to tick at the nominal rate specified, so this isn't technically accurate.
    // However, this is just an example to demonstrate how to stop some ongoing activity, so we can live with that inaccuracy.
    _ticks += 1;
    double seconds = fmod(_ticks, 60.0);
    double minutes = fmod(trunc(_ticks / 60.0), 60.0);
    self.timerLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f", minutes, seconds];

    //If the timer reach 15 seconds, automatically stop
    if (seconds == 15.000000) {
        [self performSelector: @selector(recordPauseTapped:) withObject:self afterDelay: 0.0];
    }
}

- (IBAction)backTapped:(id)sender {
    
    if (self.quickListen) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        //Segue to the Patient Info VC
        NSLog(@"DOUBLE POP!");
        
        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        
        NSMutableArray *reverseVCs = [NSMutableArray arrayWithCapacity:[allViewControllers count]];
        NSEnumerator *enumerator = [allViewControllers reverseObjectEnumerator];
        for (id element in enumerator) {
            [reverseVCs addObject:element];
        }
        
        for (UIViewController *aViewController in reverseVCs) {
            if ([aViewController isKindOfClass:[PatientInfoViewController class]]) {
                [self.navigationController popToViewController:aViewController animated:YES];
            }
        }
    }
}
@end
