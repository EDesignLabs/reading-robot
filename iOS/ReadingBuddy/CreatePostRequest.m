//
//  CreatePostRequest.m
//  Backlight
//
//  Created by Benjamin Jackson on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CreatePostRequest.h"
#import "ASIFormDataRequest.h"

@implementation CreatePostRequest

- (id)initWithMediaType:(kMediaType)type 
      subType:(int)subType 
      title:(NSString *)title 
      description:(NSString *)description 
      tags:(NSString *)tags
{
  if ((self = [super init])) {
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:CREATE_POST_URL]];
    [(ASIFormDataRequest *)request setPostValue:[NSNumber numberWithInt:type] forKey:@"type"];
    [(ASIFormDataRequest *)request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBSessionKey"] forKey:@"__s"];
    [(ASIFormDataRequest *)request setPostValue:@"1" forKey:@"theme_id"];
    [(ASIFormDataRequest *)request setPostValue:[NSNumber numberWithInt:subType] forKey:@"subtype"];
    [(ASIFormDataRequest *)request setPostValue:[title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"title"];
    [(ASIFormDataRequest *)request setPostValue:[description stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"text"];
    [(ASIFormDataRequest *)request setPostValue:[tags stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
      forKey:@"_inspiration_pieces"];
    [(ASIFormDataRequest *)request setPostValue:@"1" forKey:@"_terms"];
    [(ASIFormDataRequest *)request setDelegate:self];
    [(ASIFormDataRequest *)request setDidFinishSelector:@selector(requestComplete:)];
    [(ASIFormDataRequest *)request setDidFailSelector:@selector(requestFailed:)];
  }
  return self;
}

- (void)setImageData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType
{
  [(ASIFormDataRequest *)request setPostValue:[[ASIHTTPRequest base64forData:data] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"img_filedata"];
  [(ASIFormDataRequest *)request setPostValue:contentType forKey:@"img_mimetype"];
}

- (void)setAudioData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType
{
    //mimetype should be: audio/mpeg
    [(ASIFormDataRequest *)request setPostValue:[[ASIHTTPRequest base64forData:data] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"uploadedfile"];
    [(ASIFormDataRequest *)request setPostValue:contentType forKey:@"type"];
}


- (void)setAudioDataWithPath:(NSString *)filePath withFileName:(NSString *)fileName andContentType:(NSString *)contentType
{
    //mimetype should be: audio/mpeg
    [(ASIFormDataRequest *)request setFile:filePath forKey:@"uploadedfile"];
    [(ASIFormDataRequest *)request setPostValue:contentType forKey:@"type"];
}


- (void)setBodyText:(NSString *)value
{
  [(ASIFormDataRequest *)request setPostValue:value forKey:@"meta1"];
}

- (void)setLinkText:(NSString *)value
{
  [(ASIFormDataRequest *)request setPostValue:value forKey:@"url"];
}

- (void)requestComplete:(ASIHTTPRequest *)request
{
    NSLog(@"[create post request] - request succeeded");
    NSLog(@"%s %@", _cmd, [request responseString]);

/*    NSArray *id_components = [[request responseString] componentsSeparatedByString:@"<result>"];
  if ([id_components count] > 1) {
    [delegate createPostRequestDidSucceedWithID:[[id_components objectAtIndex:1] intValue]];
  }
  else {
    [self requestFailed:request];
  }*/
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"[create post request] - request failed");
  //[delegate createPostRequestDidFail];
}

- (NSString *)requestDescription
{
  return @"sending your post";
}

@end
