//
//  main.m
//  Stethaid
//
//  Created by Administrator on 6/4/15.
//  Copyright (c) 2015 Sheikh Zayed Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "IosAudioController.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
            NSLog(@"ZOMBIES/AFOC ARE ENABLED!!! AAAAARRRRRRGH!!! BRAINS!!!");
        }
        
        //iosAudio = [[IosAudioController alloc] init];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
        
    }
}
