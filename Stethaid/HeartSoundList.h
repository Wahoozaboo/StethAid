//
//  HeartSoundList.h
//  Stethaid
//
//  Created by Administrator on 4/8/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HeartSoundItem;

@interface HeartSoundList : NSObject

@property (nonatomic, readonly, copy) NSArray *allItems;

+(instancetype)sharedList;
-(HeartSoundItem *)createHeartSoundItem;
-(HeartSoundItem *)createHeartSoundItemWithName:patientName
                                   subtitleText:subtitle
                                   pathForAudio:audiopathExtension;
-(BOOL)saveChanges;
- (void)removeItem: (HeartSoundItem *)item;
-(BOOL)doesThisFileStillExist: (NSString*)filename;
-(HeartSoundItem *)findHeartSoundItemWithFilename: (NSString*)filename;

@end
