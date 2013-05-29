//
//  PostRequest.h
//  Backlight
//
//  Created by Benjamin Jackson on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "AbstractRequest.h"

@class PostRequest;

@protocol PostRequestDelegate <NSObject>
@required
-(void)postRequest:(PostRequest *)request didSucceedWithPosts:(NSArray *)posts;
-(void)postRequestDidFail:(PostRequest *)request;
@end

@interface PostRequest : AbstractRequest <APIRequest> {
}
@end
