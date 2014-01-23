#import "SideBarCell.h"
#import "SWRevealViewController.h"

@interface SidebarViewController () {

    BOOL isOnline;
    UIImage *onlineImage;
    UIImage *offlineImage;
    NSString *xmppUsername;

    UIPopoverController *popoverController;
}

@property(nonatomic, strong) NSArray *menuItems;
@end

@implementation SidebarViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        onlineImage = [UIImage imageNamed:@"on"];
        offlineImage = [UIImage imageNamed:@"off"];
        _controllerMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _menuItems = @[@"viz_item", @"native_item", @"web_item", @"webnative_item", @"settings_title_item", @"login_item", @"blank_item"];
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // configure the destination view controller:
//    if ( [segue.destinationViewController isKindOfClass: [ColorViewController class]] &&
//        [sender isKindOfClass:[UITableViewCell class]] )
//    {
//        UILabel* c = [(SWUITableViewCell *)sender label];
//        ColorViewController* cvc = segue.destinationViewController;
//        
//        cvc.color = c.textColor;
//        cvc.text = c.text;
//    }

    // configure the segue.
    if ([segue isKindOfClass:[SWRevealViewControllerSegue class]]) {
        SWRevealViewControllerSegue *rvcs = (SWRevealViewControllerSegue *) segue;

        SWRevealViewController *rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );

        NSAssert( [rvc.frontViewController isKindOfClass:[UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );

        rvcs.performBlock = ^(SWRevealViewControllerSegue *rvc_segue, UIViewController *svc, UIViewController *dvc) {
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [rvc setFrontViewController:nc animated:YES];
        };
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [self.menuItems objectAtIndex:indexPath.row];

    if (cellIdentifier == nil ) {
        cellIdentifier = @"blank_item";
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    if ([cell isKindOfClass:[SideBarCell class]]) {
        SideBarCell *loginCell = (SideBarCell *) cell;
        if (isOnline) {
            loginCell.label.text = xmppUsername;
            [loginCell.leftImageView setImage:onlineImage];

        } else {
            loginCell.label.text = xmppUsername;
            [loginCell.leftImageView setImage:offlineImage];

        }
        [loginCell setNeedsDisplay];
    }

    return cell;

}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//
//    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
//    SWRevealViewController *revealController = self.revealViewController;
//
//    // We know the frontViewController is a NavigationController
//    UINavigationController *frontNavigationController = (id) revealController.frontViewController;  // <-- we know it is a NavigationController
//    NSInteger row = indexPath.row;
//
//    // Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
//    if (row == 1) {
//        // Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
//        if (![frontNavigationController.topViewController isKindOfClass:[WebViewNativeViewController class]]) {
//
//
//            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad"
//                                                                     bundle:nil];
//            WebViewNativeViewController *mapViewController = (WebViewNativeViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"mapViewController"];
//
//            //[_controllerMap setObject:graphViewController forKey:@"graphViewController"];
//
//            // }
//
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
//            [revealController setFrontViewController:navigationController animated:YES];
//        }
//                // Seems the user attempts to 'switch' to exactly the same controller he came from!
//        else {
//            [revealController revealToggle:self];
//        }
//
//    }
//
//            // ... and the second row (=1) corresponds to the "WebViewNativeViewController".
//    else if (row == 2) {
//
//
//    }
//    else if (row == 3) {
//
//
//    }
//    else if (row == 6) {
//
//
//    }
//
//
//}

- (AppDelegate *)appDelegate {
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

@end
