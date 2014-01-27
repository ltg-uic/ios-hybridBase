//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "WebViewNativeViewController.h"
#import "SWRevealViewController.h"
#import "UIWebView+TS_JavaScriptContext.h"

@interface WebViewNativeViewController () <UITextFieldDelegate, TSWebViewDelegate>
@property(weak, nonatomic) IBOutlet UIWebView *splitWebView;
@property(weak, nonatomic) IBOutlet UITextField *nativeTextField;
@property(nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation WebViewNativeViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.revealButtonItem setTarget:self.revealViewController];
    [self.revealButtonItem setAction:@selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self loadWebPage];
    _nativeTextField.delegate = self;
}

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx {
    ctx[@"sayHello"] = ^{

        dispatch_async(dispatch_get_main_queue(), ^{

            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Hello, World! I'm a native Alert!!!"
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];

            [av show];
        });
    };


    ctx[@"textChanged"] = ^(JSValue *textbox) {

        JSValue *v = textbox[@"value"];

        dispatch_async(dispatch_get_main_queue(), ^{
            _nativeTextField.text = [v toString];
        });
    };

    ctx[@"viewController"] = self;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSLog(@"@d", string);

    return YES;
}

- (void)loadWebPage {
    [_splitWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"webpage" ofType:@"html"] isDirectory:NO]]];
}

@end
