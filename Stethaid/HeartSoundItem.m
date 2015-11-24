//
//  HeartSoundItem.m
//  Stethaid
//
//  Created by Administrator on 4/8/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

#import "HeartSoundItem.h"


@implementation HeartSoundItem


//Initializer with title, subtitle, date, and path for audio
-(instancetype)initWithTitle: (NSString *)patientName
                subtitleText: (NSString *)subtitle
                pathForAudio: (NSString *)audiopathExtension
{
    self = [super init];
    if (self) {
        _patientName = patientName;
        _subtitle = subtitle;
        _dateCreated = audiopathExtension;
        _pathExtension = audiopathExtension;
        
    }
    return self;
}

//Initializer with date
-(instancetype)initBasic
{
    self = [super init];
    if (self) {
    _patientName = @"John Doe";
    //_dateCreated = [[NSDate alloc] init]; //toString?
    }
    return self;
}
-(void)setPatientName: (NSString *)str
{
     _patientName = str;
}


- (NSString *)patientName
{
    return _patientName;
}

-(void)setSubtitle: (NSString *)str
{
    _subtitle = str;
}

- (NSString *)subtitle
{
    return _subtitle;
}

- (NSString *)dateCreated
{
    return _dateCreated;
}

-(void)setpathExtension: (NSString *)str
{
    _pathExtension = str;
}

- (NSString *)pathExtension
{
    return _pathExtension;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.patientName forKey:@"patientName"];
    [aCoder encodeObject:self.subtitle forKey:@"subtitle"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.pathExtension forKey:@"pathExtension"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _patientName = [aDecoder decodeObjectForKey:@"patientName"];
        _subtitle = [aDecoder decodeObjectForKey:@"subtitle"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _pathExtension = [aDecoder decodeObjectForKey:@"pathExtension"];
    }
    return self;
}

@end

