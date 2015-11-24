//
//  WelcomeChoiceViewController.m
//  Stethaid
//
//  Created by Administrator on 10/25/15.
//  Copyright © 2015 Sheikh Zayed Institute. All rights reserved.
//

#import "WelcomeChoiceViewController.h"

@interface WelcomeChoiceViewController ()

@end

@implementation WelcomeChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StethAidNavBarLogo.png"]];
    self.NewPtHeartExam.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    if ([[segue identifier] isEqualToString:@"QL"])
    {
        
        NSLog(@"Preparing for QL seque");
        LocationSelectionViewController *lsVC = [segue destinationViewController];
        
        //Let the next view controller know that this is just a quick listen
        lsVC.quickListen = YES;
    }
    
    
}


@end
