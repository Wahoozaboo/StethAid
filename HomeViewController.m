//
//  HomeViewController.m
//  Stethaid
//
//  Created by Administrator on 7/27/15.
//  Copyright (c) 2015 Sheikh Zayed Institute. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)newRecorderVCTapped:(id)sender {
    
    //Ridiculous hack... just make a whole new view controller. Where do all the old ones go? Not sure yet.
    RollingAudioViewController *raVC = [[RollingAudioViewController alloc]init];
    
    //Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:raVC animated:YES];
    
}

@end
