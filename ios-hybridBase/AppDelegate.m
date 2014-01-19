//
//  AppDelegate.m
//  ios-hybridBase
//
//  Created by Anthony Perritano on 1/17/14.
//  Copyright (c) 2014 Anthony Perritano. All rights reserved.
//

#import <SWRevealViewController/SWRevealViewController.h>
#import "AppDelegate.h"
#import "Reachability.h"


#define kXMPPmyJID nil
#define kXMPPmyPassword nil

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self pullConfigurationData];
    //Failed to instantiate the default view controller for UIMainStoryboardFile 'MainStoryboard_iPad' - perhaps the designated entry point is not set?[self setupTestUser];
    //[self setupConfigurationAndRosterWithRunId:@"5ag"];
    [self customizeGlobalAppearance];


    //setup test data

    [self deleteAllObjects:@"PlayerDataPoint"];
    [self deleteAllObjects:@"NonPlayerDataPoint"];
    [self deleteAllObjects:@"PatchInfo"];
    [self deleteAllObjects:@"ConfigurationInfo"];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}


- (void)setReachability {
    // Allocate a reachability object
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];

    // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
    reach.reachableOnWWAN = NO;

    // Here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];

    [reach startNotifier];
}

#pragma NETWORK OPERATIONS

- (void)pullConfigurationData {

    NSURL *url = [NSURL URLWithString:@"http://ltg.evl.uic.edu:9292/hunger-games-fall-13/configuration"];
    operationQueue = [[NSOperationQueue alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        for (NSDictionary *someConfig in responseObject) {


            NSString *run_id = [someConfig objectForKey:@"run_id"];


            ConfigurationInfo *ci = [self insertConfigurationWithRunId:run_id];


            [self.managedObjectContext save:nil];


            [operationQueue addOperation:[self pullRosterDataWithRunId:ci WithCompletionBlock:nil]];
        }

        [operationQueue addOperationWithBlock:^{

            //[self checkConnectionWithUser];

        }];
    }                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
    }];


    [operationQueue waitUntilAllOperationsAreFinished];
    [operationQueue setMaxConcurrentOperationCount:1];
    [operationQueue addOperation:operation1];
}

- (NSOperation *)pullRosterDataWithRunId:(ConfigurationInfo *)configurationInfo WithCompletionBlock:(void (^)())block {
    NSURL *url = [NSURL URLWithString:[@"http://ltg.evl.uic.edu:9000/runs/" stringByAppendingString:configurationInfo.run_id]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSArray *students = [data objectForKey:@"roster"];

        for (NSDictionary *someStudent in students) {

            BOOL isStudent = YES;

            NSString *rfid = [someStudent objectForKey:@"rfid_tag"];

            if (rfid == nil ) {
                isStudent = NO;
                NonPlayerDataPoint *npdp = [self insertNonPlayerDataPointWithColor:[someStudent objectForKey:@"color"] WithLabel:[someStudent objectForKey:@"label"] WithPatch:nil WithRfid:[someStudent objectForKey:@"rfid_tag"] WithScore:[NSNumber numberWithInt:0] WithId:[someStudent objectForKey:@"_id"] asStudent:isStudent WithType:@"teacher"];
                [configurationInfo addNonPlayersObject:npdp];
            } else {
                PlayerDataPoint *pdp = [self insertPlayerDataPointWithColor:[someStudent objectForKey:@"color"] WithLabel:[someStudent objectForKey:@"label"] WithPatch:nil WithRfid:[someStudent objectForKey:@"rfid_tag"] WithScore:[NSNumber numberWithInt:0] WithId:[someStudent objectForKey:@"_id"] asStudent:isStudent];

                [configurationInfo addPlayersObject:pdp];
            }


        }


        [self.managedObjectContext save:nil];
    }                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
    }];


    return op;
}


#pragma mark REACHABILITY


- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *reach = [note object];

    if ([reach isReachable]) {
        //@"Notification Says Reachable";
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network out yo"
                                                            message:@"Hello how are you? Network is out"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];

    }

}


#pragma mark INTERFACE CUSTOM METHODS

- (void)setupInterface {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;


    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad"
                                                             bundle:nil];

    SidebarViewController *sideViewController = (SidebarViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"sidebarViewController"];

    UIViewController *mapViewController = (UIViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"mapViewController"];


    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];

    [[sideViewController controllerMap] setObject:frontNavigationController forKey:@"mapViewController"];

    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:sideViewController];

    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    revealController.delegate = self;



    //revealController.bounceBackOnOverdraw=NO;
    //revealController.stableDragOnOverdraw=YES;

    self.viewController = revealController;

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];


}

- (void)customizeGlobalAppearance {

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor blackColor], NSForegroundColorAttributeName,
            [UIFont fontWithName:@"helveticaNeue" size:21.0], NSFontAttributeName, nil]];

}

- (void)clearUserDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kXMPPmyJID];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kXMPPmyPassword];
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {

    if (managedObjectContext != nil) {
        return managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"localdb.sqlite"];

    NSError *error = nil;

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return persistentStoreCoordinator;
}

#pragma mark CORE DATA DELETES

- (void)deleteAllObjects:(NSString *)entityDescription {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];

    NSError *error;
    NSArray *items = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];


    for (NSManagedObject *managedObject in items) {
        [[self managedObjectContext] deleteObject:managedObject];
        //NSLog(@"%@ object deleted",entityDescription);
    }
    if (![[self managedObjectContext] save:&error]) {
        //NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }

}


