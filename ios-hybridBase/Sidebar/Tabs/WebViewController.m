//
//  WebViewController.m
//  ios-hybridBase
//
//  Created by Anthony Perritano on 1/22/14.
//  Copyright (c) 2014 Anthony Perritano. All rights reserved.
//

#import "WebViewController.h"
#import "SWRevealViewController.h"

@interface WebViewController ()
@property(nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.revealButtonItem setTarget:self.revealViewController];
    [self.revealButtonItem setAction:@selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self loadWebPage];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)loadWebPage {

    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME];
    NSString *runIdName = [[NSUserDefaults standardUserDefaults] objectForKey:RUN_ID];


    NSString *fullURL = [NSString stringWithFormat:@"http://hg.badger.encorelab.org/mobile.html?runId=%@&username=%@", runIdName, userName];


    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

@end

