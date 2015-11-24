//
//  PlaybackViewController.m
//  Stethaid
//
//  Created by Administrator on 4/10/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

#import "PlaybackViewController.h"
#import "HeartSoundItem.h"
#import "HeartSoundListViewController.h"
#import "EZOutput.h"

@interface PlaybackViewController ()

{
    AVAudioPlayer *player;
    NSString* pathToLoad;
    NSURL *audiofilepath;
}

@property (weak, nonatomic) IBOutlet FDWaveformView *waveformBox;
@property (weak, nonatomic) IBOutlet UIProgressView *audioProgress;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *filenameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIView *mpVolumeViewParentView;
@property MFMailComposeViewController *mailViewController;
- (IBAction)playTapped:(id)sender;
- (IBAction)emailTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;

@end

@implementation PlaybackViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Volume control
    self.mpVolumeViewParentView.backgroundColor = [UIColor clearColor];
    MPVolumeView *myVolumeView = [[MPVolumeView alloc] initWithFrame: self.mpVolumeViewParentView.bounds];
    [self.mpVolumeViewParentView addSubview: myVolumeView];
    
    // Some settings for the waveform display
    self.waveformBox.doesAllowStretchAndScroll = YES;
    self.waveformBox.doesAllowScrubbing = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"viewWillAppear was CALLED!");
    
    HeartSoundItem *HSitem = self.HSitem;
    
    NSString *displayFilename = [self.location stringByAppendingString:self.HSitem.pathExtension];
    
    self.filenameLabel.text = displayFilename;
    NSLog(@"The display name is: %@", displayFilename);
    
    //Take that display name and change the actual HSArray element in the Patient Item of the previous controller
    PatientInfoViewController *piVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    NSMutableArray *mutableHSArray = [piVC.item.HSArray mutableCopy];
    
    [mutableHSArray replaceObjectAtIndex:self.indexInHSAray withObject:displayFilename];
    
    piVC.item.HSArray = [mutableHSArray copy];
    
    
    //self.textField.text = item.pathExtension;
    
    //Send a touch to the FDWaveForm box to reset it...
    //TODO

    
    //Find the path to load in the sandbox
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
    //NSLog(@"The second doc path: %@", documentPath_);
    
    //pathToLoad = [@"file:/" stringByAppendingString:documentPath_];
    pathToLoad = [documentPath_ stringByAppendingPathComponent:HSitem.pathExtension];
    // NSLog(@"The path before converting to URL: %@", pathToLoad);
    
    audiofilepath = [NSURL fileURLWithPath:pathToLoad];//FILEPATH];
    
    // NSLog(@"The received URL: %@", audiofilepath);
    
    self.waveformBox.audioURL = audiofilepath;
    
    //New plot and file
    //self.audioFile = [[EZAudioFile alloc] initWithURL:pathToLoad];
    //[self openFileWithFilePathURL:[NSURL fileURLWithPath:pathToLoad]];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Clear first responder
    [self.view endEditing:YES];
    
    //"Save" changes to item
    HeartSoundItem *HSitem = self.HSitem;
    HSitem.patientName = self.filenameLabel.text;
    //TODO... pass the new location/filename back to HSArray in the Patient item that will be shown in the Patient Info VC
    
    [player stop];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"Prepare for segue from PB to LC");
    // Get the new view controller using [segue destinationViewController].

    
    // Pass the selected object to the new view controller.
    
    LocationChangeViewController *lcVC = [segue destinationViewController];
    
    lcVC.location = self.location;

}


- (IBAction)playTapped:(id)sender {
    
    
    NSLog(@"Play tapped!");
    
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:audiofilepath error:nil];
        [player setDelegate:self];
        UIButton* playButton = (UIButton*)sender;
        
        if(![playButton.titleLabel.text  isEqual: @"Play"]){//player.playing){
            [player pause];
            [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
            UIImage *playImage = [UIImage imageNamed:@"PlayIcon.png"];
            [self.playButton setImage:playImage forState:UIControlStateNormal];
            self.audioProgress.hidden = NO;
            
            
        } else {
            [player setNumberOfLoops: -1];
            [player play];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                          target:self
                                                        selector:@selector(updateProgress)
                                                        userInfo:nil
                                                         repeats:YES];
            self.audioProgress.hidden = NO;
            
            [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
            UIImage *pauseImage = [UIImage imageNamed:@"PauseIcon.png"];
            [self.playButton setImage:pauseImage forState:UIControlStateNormal];
        }
        
    }

