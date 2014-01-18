//
//  WizardReviewPageViewController.h
//
//
//  Created by Anthony Perritano on 8/21/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WizardReviewPageViewController : UIViewController {

    __weak IBOutlet UIButton *yesButton;
    __weak IBOutlet UILabel *studentNameLabel;
}

@property(nonatomic, retain) ConfigurationInfo *configurationInfo;
@property(nonatomic, retain) NSString *choosen_student;


- (IBAction)cancelLogin:(id)sender;

- (IBAction)doLoginWithStudentName:(id)sender;

@end
