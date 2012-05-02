//
//  AppDelegate.h
//  ReadingBuddy
//
//  Created by Ilya Lyashevsky on 2/29/12.
//  Copyright (c) 2012 Ilya Lyashevsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GenericWebView;

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet GenericWebView *webController;

@end
