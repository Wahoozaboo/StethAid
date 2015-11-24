//
//  PatientDirectory.m
//  mGene
//
//  Created by Administrator on 4/29/15.
//  Copyright (c) 2015 Sheikh Zayed Institute. All rights reserved.
//

#import "PatientDirectory.h"
#import "PatientItem.h"

@interface PatientDirectory ()

@property (nonatomic) NSMutableArray *privateList;

@end

@implementation PatientDirectory

+(instancetype)sharedDirectory
{
    static PatientDirectory *sharedList;
    if (!sharedList){
        sharedList = [[self alloc] initPrivate];
    }
    return sharedList;
}

//If a programmer calls [[PatientDirectory alloc] init], let him know that it is a singleton
-(instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use + [PatientDirectory sharedList]"];
    return nil;
}

//Here is the real (secret) initializer
-(instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        _privateList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //If the array hadn't been saved previously, create a new, empty one
        if (!_privateList) {
            _privateList = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(NSArray *)allItems
{
    return [self.privateList copy];
}
 
-(PatientItem *)createPatientItem;

{
    PatientItem *item = [[PatientItem alloc] initBasic];
    [self.privateList insertObject:item atIndex:0];
    //[self.privateList addObject:item];
    return item;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"patients.archive"];
}

-(BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    //Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateList toFile:path];
}

-(void)removeItem:(PatientItem *)item
{
    NSLog(@"Before: There are %lu items in the directory", (unsigned long)[self.privateList count]);
    [self.privateList removeObjectIdenticalTo:item];
    NSLog(@"After: There are %lu items in the directory", (unsigned long)[self.privateList count]);
}

@end
