//
//  HeartSoundList.m
//  Stethaid
//
//  Created by Administrator on 4/8/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

#import "HeartSoundList.h"
#import "HeartSoundItem.h"


@interface HeartSoundList ()

@property (nonatomic) NSMutableArray *privateList;

@end

@implementation HeartSoundList

+(instancetype)sharedList
{
    static HeartSoundList *sharedList;
    if (!sharedList){
        sharedList = [[self alloc] initPrivate];
    }
    return sharedList;
}

//If a programmer calls [[HeartSoundList alloc] init], let him know that it is a singleton
-(instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use + [HeartSoundList sharedList]"];
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

-(HeartSoundItem *)createHeartSoundItem
{
    HeartSoundItem *item = [[HeartSoundItem alloc] initBasic]; 
    [self.privateList addObject:item];
    return item;
}

-(HeartSoundItem *)createHeartSoundItemWithName:patientName
                                   subtitleText:subtitle
                                   pathForAudio:audiopathExtension;
{
    HeartSoundItem *item = [[HeartSoundItem alloc] initWithTitle:patientName subtitleText:subtitle pathForAudio:audiopathExtension];
    [self.privateList addObject:item];
    return item;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

-(BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    //Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateList toFile:path];
}

-(void)removeItem:(HeartSoundItem *)item
{
    [self.privateList removeObjectIdenticalTo:item];
}

-(BOOL)doesThisFileStillExist: (NSString*)filename
{
    NSArray *heartSoundDirectory = [[HeartSoundList sharedList] allItems];
    NSMutableArray *filenames = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < heartSoundDirectory.count; i++) {
        HeartSoundItem *hsitem = heartSoundDirectory[i];
        NSString *filenamei = hsitem.pathExtension;
        [filenames addObject:filenamei];
    }
    NSArray *simpleArrayVersion = filenames;
    NSInteger anIndex=[simpleArrayVersion indexOfObject:filename];
    if(NSNotFound == anIndex) {
        NSLog(@"not found");
        return NO;
    }
    
    return YES;
}

-(HeartSoundItem *)findHeartSoundItemWithFilename: (NSString*)filename
{
    NSArray *heartSoundDirectory = [[HeartSoundList sharedList] allItems];
    NSMutableArray *filenames = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < heartSoundDirectory.count; i++) {
        HeartSoundItem *hsitem = heartSoundDirectory[i];
        NSString *filenamei = hsitem.pathExtension;
        [filenames addObject:filenamei];
    }
    
    NSArray *simpleArrayVersion = filenames;
    NSUInteger indexOfTheObject = [simpleArrayVersion indexOfObject: [filename substringFromIndex:4]];
    
    //Retrieve a copy of the object at the correct index from the master directory
    HeartSoundItem *heartSoundItem = [[[HeartSoundList sharedList] allItems] objectAtIndex:indexOfTheObject];
    return heartSoundItem;
}

@end
