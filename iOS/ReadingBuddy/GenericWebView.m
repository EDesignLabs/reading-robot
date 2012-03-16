//
//  GenericWebView.m
//  Echo
//
//  Created by boyanl on 12/7/10.
//  Copyright 2010 Electric Literature. All rights reserved.
//

#import "GenericWebView.h"

@implementation GenericWebView

@synthesize webView;
@synthesize URL;

- (id) initWithPageURL:(NSString *) url
{
	if ((self = [super init])) {
		self.URL = url;
	}
	return self;
}

- (void) goBack {
    [self.navigationController popViewControllerAnimated:YES]; 
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"[generic web view] - web view did finish load");
}

- (void) reload 
{
    NSLog(@"[generic web view] - reload - url is: %@", self.URL);
    
    if (!self.URL) {
        return;
    }
    
    NSURL* url = [NSURL URLWithString:self.URL];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:requestObj];
}

- (void) setURL:(NSString *)URLVar
{
    URL = URLVar;
    [self reload];
}

- (void) viewDidLoad {
    NSLog(@"[generic web view] - view did load - webview is : %@", self.webView);
    //[self reload];
    
//    UIBarButtonItem *backButton = [UIUtil makeBarStandardBackButtonItem:self :@selector(goBack)];
//    self.navigationItem.leftBarButtonItem = backButton;
//    [backButton release];
}


@end
