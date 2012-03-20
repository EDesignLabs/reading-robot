//
//  FormatUtil.m
//  Echo
//
//  Created by trifon on 12/1/10.
//  Copyright 2010 Electric Literature. All rights reserved.
//

#import "FormatUtil.h"

@implementation FormatUtil

+ (NSString*) formatDuration:(long) duration
{	
	int min = duration / 60;
	int sec = duration % 60;
	
	NSString* length;
	length = [NSString stringWithFormat:@"%d:%.2d", min, sec];
	
	return length;	
}


+ (NSString*) httpPrefixed:(NSString*)str {
    return (
            [str rangeOfString:@"http"].location != 0 ? [NSString stringWithFormat:@"http://%@", str] : str);
}

+ (NSString*) getArrayStringRepresentation:(NSArray*)array separator:(NSString*)separator {
    NSMutableString* result = [NSMutableString new];
    for (int i = 0; i < [array count]; ++i) {
        NSString* element_i = [[array objectAtIndex:i] description];
        [result appendString:element_i];
        if (i != [array count] - 1) {
            [result appendString:separator];
        }
    }
    
    return result;
}

+ (NSString *) formatPlaybackTime:(double) progress duration:(double) duration
{
    double time = (duration - progress);
    int mins = time / 60;
    int sec = ((int) time) % 60;
    
    return [NSString stringWithFormat:@"%d:%.2d", mins, sec];
}

NSInteger dateSort(id item1, id item2, void *context)
{
    if ([item1 respondsToSelector:@selector(dateCreated)] && [item2 respondsToSelector:@selector(dateCreated)]) {
        
        NSNumber *item1Date = [NSNumber numberWithDouble: [[item1 dateCreated] timeIntervalSince1970]];
        NSNumber *item2Date = [NSNumber numberWithDouble: [[item2 dateCreated] timeIntervalSince1970]];

        //reverse the order, since latest items come first
        return [item2Date compare:item1Date];
    }
    
    //if dateCreated isn't supported return regular alphanumeric sort
    return [[item1 title] compare:[item2 title]];
}

+ (NSArray *) getChronologicallySortedArray:(NSArray *) unsorted
{
    return [unsorted sortedArrayUsingFunction:dateSort context:NULL];
}


@end
