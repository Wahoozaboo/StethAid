//
//  PatientDirectory.h
//  mGene
//
//  Created by Administrator on 4/29/15.
//  Copyright (c) 2015 Sheikh Zayed Institute. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PatientItem;

@interface PatientDirectory : NSObject

@property (nonatomic, readonly, copy) NSArray *allItems;

+(instancetype)sharedDirectory;

-(PatientItem *)createPatientItem;
-(BOOL)saveChanges;
- (void)removeItem: (PatientItem *)item;


@end
