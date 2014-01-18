//
//  WizardStudentPageViewController.m
//
//
//  Created by Anthony Perritano on 8/20/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "WizardStudentPageViewController.h"
#import "WizardReviewPageViewController.h"
#import "WizardStudentCell.h"

@interface WizardStudentPageViewController () {
    NSMutableArray *playerPoints;
    NSArray *sortedPlayerPoints;
}

@end

@implementation WizardStudentPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)prepareData {
    playerPoints = [[NSMutableArray alloc] init];

    [playerPoints addObjectsFromArray:[[_configurationInfo players] allObjects]];
    [playerPoints addObjectsFromArray:[[_configurationInfo nonPlayers] allObjects]];

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"player_id" ascending:YES selector:@selector(caseInsensitiveCompare:)];

    sortedPlayerPoints = [playerPoints sortedArrayUsingDescriptors:@[sort]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return sortedPlayerPoints.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WizardStudentCell *wz = [collectionView dequeueReusableCellWithReuseIdentifier:@"student_cell" forIndexPath:indexPath];

    PlayerDataPoint *pdp = [sortedPlayerPoints objectAtIndex:indexPath.row];

    UIColor *hexColor = [UIColor colorWithHexString:[pdp.color stringByReplacingOccurrencesOfString:@"#" withString:@""]];

    wz.nameLabel.backgroundColor = hexColor;
    wz.nameLabel.textColor = [self getTextColor:hexColor];
    wz.nameLabel.text = [pdp.player_id uppercaseString];

    return wz;
}

- (UIColor *)getTextColor:(UIColor *)color {
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);

    CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
    if (colorBrightness < 0.5) {
        // NSLog(@"my color is dark");
        return [UIColor whiteColor];
    }
    else {
        //NSLog(@"my color is light");
        return [UIColor blackColor];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"review_segue"]) {

        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        WizardStudentCell *wz = (WizardStudentCell *) [self.collectionView cellForItemAtIndexPath:indexPaths[0]];

        _choosen_student = wz.nameLabel.text;

        WizardReviewPageViewController *destViewController = segue.destinationViewController;
        [destViewController setConfigurationInfo:_configurationInfo];
        [destViewController setChoosen_student:_choosen_student];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (AppDelegate *)appDelegate {
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

@end
