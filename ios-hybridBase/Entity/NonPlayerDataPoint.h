//
//  NonPlayerDataPoint.h
//  ios-hybridBase
//
//  Created by Anthony Perritano on 1/18/14.
//  Copyright (c) 2014 Anthony Perritano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PlayerDataPoint.h"


@interface NonPlayerDataPoint : PlayerDataPoint

@property (nonatomic, retain) NSString * type;

@end
