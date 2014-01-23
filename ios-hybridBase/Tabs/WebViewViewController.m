//
//  WebViewViewController.m
//  ios-hybridBase
//
//  Created by Anthony Perritano on 1/22/14.
//  Copyright (c) 2014 Anthony Perritano. All rights reserved.
//

#import "WebViewViewController.h"
#import "SWRevealViewController.h"

@interface WebViewViewController ()
@property(nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.revealButtonItem setTarget:self.revealViewController];
    [self.revealButtonItem setAction:@selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

@end

