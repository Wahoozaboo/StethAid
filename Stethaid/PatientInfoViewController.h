//
//  PatientInfoViewController.h
//  Stethaid
//
//  Created by Administrator on 10/22/15.
//  Copyright © 2015 Sheikh Zayed Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientDirectory.h"
#import "PatientItem.h"
#import "LocationSelectionViewController.h"
#import "PlaybackViewController.h"
#import "HeartSoundList.h"
#import "HeartSoundItem.h"

@interface PatientInfoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) PatientItem *item;

@property (weak, nonatomic) IBOutlet UITextField *MRNTF;
@property (weak, nonatomic) IBOutlet UITextField *DOBTF;
@property (weak, nonatomic) IBOutlet UITextField *genderTF;
@property (weak, nonatomic) IBOutlet UITextField *diagnosisTF;
@property (weak, nonatomic) IBOutlet UITextView *notesTV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
