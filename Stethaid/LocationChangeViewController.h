//
//  LocationChangeViewController.h
//  Stethaid
//
//  Created by Administrator on 11/18/15.
//  Copyright © 2015 Sheikh Zayed Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientItem.h"
#import "PlaybackViewController.h"

@interface LocationChangeViewController : UIViewController


//Patient item
@property (nonatomic, strong) PatientItem *item;

//Audio file name
@property (nonatomic) NSString* fileName;

- (IBAction)backFromLC:(id)sender;


@property NSString *location;

@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;

- (IBAction)RUSBTapped:(id)sender;
- (IBAction)LUSBTapped:(id)sender;
- (IBAction)LLSBTapped:(id)sender;
- (IBAction)APEXTapped:(id)sender;

@end
