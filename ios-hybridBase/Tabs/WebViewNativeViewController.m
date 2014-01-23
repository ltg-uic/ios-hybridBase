//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "WebViewNativeViewController.h"
#import "SWRevealViewController.h"

@interface WebViewNativeViewController ()
@property(nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation WebViewNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.revealButtonItem setTarget:self.revealViewController];
    [self.revealButtonItem setAction:@selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


@end
