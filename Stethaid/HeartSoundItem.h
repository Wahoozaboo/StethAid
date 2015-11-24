//
//  HeartSoundItem.h
//  Stethaid
//
//  Created by Administrator on 4/8/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeartSoundItem : NSObject <NSCoding>

{
    NSString *_patientName;
    NSString *_subtitle;
    NSString *_dateCreated;
    NSString *_pathExtension;
    //NSURL *_audiofilepath;
    //Add DOB, diagnosis, waveform image?
    
}

//Designated Initializer
-(instancetype)initWithTitle: (NSString *)patientName
                subtitleText: (NSString *)subtitle
                pathForAudio: (NSString *)audiopathExtension;

-(instancetype)initBasic;

-(void)setPatientName: (NSString *)str;
-(NSString *)patientName;
-(void)setSubtitle: (NSString *)str;
-(NSString *)subtitle;
-(void)setpathExtension: (NSString *)str;
-(NSString *)pathExtension;

@end
