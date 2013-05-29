//
//  GenericWebView.m
//  Echo
//
//  Created by boyanl on 12/7/10.
//  Copyright 2010 Electric Literature. All rights reserved.
//

#import "GenericWebView.h"
#import "RecordController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation GenericWebView

@synthesize webView;
@synthesize URL;
@synthesize recordController;
@synthesize loaded;
@synthesize fliteController;
@synthesize openEarsEventsObserver;

static const NSString *recSuffix = @"_REC";
static const NSString *TEXT_TO_SPEECH_SUFFIX = @"_TTS";
static const NSString *HIDE_RECORD_TRIGGER = @"HIDE_REC";
static const NSString *RERECORD_TRIGGER = @"REDO_REC";
static const NSString *ACCEPT_TRIGGER = @"ACCEPT_REC";

- (FliteController *)fliteController {
    if (fliteController == nil) {
        fliteController = [[FliteController alloc] init]; // Please use this style of lazy accessor to instantiate the object
        self.fliteController.duration_stretch = 1.0; // Change the speed
        self.fliteController.target_mean = 1.5; // Change the pitch
        self.fliteController.target_stddev = 2.0; // Change the variance        
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

- (BOOL)isHeadsetPluggedIn {
        
    UInt32 routeSize = sizeof (CFStringRef);
    CFStringRef route;
    
    OSStatus error = AudioSessionGetProperty (kAudioSessionProperty_AudioRoute,
                                              &routeSize,
                                              &route);
    
    /* Known values of route:
     * "Headset"
     * "Headphone"
     * "Speaker"
     * "SpeakerAndMicrophone"
     * "HeadphonesAndMicrophone"
     * "HeadsetInOut"
     * "ReceiverAndMicrophone"
     * "Lineout"
     */

    NSLog(@"[generic web view] - is headset plugged in - status returned %d", (int) error);
    
    if ((route != NULL)) {
                
        NSString* routeStr = (NSString*)route;

        NSLog(@"[generic web view] - is headset plugged in - route string: %@", (NSString*)route);
        
        NSRange headphoneRange = [routeStr rangeOfString : @"Head"];
        
        if (headphoneRange.location != NSNotFound) return YES;
        
    }
    
    return NO;
}

- (OpenEarsEventsObserver *)openEarsEventsObserver {
    if (openEarsEventsObserver == nil) {
        openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init]; // Please use this style of lazy accessor to instantiate the object
    }
    return openEarsEventsObserver;
}


- (void) goBack {
    [self.navigationController popViewControllerAnimated:YES]; 
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"[generic web view] - web view did finish load");
    self.loaded = YES;
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"ipadstart();"];
    
    //for testing purposes
    //[self doRecord];
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
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.30];

    recordController.view.frame = [self getOffRect];
    
    [UIView commitAnimations];
}

- (CGRect) getOffRect
{
    return CGRectMake(1024 - 360, 768, 360, recordController.view.frame.size.height);
    
    //CGRectMake(self.view.frame.size.width - recordController.view.frame.size.width - 20, self.view.frame.size.height, recordController.view.frame.size.width, recordController.view.frame.size.height);
}

- (CGRect) getOnRect
{
    return CGRectMake(1024 - 360, 768 - 90 - 20, 360, recordController.view.frame.size.height);
    
    //CGRectMake(self.view.frame.size.width - recordController.view.frame.size.width - 20, self.view.frame.size.height - recordController.view.frame.size.height, recordController.view.frame.size.width, recordController.view.frame.size.height);
}


- (void) initRecorder
{
    if (!recordController) {
        recordController = [[RecordController alloc] initWithNibName:nil bundle:nil];
        recordController.parentController = self;
        [self.view addSubview:recordController.view];
        [self.view bringSubviewToFront:recordController.view];
        recordController.view.frame = [self getOffRect];
    }
}

- (void) handleRecordTap
{
    [self initRecorder];
    
    [recordController recordButtonPressed];
}

- (void) handleRecordAccept
{
    [recordController acceptRecording:nil];
}

- (void) handleRedo
{
    NSLog(@"[generic web view] - handle redo - ");
    [recordController reRecordButtonPressed];
    
    [self performSelector:@selector(handleRecordTap) withObject:nil afterDelay:.5];
}

- (void) doRecord
{
    [self initRecorder];
    
    if (recordController.view.frame.origin.y == [self getOnRect].origin.y ) {
        return;
    }
    
    //clear recorder
    if (!recordController.reRecordButton.hidden) {
        [recordController reRecordButtonPressed];
    }
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.30];
    
    recordController.view.frame = [self getOnRect];
    
    [UIView commitAnimations];
}