- (ConfigurationInfo *)insertConfigurationWithRunId:(NSString *)run_id {


    ConfigurationInfo *ci = [NSEntityDescription insertNewObjectForEntityForName:@"ConfigurationInfo"
                                                          inManagedObjectContext:self.managedObjectContext];

    ci.run_id = run_id;
    ci.players = nil;

    return ci;
}


- (NonPlayerDataPoint *)insertNonPlayerDataPointWithColor:(NSString *)color WithLabel:(NSString *)label WithPatch:(NSString *)patch WithRfid:(NSString *)rfid_tag WithScore:(NSNumber *)score WithId:(NSString *)player_id asStudent:(BOOL)isStudent WithType:(NSString *)type {
    NonPlayerDataPoint *pdp = [NSEntityDescription insertNewObjectForEntityForName:@"NonPlayerDataPoint"
                                                            inManagedObjectContext:self.managedObjectContext];
    pdp.color = color;
    pdp.rfid_tag = rfid_tag;
    pdp.score = [NSNumber numberWithInt:(arc4random() % 1000)];
    pdp.player_id = player_id;
    pdp.student = [NSNumber numberWithBool:isStudent];
    pdp.type = type;

    if (_colorMap == nil ) {
        _colorMap = [[NSMutableDictionary alloc] init];
    }

    if (color != nil ) {
        UIColor *hexColor = [UIColor colorWithHexString:[color stringByReplacingOccurrencesOfString:@"#" withString:@""]];
        [_colorMap setObject:hexColor forKey:color];
    } else {

        color = [NSString stringWithFormat:@"black%d", (arc4random() % 10)];
        pdp.color = color;
        [_colorMap setObject:[UIColor redColor] forKey:color];
    }


    return pdp;
}


- (PlayerDataPoint *)insertPlayerDataPointWithColor:(NSString *)color WithLabel:(NSString *)label WithPatch:(NSString *)patch WithRfid:(NSString *)rfid_tag WithScore:(NSNumber *)score WithId:(NSString *)player_id asStudent:(BOOL)isStudent {
    PlayerDataPoint *pdp = [NSEntityDescription insertNewObjectForEntityForName:@"PlayerDataPoint"
                                                         inManagedObjectContext:self.managedObjectContext];
    pdp.color = color;
    pdp.rfid_tag = rfid_tag;
    pdp.score = score;
    //pdp.score = [NSNumber numberWithInt:(arc4random() % 1000)];
    pdp.player_id = player_id;
    pdp.student = [NSNumber numberWithBool:isStudent];

    if (_colorMap == nil ) {
        _colorMap = [[NSMutableDictionary alloc] init];
    }

    if (color != nil ) {
        UIColor *hexColor = [UIColor colorWithHexString:[color stringByReplacingOccurrencesOfString:@"#" withString:@""]];
        [_colorMap setObject:hexColor forKey:color];
    } else {

        color = [NSString stringWithFormat:@"black%d", (arc4random() % 10)];
        pdp.color = color;
        [_colorMap setObject:[UIColor redColor] forKey:color];
    }


    return pdp;
}


- (void)createEventInfoWithRFID:(NSString *)rfid WithEventType:(NSString *)eventType WithScore:(NSNumber *)score {
    EventInfo *ei = [NSEntityDescription insertNewObjectForEntityForName:@"EventInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
    ei.rfid_tag = rfid;
    ei.event_type = eventType;
    ei.score = score;
    ei.timestamp = [NSDate date];

    [self.managedObjectContext save:nil];
}

#pragma mark CORE DATA FETCHES

- (PlayerDataPoint *)getPlayerDataPointWithRFID:(NSString *)rfid {
    NSManagedObjectModel *model = [[self.managedObjectContext persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest *request = [model fetchRequestFromTemplateWithName:@"playerDataPointWithRFID" substitutionVariables:@{@"RFID" : rfid}];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];

    if (results.count == 0) {
        return nil;
    }

    return [results objectAtIndex:0];
}

- (NSArray *)getAllPatchInfos {
    NSManagedObjectModel *model = [[self.managedObjectContext persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest *request = [model fetchRequestFromTemplateWithName:@"allPatchInfos" substitutionVariables:nil];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    return results;

}

- (NSArray *)getAllPlayerDataPoints {
    NSManagedObjectModel *model = [[self.managedObjectContext persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest *request = [model fetchRequestFromTemplateWithName:@"allPlayerDataPoints" substitutionVariables:nil];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    return results;

}

- (NSArray *)getAllNonPlayerDataPoints {
    NSManagedObjectModel *model = [[self.managedObjectContext persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest *request = [model fetchRequestFromTemplateWithName:@"allNonPlayerDataPoints" substitutionVariables:nil];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    return results;

}

- (NSArray *)getAllConfigurationsInfos {
    NSManagedObjectModel *model = [[self.managedObjectContext persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest *request = [model fetchRequestTemplateForName:@"allConfigurationInfos"];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];

    if (results.count == 0) {
        return nil;
    }

    return results;

}

- (ConfigurationInfo *)getConfigurationInfoWithRunId:(NSString *)run_id {
    NSManagedObjectModel *model = [[self.managedObjectContext persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest *request = [model fetchRequestFromTemplateWithName:@"configurationInfoWithRunId"
                                                substitutionVariables:@{@"RUN_ID" : run_id}];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];

    if (results.count == 0) {
        return nil;
    }

    return [results objectAtIndex:0];
}
@end