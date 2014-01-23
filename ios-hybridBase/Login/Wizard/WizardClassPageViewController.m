//
//  WizClassPageViewController.m
//
//
//  Created by Anthony Perritano on 8/19/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "WizardStudentPageViewController.h"
#import "WizardClassCell.h"
#import "NSManagedObject+MagicalFinders.h"
#import "WizardClassPageViewController.h"

@implementation WizardClassPageViewController


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //self.man


    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - JSON Requests


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"wizcell_class";
    WizardClassCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];


    if (cell == nil) {
        cell = [[WizardClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }


    ConfigurationInfo *ci = [self.fetchedResultsController objectAtIndexPath:indexPath];//
//   
//    // Configure the cell.
    cell.classNameLabel.text = [ci.run_id uppercaseString];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"student_segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ConfigurationInfo *ci = [self.fetchedResultsController objectAtIndexPath:indexPath];
        WizardStudentPageViewController *destViewController = segue.destinationViewController;
        [destViewController setConfigurationInfo:ci];
        [destViewController prepareData];
    }
}

- (void)setupFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ConfigurationInfo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"run_id" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];

    NSFetchedResultsController *fetch = [ConfigurationInfo MR_fetchAllSortedBy:@"run_id" ascending:NO withPredicate:nil groupBy:nil delegate:self];
    [self setFetchedResultsController:fetch];

}

- (IBAction)cancelLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

@end
