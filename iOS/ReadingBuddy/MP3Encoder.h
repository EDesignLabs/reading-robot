// An encoder which reads audio data in pcm format and provides it as MP3.
//

#import "lame.h"
#import <CoreAudio/CoreAudioTypes.h>

@interface MP3Encoder : NSObject {	
	FILE *_out;
	lame_global_flags *_gfp;
	UInt32 _sourceBitsPerChannel;
	NSString *_sourceFilename;

}
- (id) init;
- (oneway void) encodeToFile:(NSString *) sourceFilename:(NSString *) filename;
- (void) encodeChunk:(const AudioBufferList *)chunk frameCount:(UInt32)frameCount;
- (void) finishEncode;
- (void) parseSettings;
@end
