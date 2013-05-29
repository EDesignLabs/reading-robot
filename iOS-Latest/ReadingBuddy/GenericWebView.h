//
//  GenericWebView.h
//  Echo
//  Intended to show the Terms of Service in a separate view (instead of the shared application).
//
//  Created by boyanl on 12/7/10.
//  Copyright 2010 Electric Literature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenEars/FliteController.h>
#import <OpenEars/OpenEarsEventsObserver.h>

@class RecordController;

@interface GenericWebView : UIViewController <UIWebViewDelegate, OpenEarsEventsObserverDelegate> {
	NSString *URL;
    RecordController *recordController;
    FliteController *fliteController;
    OpenEarsEventsObserver *openEarsEventsObserver;
}

@property (nonatomic, retain) NSString *URL;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) RecordController *recordController;
@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, retain) FliteController *fliteController;
@property (nonatomic, retain) OpenEarsEventsObserver *openEarsEventsObserver;

- (id) initWithPageURL:(NSString *) url;
- (void) reload;
- (IBAction) hideRecordPane;
- (void) uploadSucceededWithResponse:(NSString *) responseString;

@end