- (IBAction)emailTapped:(id)sender {
    
    //TODO: check for DX, else segue to Patient Info
    if ([self.patientItem.diagnosis  isEqual: @""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Wait a second!"
                                                            message: @"You have not yet entered a diagnosis for this heart sound recording. Please return to the Patient Info page."
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    [self emailAudio];
}


- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    UIImage *playImage = [UIImage imageNamed:@"PlayIcon.png"];
    [self.playButton setImage:playImage forState:UIControlStateNormal];
    
    self.audioProgress.hidden = NO;
    //self.emailButton.enabled = YES;
    
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

#pragma Email methods

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
    
    NSArray *toRecipients = [[NSArray alloc] initWithObjects:@"data.said@moh.gov.ae", nil];
    
    [self.mailViewController setToRecipients:toRecipients];

    
    [self.mailViewController setSubject:@"Stethaid Audio Recording"];
    
    //Create a time stamp
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-YYYY"];
    NSDate *timeOfEmail = [[NSDate alloc] init];
    NSString *timeOfEmailString = [formatter stringFromDate:timeOfEmail];
    
    NSString *messageBody = [NSString stringWithFormat:@"This audio file was recorded with the Stethaid mobile medical application.\n MRN: %@ \n Gender: %@ \n DOB: %@ \n Time of email: %@\n Diagnosis: %@ \n Notes: %@", self.patientItem.mrn, self.patientItem.gender, self.patientItem.dob, timeOfEmailString,self.patientItem.diagnosis, self.patientItem.notes];
    
    [self.mailViewController setMessageBody:messageBody isHTML:NO];
    
    
    // Setup path and filename
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
  
    pathToLoad = [documentPath_ stringByAppendingPathComponent:self.HSitem.pathExtension];
    
    NSData *theAudioData = [NSData dataWithContentsOfFile:pathToLoad];

    
    // Attach the audio
    [self.mailViewController addAttachmentData:theAudioData mimeType:@"audio/wav" fileName:self.HSitem.patientName];
    
    //Create a .txt or .xml file to attach to the email, with the XML version of the demographic info
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file path to write the data to using the documents directory:
    NSString *filePath = [NSString stringWithFormat:@"%@/PatientInfo.txt",
                          documentsDirectory];
    
    //create content for .xml file
    NSString *content = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<patient-info>\n<mrn>%@</mrn>\n<dob>%@</dob>\n<gender>%@</gender>\n<diagnosis>%@</diagnosis>\n<curr-date>%@</curr-date>\n<notes>%@</notes>\n</patient-info>", self.patientItem.mrn, self.patientItem.dob, self.patientItem.gender, self.patientItem.diagnosis, timeOfEmailString, self.patientItem.notes];
    
    //save content to the documents directory
    [content writeToFile:filePath
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
    NSData *dataToBeEncrypted = [NSData dataWithContentsOfFile:filePath];
    [self.mailViewController addAttachmentData:dataToBeEncrypted mimeType:@"text/xml" fileName:@"PatientInfo.xml"];
    
    
    [self presentViewController:self.mailViewController animated:YES completion:^(){}];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        [self.waveformBox layoutSubviews];
        
    }];
}

