//
//  LocationChangeViewController.m
//  Stethaid
//
//  Created by Administrator on 11/18/15.
//  Copyright © 2015 Sheikh Zayed Institute. All rights reserved.
//

#import "LocationChangeViewController.h"

@interface LocationChangeViewController ()

@end

@implementation LocationChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.currentLocationLabel.text = self.location;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"Prepare for segue from LC to PB");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
 PlaybackViewController *pbVC = [segue destinationViewController];
 
 pbVC.location = self.location;
 
}


- (IBAction)RUSBTapped:(id)sender {
        self.location = @"RUSB";
        self.currentLocationLabel.text = @"RUSB";
    //self.delegateVC.location = @"RUSB";
}

- (IBAction)LUSBTapped:(id)sender {
        self.location = @"LUSB";
        self.currentLocationLabel.text = @"LUSB";
    //self.delegateVC.location = @"LUSB";
}

- (IBAction)LLSBTapped:(id)sender {
        self.location = @"LLSB";
        self.currentLocationLabel.text = @"LLSB";
    //self.delegateVC.location = @"LLSB";
}

- (IBAction)APEXTapped:(id)sender {
        self.location = @"APEX";
        self.currentLocationLabel.text = @"APEX";
    //self.delegateVC.location = @"APEX";
}
- (IBAction)backFromLC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    PlaybackViewController *pbVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-1];
    
    pbVC.location = self.location;
}


@end
