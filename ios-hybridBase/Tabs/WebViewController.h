//
//  WebViewController.h
//  ios-hybridBase
//
//  Created by Anthony Perritano on 1/22/14.
//  Copyright (c) 2014 Anthony Perritano. All rights reserved.
//

@interface WebViewController : UIViewController {
    __weak IBOutlet UIWebView *webView;
}

- (IBAction)reloadWebPage:(id)sender;

@end