/*
#pragma mark - Actions
-(void)changePlotType:(id)sender {
    NSInteger selectedSegment = [sender selectedSegmentIndex];
    switch(selectedSegment){
        case 0:
            [self drawBufferPlot];
            break;
        case 1:
            [self drawRollingPlot];
            break;
        default:
            break;
    }
}

-(void)play:(id)sender {
    if( ![[EZOutput sharedOutput] isPlaying] ){
        //if( self.eof ){
          //  [self.audioFile seekToFrame:0];
        //}
        [EZOutput sharedOutput].outputDataSource = self;
        [[EZOutput sharedOutput] startPlayback];
    }
    else {
        [EZOutput sharedOutput].outputDataSource = nil;
        [[EZOutput sharedOutput] stopPlayback];
    }
}

-(void)seekToFrame:(id)sender {
    [self.audioFile seekToFrame:(SInt64)[(UISlider*)sender value]];
}

#pragma mark - Action Extensions

 Give the visualization of the current buffer (this is almost exactly the openFrameworks audio input example)
 
-(void)drawBufferPlot {
    // Change the plot type to the buffer plot
    self.audioPlot.plotType = EZPlotTypeBuffer;
    // Don't fill
    self.audioPlot.shouldFill = NO;
    // Don't mirror over the x-axis
    self.audioPlot.shouldMirror = NO;
}


 Give the classic mirrored, rolling waveform look
 
-(void)drawRollingPlot {
    // Change the plot type to the rolling plot
    self.audioPlot.plotType = EZPlotTypeRolling;
    // Fill the waveform
    self.audioPlot.shouldFill = YES;
    // Mirror over the x-axis
    self.audioPlot.shouldMirror = YES;
}

-(void)openFileWithFilePathURL:(NSURL*)filePathURL {
    
    // Stop playback
    [[EZOutput sharedOutput] stopPlayback];
    
    self.audioFile                        = [EZAudioFile audioFileWithURL:filePathURL];
    self.audioFile.audioFileDelegate      = self;
    //self.eof                              = NO;
    //self.filePathLabel.text               = filePathURL.lastPathComponent;
    //self.framePositionSlider.maximumValue = (float)self.audioFile.totalFrames;
    
    // Set the client format from the EZAudioFile on the output
    [[EZOutput sharedOutput] setAudioStreamBasicDescription:self.audioFile.clientFormat];
    
    // Plot the whole waveform
    self.audioPlot.plotType        = EZPlotTypeBuffer;
    self.audioPlot.shouldFill      = YES;
    self.audioPlot.shouldMirror    = YES;
    
    //Gain
    self.audioPlot.gain            = 15.0;
    
    [self.audioFile getWaveformDataWithCompletionBlock:^(float *waveformData, UInt32 length) {
        [self.audioPlot updateBuffer:waveformData withBufferSize:length];
    }];
    
}

#pragma mark - EZAudioFileDelegate
-(void)audioFile:(EZAudioFile *)audioFile
       readAudio:(float **)buffer
  withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    dispatch_async(dispatch_get_main_queue(), ^{
        if( [EZOutput sharedOutput].isPlaying ){
            if( self.audioPlot.plotType     == EZPlotTypeBuffer &&
               self.audioPlot.shouldFill    == YES              &&
               self.audioPlot.shouldMirror  == YES ){
                self.audioPlot.shouldFill   = NO;
                self.audioPlot.shouldMirror = NO;
            }
            [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
        }
    });
}

-(void)audioFile:(EZAudioFile *)audioFile
 updatedPosition:(SInt64)framePosition {
    dispatch_async(dispatch_get_main_queue(), ^{
        //if( !self.framePositionSlider.touchInside ){
          //  self.framePositionSlider.value = (float)framePosition;
        //}
    });
}

#pragma mark - EZOutputDataSource
-(void)output:(EZOutput *)output shouldFillAudioBufferList:(AudioBufferList *)audioBufferList withNumberOfFrames:(UInt32)frames
{
    
    if( self.audioFile )
    {
        UInt32 bufferSize;
        [self.audioFile readFrames:frames
                   audioBufferList:audioBufferList
                        bufferSize:&bufferSize
                            eof:&_eof];
        if( _eof )
        {
            [self seekToFrame:0];
       }
     
    }
 
}

-(AudioStreamBasicDescription)outputHasAudioStreamBasicDescription:(EZOutput *)output {
    return self.audioFile.clientFormat;
}
*/

@end
