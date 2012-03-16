//
//  GenericWebView.h
//  Echo
//  Intended to show the Terms of Service in a separate view (instead of the shared application).
//
//  Created by boyanl on 12/7/10.
//  Copyright 2010 Electric Literature. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GenericWebView : UIViewController <UIWebViewDelegate> {
	NSString *URL;
}

@property (nonatomic, retain) NSString *URL;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (id) initWithPageURL:(NSString *) url;
- (void) reload;

@end
