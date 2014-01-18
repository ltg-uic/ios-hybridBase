//
//  PlayerDataPoint.h
//  ios-hybridBase
//
//  Created by Anthony Perritano on 1/18/14.
//  Copyright (c) 2014 Anthony Perritano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConfigurationInfo;

@interface PlayerDataPoint : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * player_id;
@property (nonatomic, retain) NSString * rfid_tag;
@property (nonatomic) float score;
@property (nonatomic) BOOL student;
@property (nonatomic, retain) ConfigurationInfo *configurationInfo;

@end
