//
//  NewWaveViewController.h
//  Stethaid
//
//  Created by Administrator on 9/23/15.
//  Copyright © 2015 Sheikh Zayed Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio.h"

//Local includes
//#import "AudioController.h"

@interface NewWaveViewController : UIViewController

/**
 The microphone component
 */
@property (nonatomic,strong) EZMicrophone *microphone;

@end
