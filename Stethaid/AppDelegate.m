//
//  AppDelegate.m
//  Stethaid
//
//  Created by Administrator on 2/4/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

#import "AppDelegate.h"
#import "RecordingViewController.h"
#import "HeartSoundList.h"
#import "PatientDirectory.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //RecordingViewController *recordingViewController = [[RecordingViewController alloc] init];
    
    //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:recordingViewController];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    
    //[[UINavigationBar appearance]
     //viewController.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yourimage.png"]];
    //UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yourimage2.jpg"]]];
    //viewController.navigationItem.rightBarButtonItem = item;
    
    //Place navigation controller's view in the window hierarchy
    //self.window.rootViewController = navController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    BOOL success = [[HeartSoundList sharedList] saveChanges];
    BOOL neato = [[PatientDirectory sharedDirectory] saveChanges];
    if (success && neato) {
        NSLog(@"Saved all of the patient and heart sound items!");
    }
    else {
        NSLog(@"Could not save any of the items...");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
