//
//  WizardStudentPageViewController.h
//
//
//  Created by Anthony Perritano on 8/20/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WizardStudentPageViewController : UICollectionViewController {

}

@property(nonatomic, retain) ConfigurationInfo *configurationInfo;
@property(nonatomic, retain) NSString *choosen_student;

- (void)prepareData;
@end

