//
//  LocationSelectionViewController.h
//  Stethaid
//
//  Created by Administrator on 10/20/15.
//  Copyright © 2015 Sheikh Zayed Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientItem.h"

@interface LocationSelectionViewController : UIViewController

//Patient item
@property (nonatomic, strong) PatientItem *item;

//Audio file name
@property (nonatomic) NSString* fileName;

@property NSString *location;

- (IBAction)BaseRightButtonTapped:(id)sender; //aortic area
- (IBAction)BaseLeftButtonTapped:(id)sender; //pulmonic area
- (IBAction)LLSBButtonTapped:(id)sender; //tricuspid area
- (IBAction)ApexButtonTapped:(id)sender; //mitral area
- (IBAction)SkipButtonTapped:(id)sender;

//Did the user come to record by clicking "Quick Listen?"
@property (nonatomic, assign) BOOL quickListen;

@end
