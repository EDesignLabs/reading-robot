// A decoder reads audio data in some format and provides it as PCM.
// The audio stream is converted to PCM and placed in _pcmBuffer
//

#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/ExtendedAudioFile.h>

@class CircularBuffer;

@interface Decoder : NSObject {
	NSString *_filename;
	
	AudioStreamBasicDescription	_pcmFormat;	
	CircularBuffer *_pcmBuffer;
	SInt64 _currentFrame;
	ExtAudioFileRef	_extAudioFile;
	AudioStreamBasicDescription	_sourceFormat;

}

- (UInt32) readAudio:(AudioBufferList *)bufferList frameCount:(UInt32)frameCount;
- (id) initWithFilename:(NSString *)filename;
- (SInt64) currentFrame;
- (NSString *) filename;
- (AudioStreamBasicDescription) pcmFormat;
- (SInt64) totalFrames;
- (CircularBuffer *) pcmBuffer;
- (void) fillPCMBuffer;

@end

