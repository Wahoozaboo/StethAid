//
//  PatientInfoViewController.m
//  Stethaid
//
//  Created by Administrator on 10/22/15.
//  Copyright © 2015 Sheikh Zayed Institute. All rights reserved.
//

#import "PatientInfoViewController.h"

@interface PatientInfoViewController ()

@property (strong, nonatomic) UIPickerView *genderPicker;
@property (strong, nonatomic) UIDatePicker *dobPicker;
@property (strong, nonatomic) UIPickerView *diagnosisPicker;

@property (strong,nonatomic) NSArray *genderArray;
@property (strong,nonatomic) NSArray *diagnosisArray;

@property BOOL typing;

@end

@implementation PatientInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set the tableView delegate and dataSource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    [self.tableView reloadData];
    
    self.typing = NO;
    
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StethAidNavBarLogo.png"]];
    
    //Create new PatientItem
    //self.item = [[PatientDirectory sharedDirectory] createPatientItem];
    self.MRNTF.text = self.item.mrn;
    self.MRNTF.delegate =self;
    
    self.DOBTF.text = self.item.dob;
    self.genderTF.text = self.item.gender;
    self.diagnosisTF.text = self.item.diagnosis;
    self.notesTV.text = self.item.notes;
    
    //Gender Picker
    _genderPicker = [[UIPickerView alloc] init];
    _genderPicker.dataSource = self;
    _genderPicker.delegate = self;
    self.genderTF.inputView = _genderPicker;
    self.genderArray = @[@"Male", @"Female"];
    
    
    //DOB Picker
    _dobPicker = [[UIDatePicker alloc] init];
    _dobPicker.datePickerMode = UIDatePickerModeDate;
    [self.dobPicker addTarget:self
                       action:@selector(updateDOB)
             forControlEvents:UIControlEventValueChanged];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-18];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [_dobPicker setMaximumDate:maxDate];
    [_dobPicker setMinimumDate:minDate];
    self.DOBTF.inputView = _dobPicker;
    
    //Diagnosis Array
    _diagnosisPicker = [[UIPickerView alloc] init];
    _diagnosisPicker.dataSource = self;
    _diagnosisPicker.delegate = self;
    self.diagnosisTF.inputView = _diagnosisPicker;
    self.diagnosisArray = @[@"AI",
                            @"AS",
                            @"ASD",
                            @"AV fistula",
                            @"AVC",
                            @"AVM",
                            @"AVR",
                            @"CAVC",
                            @"DMSS",
                            @"HOCM",
                            @"IAAC",
                            @"LPAstenosis",
                            @"LVOT",
                            @"MR",
                            @"MV",
                            @"MVP",
                            @"PABS",
                            @"PDA",
                            @"PS",
                            @"PPPS",
                            @"PR",
                            @"PVCs",
                            @"RBBB",
                            @"RPA",
                            @"RVOT",
                            @"SEC",
                            @"Still's",
                            @"TOF",
                            @"TR",
                            @"TS",
                            @"Venous hum",
                            @"VH",
                            @"VPS",
                            @"VSD",
                            @"Other"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"The contents of the HSArray is: %@", self.item.HSArray);
    
    
    //Check to make sure that each of the displayed file titles actually exist in the heart sound directory, and if not, remove those displayed files
    NSMutableArray *newHSArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.item.HSArray.count; i++) {
        NSString *filenamei = self.item.HSArray[i];
        NSString *filenameiShort = [filenamei substringFromIndex:4];
        NSLog(@"The filename at index %d is %@", i, filenamei);
        if ([[HeartSoundList sharedList] doesThisFileStillExist:filenameiShort]) {
            [newHSArray addObject:filenamei];
        }
    }
    NSLog(@"The old array: %@", self.item.HSArray);
    self.item.HSArray =newHSArray;
    NSLog(@"The new array: %@", newHSArray);
    
    [self.tableView reloadData];
     
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Clear first responder
    [self.view endEditing:YES];
    
    //"Save" changes to item
    self.item.mrn = self.MRNTF.text;
    self.item.dob = self.DOBTF.text;
    self.item.gender = self.genderTF.text;
    self.item.diagnosis = self.diagnosisTF.text;
    self.item.notes = self.notesTV.text;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == _genderPicker) {
        return self.genderArray.count;
    }
    else if (pickerView == _diagnosisPicker) {
        return self.diagnosisArray.count;
    }
    else {return 0;}
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

     if (pickerView == _genderPicker) {
        return self.genderArray[row];
     }
    else if (pickerView == _diagnosisPicker) {
        return self.diagnosisArray[row];
    }
    else {return nil;}
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    if (pickerView == _genderPicker) {
        {self.genderTF.text = self.genderArray[row];
            [self.genderTF resignFirstResponder];}
    }
    
    else if (pickerView == _diagnosisPicker) {
        
        if ([self.diagnosisArray[row]  isEqual: @"Other"]) {
            
            //If the user selects "Other" from the UIPicker wheel, then we want to allow typing
            self.diagnosisTF.inputView = NULL;
            self.diagnosisTF.text = NULL;
            self.diagnosisTF.delegate = self;
            [self.diagnosisTF resignFirstResponder];
            return;
        }
        {self.diagnosisTF.text = self.diagnosisArray[row];
            [self.diagnosisTF resignFirstResponder];}
    }
    else {return;}
    
}


