//
//  NativeViewController.m
//  ios-hybridBase
//
//  Created by Anthony Perritano on 1/22/14.
//  Copyright (c) 2014 Anthony Perritano. All rights reserved.
//

#import "NativeViewController.h"
#import "SWRevealViewController.h"

@interface NativeViewController ()

@property(weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property(weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property(nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@end

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.revealButtonItem setTarget:self.revealViewController];
    [self.revealButtonItem setAction:@selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    _usernameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"];
    _passwordLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_PASSWORD"];
}

- (void)didLogin {

}

- (void)didLogout {

}


@end
