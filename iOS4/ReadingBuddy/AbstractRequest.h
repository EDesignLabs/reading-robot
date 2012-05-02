//
//  AbstractRequest.h
//  Backlight
//
//  Created by Benjamin Jackson on 5/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol APIRequest <NSObject>
@required
- (void)requestComplete:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
- (NSString *)requestDescription;
@end

@interface AbstractRequest : NSObject <APIRequest> {
  id delegate;
  ASIHTTPRequest *request;
}
@property (nonatomic, assign) id delegate;
- (id)initWithURL:(NSURL *)aURL;
- (void)start;
- (NSString *)requestDescription;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (NSString *)contentForNode:(NSDictionary *)nodeDict;
- (BOOL)checkForAndHandleResponseErrorForRequest:(ASIHTTPRequest *)request;
@end
