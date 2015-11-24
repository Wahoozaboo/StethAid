//
//  LocationSelectionViewController.m
//  Stethaid
//
//  Created by Administrator on 10/20/15.
//  Copyright © 2015 Sheikh Zayed Institute. All rights reserved.
//

#import "LocationSelectionViewController.h"
#import "RollingAudioViewController.h"

@interface LocationSelectionViewController ()

@end

@implementation LocationSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //iosAudio = [[IosAudioController alloc] init];
    //[iosAudio start];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StethAidNavBarLogo.png"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Prep for segue from location selection VC was called");
    
    RollingAudioViewController *ravc = [segue destinationViewController];
    
    ravc.location = self.location;
    ravc.item = self.item;
    if (self.quickListen) {
        ravc.quickListen = YES;
    }
}


- (IBAction)BaseRightButtonTapped:(id)sender {
    self.location = @"RUSB";
}
- (IBAction)BaseLeftButtonTapped:(id)sender {
    self.location = @"LUSB";
}
- (IBAction)LLSBButtonTapped:(id)sender {
    self.location = @"LLSB";
}
- (IBAction)ApexButtonTapped:(id)sender {
    self.location = @"APEX";
}
- (IBAction)SkipButtonTapped:(id)sender {
    self.location = @"NONE";
}


@end
