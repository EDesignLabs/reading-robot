//
//  ViewController.h
//  ReadingBuddy
//
//  Created by Ilya Lyashevsky on 2/29/12.
//  Copyright (c) 2012 Ilya Lyashevsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GenericWebView;

@interface ViewController : UIViewController

{
    NSString *startURL;
    GenericWebView *webView;
}

@property (nonatomic, retain) NSString *startURL;
@property (nonatomic, retain) GenericWebView *webView;

@end
