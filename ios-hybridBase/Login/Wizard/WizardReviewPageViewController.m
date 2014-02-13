//
//  WizardReviewPageViewController.m
//
//
//  Created by Anthony Perritano on 8/21/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "WizardReviewPageViewController.h"
#import "AppDelegate.h"

@interface WizardReviewPageViewController ()

@end

@implementation WizardReviewPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    [yesButton setTitle:[[_choosen_student uppercaseString] stringByAppendingString:@" - YES!!"] forState:UIControlStateNormal];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doLoginWithStudentName:(id)sender {

//
//  NSString *xmppId = [_configurationInfo.run_id stringByAppendingFormat:@"#%@", [_choosen_student lowercaseString]];
//
    [[NSUserDefaults standardUserDefaults] setObject:[_choosen_student lowercaseString] forKey:USER_NAME];
//
    [[NSUserDefaults standardUserDefaults] setObject:[_configurationInfo.run_id lowercaseString] forKey:RUN_ID];
//
    //[[NSUserDefaults standardUserDefaults] setObject:_configurationInfo.run_id forKey:kXMPProomJID];
//
//    DDLogVerbose(@"HARVEST: USER LOGGED IN %@ with RUNID %@", xmppId, _configurationInfo.run_id);


    [self dismissViewControllerAnimated:YES completion:^(void) {

        //TODO connect to roll call here
        //[[self appDelegate] setupConfigurationAndRosterWithRunId:_configurationInfo.run_id WithPatchId:nil];

    }];


}

- (AppDelegate *)appDelegate {
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}


@end
