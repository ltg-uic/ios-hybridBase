//
//  ConfigurationInfo.h
//  ios-hybridBase
//
//  Created by Anthony Perritano on 1/18/14.
//  Copyright (c) 2014 Anthony Perritano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ConfigurationInfo : NSManagedObject

@property(nonatomic, retain) NSString *run_id;
@property(nonatomic, retain) NSSet *nonPlayers;
@property(nonatomic, retain) NSSet *players;
@end

@interface ConfigurationInfo (CoreDataGeneratedAccessors)

- (void)addNonPlayersObject:(NSManagedObject *)value;

- (void)removeNonPlayersObject:(NSManagedObject *)value;

- (void)addNonPlayers:(NSSet *)values;

- (void)removeNonPlayers:(NSSet *)values;

- (void)addPlayersObject:(NSManagedObject *)value;

- (void)removePlayersObject:(NSManagedObject *)value;

- (void)addPlayers:(NSSet *)values;

- (void)removePlayers:(NSSet *)values;

@end
