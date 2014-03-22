//
//  EventInfo.h
//  ios-hybridBase
//
//  Created by Anthony Perritano on 1/18/14.
//  Copyright (c) 2014 Anthony Perritano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventInfo : NSManagedObject

@property(nonatomic, retain) NSString *event_type;
@property(nonatomic, retain) NSString *rfid_tag;
@property(nonatomic, retain) NSNumber *score;
@property(nonatomic, retain) NSDate *timestamp;

@end
