//
//  FormatUtil.h
//  Echo
//
//  Created by trifon on 12/1/10.
//  Copyright 2010 Electric Literature. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatUtil : NSObject {

}

+ (NSString*) formatDuration:(long) duration;
+ (NSString*) httpPrefixed:(NSString*)str;

//Returns a string representation of the passed array in the format
//<element1><separator><element2><separator>...
//(with no [] brackets at the start and end)
+ (NSString*) getArrayStringRepresentation:(NSArray*)array separator:(NSString*)separator;
/*
 * Generates a ShareKit item from a passed audio item
 */
+ (NSArray *) getChronologicallySortedArray:(NSArray *) unsorted;
+ (NSString *) formatPlaybackTime:(double) progress duration:(double) duration;
@end
