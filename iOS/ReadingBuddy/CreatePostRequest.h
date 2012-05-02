//
//  CreatePostRequest.h
//  Backlight
//
//  Created by Benjamin Jackson on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractRequest.h"

typedef enum {
   kMediaTypeDefault,
   kMediaTypeText,
   kMediaTypeImage,
   kMediaTypeAudio,
   kMediaTypeVideo,
   kMediaTypeLink
} kMediaType;

@protocol CreatePostRequestDelegate <NSObject>
@required
-(void)createPostRequestDidSucceedWithID:(int)idNum;
-(void)createPostRequestDidFail;
@end

@interface CreatePostRequest : AbstractRequest <APIRequest> {
}
- (id)initWithMediaType:(kMediaType)type 
      subType:(int)subType 
      title:(NSString *)title 
      description:(NSString *)description 
      tags:(NSString *)tags;
- (void)setImageData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType;
- (void)setAudioData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType;
- (void)setAudioDataWithPath:(NSString *)filePath withFileName:(NSString *)fileName andContentType:(NSString *)contentType;


- (void)setBodyText:(NSString *)value;
- (void)setLinkText:(NSString *)value;
@end