- (NSString *) getTextFromURL: (NSString *) urlString
{
    NSString *attr = @"text=";
    NSRange textAttrRange = [urlString rangeOfString:attr];
    if (textAttrRange.location == NSNotFound) {
        NSLog(@"get text from url - could not find 'text=' in the url string; returning nil");
        return nil;
    }
    
    int startIndex = textAttrRange.location + textAttrRange.length;
    NSString *textString = [urlString substringFromIndex:startIndex];
    
    NSLog(@"string before percent escape: %@", textString);
    
    NSString * fixedString = [textString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (!fixedString) {
        fixedString = [textString stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        fixedString = [fixedString stringByReplacingOccurrencesOfString:@"%92" withString:@"'"];        
        fixedString = [fixedString stringByReplacingOccurrencesOfString:@"%22" withString:@"\""];                
    }
    
    NSLog(@"string after percent escape: %@", fixedString);
    
    return fixedString;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"[generic web view] - should start load with request - request url: %@", request.URL); 
            
    if ([[request.URL absoluteString] rangeOfString:RERECORD_TRIGGER].location != NSNotFound) {
        NSLog(@"[generic web view] - handle redo trigger recognized");
        [self handleRedo];
        return NO;
    }
    
    if ([[request.URL absoluteString] rangeOfString:ACCEPT_TRIGGER].location != NSNotFound) {
        [self handleRecordAccept];
        return NO;
    }
    
    if ([[request.URL absoluteString] hasSuffix:recSuffix]) {
        NSLog(@"record command recognized");
        [self handleRecordTap];
        //[self doRecord];
        return NO;
    }
    
    if ([[request.URL absoluteString] rangeOfString:TEXT_TO_SPEECH_SUFFIX].location != NSNotFound) {

        NSString *textToSpeak = [self getTextFromURL:[request.URL absoluteString]];
        
        if ([[request.URL absoluteString] rangeOfString:HIDE_RECORD_TRIGGER].location != NSNotFound) {
            [self hideRecordPane];
        }        
        
        NSLog(@"text to speech triggered; text: %@", textToSpeak);
        if (!textToSpeak) {
            return NO;
        }
        
        //BOOL headsetIn = [self isHeadsetPluggedIn];
        //NSLog(@"headset in? %d", headsetIn);
        
        //[self.fliteController say:textToSpeak withVoice:@"cmu_us_slt"];
        //[self.fliteController say:textToSpeak withVoice:@"cmu_us_awb"];
        //[self.fliteController say:textToSpeak withVoice:@"cmu_us_kal16"];
        [self.fliteController say:textToSpeak withVoice:@"cmu_us_rms"];
        //[self.fliteController say:textToSpeak withVoice:@"cmu_us_rms8k"];
        
        return NO;
    }
      
    if ([[request.URL absoluteString] rangeOfString:HIDE_RECORD_TRIGGER].location != NSNotFound) {
        [self hideRecordPane];
        return NO;
    }

    return YES;
}

- (void) viewDidLoad {
    NSLog(@"[generic web view] - view did load - webview is : %@", self.webView);

    [self.openEarsEventsObserver setDelegate:self];
    
    [self reload];
    
//    UIBarButtonItem *backButton = [UIUtil makeBarStandardBackButtonItem:self :@selector(goBack)];
//    self.navigationItem.leftBarButtonItem = backButton;
//    [backButton release];
}

- (void) uploadSucceededWithResponse:(NSString *) responseString
{
    NSLog(@"[generic web view] - upload succeeed with response: %@", responseString);
    [self handleRedo];
    
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

- (void) audioRouteDidChangeToRoute:(NSString *)newRoute; // The audio route changed.
{
    NSLog(@"[generic web view] - audio route did change - route: %@", newRoute);
    
    NSRange headphoneRange = [newRoute rangeOfString : @"Head"];
    
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    if (!musicPlayer) {
        musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    }

    if (headphoneRange.location != NSNotFound) {
        musicPlayer.volume = .5;
    }
    else {
        if (musicPlayer.volume < 1) {
            musicPlayer.volume = 1;
        }
    }

}

- (void) fliteDidStartSpeaking
{
    NSLog(@"[generic web view] - flite did start speaking");
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"audioReady();"];

}

- (void) fliteDidFinishSpeaking
{
    
}

- (void)dealloc {
    [fliteController release];
    [openEarsEventsObserver release];
    [super dealloc];
}

@end
