//
//  PatientItem.h
//  mGene
//
//  Created by Administrator on 4/29/15.
//  Copyright (c) 2015 Sheikh Zayed Institute. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientItem : NSObject <NSCoding>

@property (nonatomic, copy) NSString *mrn;         //1st field
@property (nonatomic, copy) NSString *gender;      //2nd field
@property (nonatomic, copy) NSString *dob;         //3rd field
@property (nonatomic, copy) NSString *diagnosis;   //4th field
@property (nonatomic, copy) NSString *notes;       //5th field
@property (nonatomic, copy) NSString *dateOfCreation;
@property (strong, retain) NSMutableArray *HSArray;

//Designated Initializer
-(instancetype)initBasic;



@end
