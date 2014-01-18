//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface MapViewController () {

}

@end

@implementation MapViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {


    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.

    [self.revealButtonItem setTarget:self.revealViewController];
    [self.revealButtonItem setAction:@selector( revealToggle: )];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
