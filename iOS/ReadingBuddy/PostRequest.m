//
//  PostRequest.m
//  Backlight
//
//  Created by Benjamin Jackson on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PostRequest.h"

@interface PostRequest (private)
- (NSString *)imageSourceFromNode:(NSDictionary *)imageDict;
@end

@implementation PostRequest

- (void)requestComplete:(ASIHTTPRequest *)aRequest
{
  if ([self checkForAndHandleResponseErrorForRequest:aRequest]) {
    [delegate postRequestDidFail:self];
  }
  else {
    [delegate postRequest:self didSucceedWithPosts:[self postsFromResponseData:aRequest.rawResponseData]];
  }
}

- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
  [super requestFailed:aRequest];
  [delegate postRequestDidFail:self];
}


- (NSString *)imageSourceFromNode:(NSDictionary *)imageDict
{
  for (NSDictionary *attributeDict in [imageDict objectForKey:@"nodeAttributeArray"]) {
    NSString *attributeName = [attributeDict objectForKey:@"attributeName"];
    if ([attributeName isEqualToString:@"src"]) {
      return [attributeDict objectForKey:@"nodeContent"];
    }
  }
  return nil;
}

- (NSString *)requestDescription
{
  return @"downloading posts";
}

@end
