//
//  ActivityViewController.m
//  Broadcastr
//
//  Created by mira on 4/4/11.
//  Copyright 2011 University of Sofia. All rights reserved.
//

#import "ActivityUIView.h"
#import "AlertScreenView.h"
#import "UIUtil.h"

@implementation UIView (ActivityUIView)

#define DEF_SPINNER_RADIUS	40
#define DEF_SPINNER_TAG		1717

#define DEF_ALERT_SCREEN_TAG 1818

#define DEF_ACTIVITY_MESSAGE NSLocalizedString(@"Loading", @"")

static UIActivityIndicatorView *activityView;

- (void) startActivityIndicatorWithMessage:(NSString *) message
{
    CGPoint spinnerCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self startActivityIndicatorWithMessage:message withCenter:spinnerCenter];
}

- (void) startActivityIndicatorWithMessage:(NSString *) message withCenter:(CGPoint) center
{
    AlertScreenView *alertView = (AlertScreenView *) [self viewWithTag: DEF_ALERT_SCREEN_TAG];
    if (!alertView) {
        alertView = [UIUtil getObjectFromNib:@"AlertScreenView" withClassType:[AlertScreenView class]];        
        alertView.tag = DEF_ALERT_SCREEN_TAG;
        [self addSubview: alertView];
        alertView.center = center;

    }

    //make sure the activity indicator is on top
    [self bringSubviewToFront:alertView];
    alertView.hidden = NO;
    alertView.messageLabel.text = message;
}



- (BOOL) startActivityIndicator
{
	CGPoint spinnerCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
	return [self startActivityIndicator:spinnerCenter];
}

- (BOOL) startActivityIndicator:(CGPoint) spinnerCenter {
    //just use the message box for now
    [self startActivityIndicatorWithMessage:DEF_ACTIVITY_MESSAGE withCenter:spinnerCenter];
    return YES;
    
}

- (BOOL) startBasicActivityIndicator
{
	CGPoint spinnerCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
	return [self startBasicActivityIndicator:spinnerCenter];
}

- (BOOL) startBasicActivityIndicator:(CGPoint) spinnerCenter 
{
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[self viewWithTag: DEF_SPINNER_TAG];
	if (!activityView) {
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityView.hidesWhenStopped = YES;
        
		float x = MAX(spinnerCenter.x - DEF_SPINNER_RADIUS, 0);
		float y = MAX(spinnerCenter.y - DEF_SPINNER_RADIUS, 0);
		activityView.frame = CGRectMake(x, y, DEF_SPINNER_RADIUS * 2, DEF_SPINNER_RADIUS * 2);
		
		activityView.tag = DEF_SPINNER_TAG;
		[self addSubview: activityView];
		//make sure the activity indicator is on top
		[self bringSubviewToFront:activityView];
	}
	[activityView startAnimating];
	return YES;

}

- (BOOL) stopActivityIndicator {
	UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[self viewWithTag: DEF_SPINNER_TAG];
    
    AlertScreenView *alertView = (AlertScreenView *) [self viewWithTag: DEF_ALERT_SCREEN_TAG];
    
	if (!activityView && !alertView) {
		return NO;
	}
    
    if(activityView) {
        [activityView stopAnimating];
    }
    
    if (alertView) {
        alertView.hidden = YES;
    }
    
	return YES;
}


@end
