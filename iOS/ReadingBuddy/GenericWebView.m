//
//  GenericWebView.m
//  Echo
//
//  Created by boyanl on 12/7/10.
//  Copyright 2010 Electric Literature. All rights reserved.
//

#import "GenericWebView.h"
#import "RecordController.h"

@implementation GenericWebView

@synthesize webView;
@synthesize URL;
@synthesize recordController;

static const NSString *recSuffix = @"REC";

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

/*- (void) loadPage:(NSString *)pagePath
{
	NSLog(@"[gtk web view controller] - load page - page path is: %@", pagePath);
	NSData *textFileData = [NSData dataWithContentsOfFile:pagePath];
	
	if(textFileData != nil) {
		NSLog(@"loading web view with page file: %@", pagePath);
		[webView loadData:textFileData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:
		 [NSURL URLWithString: [GTKAppDelegate getFormattedURLBaseForPath:[page stringByDeletingLastPathComponent] ] ]];
		
	}
	else {
		NSLog(@"file data is nil for file name %@", pagePath);	
		NSString *chapterText = @"<html><head><title></title></head><body>ERROR: The file for this page could not be found.</p></body></html>";
		
		[myWebView loadHTMLString:chapterText baseURL:[NSURL URLWithString:[GTKAppDelegate getAppURLBase]]]; 
	}		 
}*/

+ (NSString *) getFormattedURLBaseForPath: (NSString *) rPath
{
	NSString *URLBase = [rPath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
	URLBase = [URLBase stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	URLBase = [NSString stringWithFormat:@"file:/%@//",URLBase];
	
	return URLBase;	
	
}


- (void) reload 
{
    NSLog(@"[generic web view] - reload - url is: %@", self.URL);
    
    if (!self.URL) {
        return;
    }
    
    if ([self.URL hasPrefix:@"http:"]) {
        NSURL* url = [NSURL URLWithString:self.URL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:requestObj];
    }
    else {
        NSData *textFileData = [NSData dataWithContentsOfFile:self.URL];
        
        if(textFileData != nil) {
            NSLog(@"loading web view with page file: %@", self.URL);
            [webView loadData:textFileData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:
             [NSURL URLWithString: [GenericWebView getFormattedURLBaseForPath:[self.URL stringByDeletingLastPathComponent] ] ]];
            
        }
    }
}

- (void) setURL:(NSString *)URLVar
{
    URL = URLVar;
    [self reload];
}

- (IBAction) hideRecordPane
{
    [recordController.view removeFromSuperview];
    
    CGRect webFrame = webView.frame;
    webFrame.size.height += recordController.view.frame.size.height;
    webView.frame = webFrame;
}

- (void) doRecord
{
    if (!recordController) {
        recordController = [[RecordController alloc] initWithNibName:nil bundle:nil];
        recordController.parentController = self;
    }
    
    if ([recordController.view superview]) {
        return;
    }
    
    CGRect webFrame = webView.frame;
    webFrame.size.height -= recordController.view.frame.size.height;
    webView.frame = webFrame;
    
    [self.view addSubview:recordController.view];
    recordController.view.frame = CGRectMake(0, webFrame.size.height, recordController.view.frame.size.width, recordController.view.frame.size.height);
    
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:recordController];
    
    //[self presentModalViewController:nav animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"[generic web view] - should start load with request - request url: %@", request.URL); 
    
    if ([[request.URL absoluteString] hasSuffix:recSuffix]) {
        [self doRecord];
        //return NO;
    }
    
    return YES;
}

- (void) viewDidLoad {
    NSLog(@"[generic web view] - view did load - webview is : %@", self.webView);
    
    
    //[self reload];
    
//    UIBarButtonItem *backButton = [UIUtil makeBarStandardBackButtonItem:self :@selector(goBack)];
//    self.navigationItem.leftBarButtonItem = backButton;
//    [backButton release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        //only landscape mode on the ipad
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation != UIInterfaceOrientationPortrait);
    }
}


@end
