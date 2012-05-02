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
@synthesize loaded;
@synthesize fliteController;

static const NSString *recSuffix = @"_REC";
static const NSString *TEXT_TO_SPEECH_SUFFIX = @"_TTS";
static const NSString *HIDE_RECORD_TRIGGER = @"HIDE_REC";

- (FliteController *)fliteController {
    if (fliteController == nil) {
        fliteController = [[FliteController alloc] init]; // Please use this style of lazy accessor to instantiate the object
        self.fliteController.duration_stretch = 1.2; // Change the speed
        self.fliteController.target_mean = 1.2; // Change the pitch
        self.fliteController.target_stddev = 1.7; // Change the variance        
    }
    return fliteController;
}

- (id) initWithPageURL:(NSString *) url
{
	if ((self = [super initWithNibName:@"WebView" bundle:nil])) {
		self.URL = url;
        loaded = NO;
	}
	return self;
}

- (void) goBack {
    [self.navigationController popViewControllerAnimated:YES]; 
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"[generic web view] - web view did finish load");
    self.loaded = YES;
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"ipadstart();"];

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
        loaded = NO;

        [self.webView loadRequest:requestObj];
    }
    else {
        NSData *textFileData = [NSData dataWithContentsOfFile:self.URL];
        
        if(textFileData != nil) {
            loaded = NO;

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
        recordController.view;
    }
    
    if ([recordController.view superview]) {
        return;
    }
    
    //clear recorder
    if (!recordController.reRecordButton.hidden) {
        [recordController reRecordButtonPressed];
    }
    
    CGRect webFrame = webView.frame;

    webFrame.size.height = webFrame.size.height - recordController.view.frame.size.height;
    if (self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
        //webFrame.origin.y += recordController.view.frame.size.height;
    }
    
    webView.frame = webFrame;
    
    [self.view addSubview:recordController.view];
    [self.view bringSubviewToFront:recordController.view];
    
    recordController.view.frame = CGRectMake(0, self.view.frame.size.width - recordController.view.frame.size.height, recordController.view.frame.size.width, recordController.view.frame.size.height);
    
    NSLog(@"[generic web view] - do record - web frame height: %f, width: %f; record controller height: %f; controller width: %f", webView.frame.size.height, webView.frame.size.width, recordController.view.frame.size.height, self.view.frame.size.width);
    
    [self.view setNeedsDisplay];
    
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:recordController];
    
    //[self presentModalViewController:nav animated:YES];
}

- (NSString *) getTextFromURL: (NSString *) urlString
{
    NSString *attr = @"text=";
    NSRange textAttrRange = [urlString rangeOfString:attr];
    if (textAttrRange.location == NSNotFound) {
        return nil;
    }
    
    int startIndex = textAttrRange.location + textAttrRange.length;
    NSString *textString = [urlString substringFromIndex:startIndex];
    textString = [textString stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    return textString;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"[generic web view] - should start load with request - request url: %@", request.URL); 
    
    if ([[request.URL absoluteString] rangeOfString:HIDE_RECORD_TRIGGER].location != NSNotFound) {
        [self hideRecordPane];
    }
    
    if ([[request.URL absoluteString] hasSuffix:recSuffix]) {
        NSLog(@"record command recognized");
        [self doRecord];
        return NO;
    }
    
    if ([[request.URL absoluteString] rangeOfString:TEXT_TO_SPEECH_SUFFIX].location != NSNotFound) {

        NSString *textToSpeak = [self getTextFromURL:[request.URL absoluteString]];
        
        NSLog(@"text to speech triggered; text: %@", textToSpeak);
        if (!textToSpeak) {
            return NO;
        }
        
        [self.fliteController say:textToSpeak withVoice:@"cmu_us_slt"];
        return NO;
    }
    
    
    return YES;
}

- (void) viewDidLoad {
    NSLog(@"[generic web view] - view did load - webview is : %@", self.webView);

    
    [self reload];
    
//    UIBarButtonItem *backButton = [UIUtil makeBarStandardBackButtonItem:self :@selector(goBack)];
//    self.navigationItem.leftBarButtonItem = backButton;
//    [backButton release];
}

- (void) uploadSucceededWithResponse:(NSString *) responseString
{
    NSLog(@"[generic web view] - upload succeeed with response: %@", responseString);
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"recordResultURL(\"%@\");", responseString]];
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


- (void)dealloc {
    [fliteController release];
    [super dealloc];
}

@end
