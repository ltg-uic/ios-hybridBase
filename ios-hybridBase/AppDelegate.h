//
//  AppDelegate.h
//  ios-hybridBase
//
//  Created by Anthony Perritano on 1/17/14.
//  Copyright (c) 2014 Anthony Perritano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AFNetworking.h"
#import "SidebarViewController.h"
#import "ConfigurationInfo.h"

@class SWRevealViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSOperationQueue *operationQueue;
}

@property(strong, nonatomic) UIWindow *window;

@property(strong, nonatomic) SWRevealViewController *viewController;
@property(nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

//entities
@property(strong, nonatomic) NSArray *playerDataPoints;
@property(strong, nonatomic) NSMutableDictionary *colorMap;
@property(strong, nonatomic) ConfigurationInfo *configurationInfo;


- (void)setupConfigurationAndRosterWithRunId:(NSString *)run_id WithPatchId:(NSString *)current_patchId;

- (NSArray *)getAllNonPlayerDataPoints;
@end