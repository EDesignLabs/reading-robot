//
//  ActivityViewController.h
//  Broadcastr
//
//  Created by mira on 4/4/11.
//  Copyright 2011 University of Sofia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (ActivityUIView) 

// Maybe add position and size arguments for the activity indicator... 
- (BOOL) startActivityIndicator:(CGPoint) spinnerCenter ;
- (BOOL) startActivityIndicator;
- (BOOL) stopActivityIndicator;
- (void) startActivityIndicatorWithMessage:(NSString *) message;
- (void) startActivityIndicatorWithMessage:(NSString *) message withCenter:(CGPoint) center;
- (BOOL) startBasicActivityIndicator:(CGPoint) spinnerCenter ;
- (BOOL) startBasicActivityIndicator;

@end