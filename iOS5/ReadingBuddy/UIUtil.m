//
//  UIUtil.m
//  Broadcastr
//
//  Created by Ilya Lyashevsky on 7/28/11.
//  Copyright 2011 FoundLanguage. All rights reserved.
//

#import "UIUtil.h"

@implementation UIUtil

+ (id) getObjectFromNib:(NSString *) nibName withClassType:(Class) classType {
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed: nibName owner: nil options: nil];
	for(id currentObject in topLevelObjects) {
		if([currentObject isKindOfClass:classType]) {
			return currentObject;
		}
	}
	return nil;
}

@end