- (void) updateDOB
{
    //Take the date from picker, convert to string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-YYYY"];
    NSString *dobString = [dateFormatter stringFromDate:self.dobPicker.date];
    
    //Assign the date-string to the DOB text field
    self.DOBTF.text = dobString;
    
    [self.dobPicker resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField
{
    NSLog(@"TextFieldShouldReturn actually got called");
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(self.typing == NO) {
        [self animateTextField: textField up: YES];
        self.typing = YES;
        
        //Deal with shifting up the textView? animateTextView?
       // || textField == self.notesTV)
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.typing == YES) {
        [self animateTextField: textField up: NO];
        self.typing = NO;
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    if ([textField isEqual:self.MRNTF]) {
        return;
    }
    int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    //if (textField == self.notesTV) {  //trial code to fix the notes text field
    //    movementDistance = 220;
    //}
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.item.HSArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    
    //Set the text on the cell for the nth item
    NSArray *recordings = self.item.HSArray;
    
    
    NSString *recordingTitle = recordings[indexPath.row];
    
    cell.textLabel.text = recordingTitle;
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *items = [[PatientDirectory sharedDirectory] allItems];
        PatientItem *item = items[indexPath.row];
        [[PatientDirectory sharedDirectory] removeItem:item];
        
        //Remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
 */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Called didSelectRowAtIndexPath -- HOORAY");
    //PlaybackViewController *playbackVC = [[PlaybackViewController alloc] init];
    
    /*
    LocationSelectionViewController *lsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LSVC"];
    
    //Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:lsVC animated:YES];
    
    //NSArray *items = [[PatientDirectory sharedDirectory] allItems];
    //PatientItem *selectedItem = items[indexPath.row];
    */
    
    PlaybackViewController *playbackVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SBplaybackVC"];
    
    //Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:playbackVC animated:YES];
    
    //Take the heart sound filename and find it in the heart sound list
    NSArray *items = [[HeartSoundList sharedList] allItems];
    HeartSoundItem *selectedItem = items[indexPath.row];
    
    NSLog(@"Indexpath.row give you the number: %ld", (long)indexPath.row);
    
    //Give PlaybackVC a pointer to the item object in row
    playbackVC.HSitem = selectedItem;
    
    //Pass on the heart sound item
    NSString *filename = self.item.HSArray[indexPath.row];
    HeartSoundItem *HSItemToPass = [[HeartSoundList sharedList]findHeartSoundItemWithFilename:filename];
    
    playbackVC.HSitem = HSItemToPass;
    playbackVC.patientItem = self.item;
    playbackVC.location = [filename substringToIndex:4];
    
    //Pass the playbackVC the index of the HSItem title in the HSArray in the Patient Item
    playbackVC.indexInHSAray = indexPath.row;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    NSLog(@"The current segue: %@", [segue destinationViewController]);
    
    NSLog(@"Preparing for segue");
    
    if ([[segue identifier] isEqualToString:@"LSVCsegue"])
    {
        
        NSLog(@"Preparing for seque from PI to LS");
        LocationSelectionViewController *lsVC = [segue destinationViewController];
        
        //"Save" changes to item
        self.item.mrn = self.MRNTF.text;
        self.item.dob = self.DOBTF.text;
        self.item.gender = self.genderTF.text;
        self.item.diagnosis = self.diagnosisTF.text;
        self.item.notes = self.notesTV.text;
        
        // Pass the patient item to the new view controller.
        lsVC.item = self.item;
        
        //Push it onto the top of the navigation controller's stack
        //[self.navigationController pushViewController:lsVC animated:YES];
       
       
    }
}

@end
