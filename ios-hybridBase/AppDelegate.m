//
//  AppDelegate.m
//  ios-hybridBase
//
//  Created by Anthony Perritano on 1/17/14.
//  Copyright (c) 2014 Anthony Perritano. All rights reserved.
//

#import <SWRevealViewController/SWRevealViewController.h>
#import "AppDelegate.h"
#import "CoreData+MagicalRecord.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [MagicalRecord setupCoreDataStackWithStoreNamed:@"entity-db.sqlite"];
    [self pullConfigurationData];
    [self customizeGlobalAppearance];

    //clear the cache
    [PlayerDataPoint MR_truncateAll];
    [NonPlayerDataPoint MR_truncateAll];
    [ConfigurationInfo MR_truncateAll];

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
    [MagicalRecord cleanUp];
}

#pragma NETWORK OPERATIONS

- (void)pullConfigurationData {

    NSURL *url = [NSURL URLWithString:CONFIGURATION_URL];
    operationQueue = [[NSOperationQueue alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *configurationRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    configurationRequestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [configurationRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        for (NSDictionary *someConfig in responseObject) {
            NSString *run_id = [someConfig objectForKey:@"run_id"];
            ConfigurationInfo *ci = [self insertConfigurationWithRunId:run_id];
            AFHTTPRequestOperation *rosterOperation = [self pullRosterDataWithRunId:ci];
            [operationQueue addOperation:rosterOperation];
        }


    }                                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
    }];


    [operationQueue waitUntilAllOperationsAreFinished];
    [operationQueue setMaxConcurrentOperationCount:1];
    [operationQueue addOperation:configurationRequestOperation];
    [operationQueue addOperationWithBlock:^{
        [self checkConnectionWithUser];
    }];
}

- (void)checkConnectionWithUser {
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"];

    if (userName == nil ) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad"
                                                                     bundle:nil];
            // UIViewController *controller = (UIViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"WizardNavController"];
            // [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
        });
    }
}

- (AFHTTPRequestOperation *)pullRosterDataWithRunId:(ConfigurationInfo *)configurationInfo {
    NSURL *url = [NSURL URLWithString:[ROSTER_URL stringByAppendingString:configurationInfo.run_id]];

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


        [MagicalRecord saveUsingCurrentThreadContextWithBlock:nil completion:nil ];

    }                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
    }];


    return op;
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
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_PASSWORD];
}


- (ConfigurationInfo *)insertConfigurationWithRunId:(NSString *)run_id {
    ConfigurationInfo *ci = [ConfigurationInfo MR_createEntity];
    ci.run_id = run_id;
    ci.players = nil;
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:nil completion:nil ];
    return ci;
}

- (NonPlayerDataPoint *)insertNonPlayerDataPointWithColor:(NSString *)color WithLabel:(NSString *)label WithPatch:(NSString *)patch WithRfid:(NSString *)rfid_tag WithScore:(NSNumber *)score WithId:(NSString *)player_id asStudent:(BOOL)isStudent WithType:(NSString *)type {
    NonPlayerDataPoint *pdp = [NonPlayerDataPoint MR_createEntity];
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
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:nil completion:nil ];

    return pdp;
}

- (PlayerDataPoint *)insertPlayerDataPointWithColor:(NSString *)color WithLabel:(NSString *)label WithPatch:(NSString *)patch WithRfid:(NSString *)rfid_tag WithScore:(NSNumber *)score WithId:(NSString *)player_id asStudent:(BOOL)isStudent {
    PlayerDataPoint *pdp = [PlayerDataPoint MR_createEntity];
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

    [MagicalRecord saveUsingCurrentThreadContextWithBlock:nil completion:nil ];

    return pdp;
}

@end