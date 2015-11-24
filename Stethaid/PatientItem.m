//
//  PatientItem.m
//  mGene
//
//  Created by Administrator on 4/29/15.
//  Copyright (c) 2015 Sheikh Zayed Institute. All rights reserved.
//

#import "PatientItem.h"

@implementation PatientItem


//Initialize an empty patient item
-(instancetype)initBasic
{
    self = [super init];
    
    if (self)
    {
        
    _mrn = @"New Patient";
    _gender = @"";
    _dob = @"";
    _diagnosis = @"";
    _notes = @"";
    _dateOfCreation = @"";
        
    //Create array of heartSoundItems
    self.HSArray = [[NSMutableArray alloc] init];
        //[self.HSArray addObject:@"Record a heart sound"];

    }
    return self;
}



-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mrn forKey:@"mrnKey"];
    [aCoder encodeObject:self.gender forKey:@"genderKey"];
    [aCoder encodeObject:self.dob forKey:@"dobKey"];
    [aCoder encodeObject:self.diagnosis forKey:@"diagnosisKey"];
    [aCoder encodeObject:self.notes forKey:@"notesKey"];
    [aCoder encodeObject:self.dateOfCreation forKey:@"dateOfCreationKey"];
    [aCoder encodeObject:self.HSArray forKey:@"HSArrayKey"];
    /*
    [aCoder encodeObject:self.frontFaceKey forKey:@"frontFaceKey"];
    [aCoder encodeObject:self.eyesClosedKey forKey:@"eyesClosedKey"];
    [aCoder encodeObject:self.leftFaceKey forKey:@"leftFaceKey"];
    [aCoder encodeObject:self.rightFaceKey forKey:@"rightFaceKey"];
    [aCoder encodeObject:self.leftPalmKey forKey:@"leftPalmKey"];
    [aCoder encodeObject:self.rightPalmKey forKey:@"rightPalmKey"];
    */
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.mrn = [aDecoder decodeObjectForKey:@"mrnKey"];
        self.gender = [aDecoder decodeObjectForKey:@"genderKey"];
        self.dob = [aDecoder decodeObjectForKey:@"dobKey"];
        self.diagnosis = [aDecoder decodeObjectForKey:@"diagnosisKey"];
        self.notes = [aDecoder decodeObjectForKey:@"notesKey"];
        self.dateOfCreation = [aDecoder decodeObjectForKey:@"dateOfCreationKey"];
        self.HSArray = [aDecoder decodeObjectForKey:@"HSArrayKey"];
        //[self setMyArray:[[decoder decodeObjectForKey:@"myArray"] mutableCopy];
        
    }
    
    /*
    if (self) {
   
        self.frontFaceKey = [aDecoder decodeObjectForKey:@"frontFaceKey"];
        self.eyesClosedKey = [aDecoder decodeObjectForKey:@"eyesClosedKey"];
        self.leftFaceKey = [aDecoder decodeObjectForKey:@"leftFaceKey"];
        self.rightFaceKey = [aDecoder decodeObjectForKey:@"rightFaceKey"];
        self.leftPalmKey = [aDecoder decodeObjectForKey:@"leftPalmKey"];
        self.rightPalmKey = [aDecoder decodeObjectForKey:@"rightPalmKey"];
    }
     */
    return self;
}


@end
