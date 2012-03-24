//
//  AbstractRequest.m
//  Backlight
//
//  Created by Benjamin Jackson on 5/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AbstractRequest.h"

@implementation AbstractRequest

@synthesize delegate;

- (id)initWithURL:(NSURL *)aURL
{
  if ((self = [super init])) {
    request = [ASIHTTPRequest requestWithURL:aURL];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestComplete:)];
    [request setDidFailSelector:@selector(requestFailed:)];
  }
  return self;
}

- (void)start
{
  [request startAsynchronous];
}

- (void)requestComplete:(ASIHTTPRequest *)aRequest
{
  NSLog(@"%s %@", _cmd, aRequest.responseString);
}

- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
  NSString *message = [NSString stringWithFormat:@"An error occurred while %@: %@.", 
    [self requestDescription], [[aRequest error] localizedDescription]];
  [self showAlertWithTitle:@"Load Error" message:message];
}

- (BOOL)checkForAndHandleResponseErrorForRequest:(ASIHTTPRequest *)aRequest
{
  if ([aRequest.responseString isEqualToString:@""] || [aRequest responseStatusCode] != 200) {
    if ([aRequest responseStatusCode] != 200) {
      NSString *message = [NSString stringWithFormat:@"The server returned a %d error while downloading posts.", [aRequest responseStatusCode]];
      [self showAlertWithTitle:@"Server Error" message:message];
    } else {
      [self showAlertWithTitle:@"Server Error" message:@"An unknown error occurred while downloading posts."];
    }
    return YES;
  }
  return NO;
}

- (NSString *)contentForNode:(NSDictionary *)nodeDict
{
  if ([nodeDict objectForKey:@"nodeContent"]) {
    return [nodeDict objectForKey:@"nodeContent"];
  }
  if ([nodeDict objectForKey:@"nodeChildArray"]) {
    return [[[nodeDict objectForKey:@"nodeChildArray"] objectAtIndex:0] objectForKey:@"nodeContent"];
  }
  return nil;
}

- (NSString *)requestDescription
{
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

#pragma mark -
#pragma mark Alert methods

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
  UIAlertView *alert = [[[UIAlertView alloc] init] autorelease];
  alert.title = title;
  alert.message = message;
  [alert addButtonWithTitle:@"Ok"];
  [alert show];
}

@end
