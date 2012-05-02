#import "Decoder.h"
#import "CircularBuffer.h"
#import <AudioToolbox/AudioFormat.h>

@implementation Decoder

- (id) initWithFilename:(NSString *)filename {
	if ((self = [super init])) {
		_pcmBuffer = [[CircularBuffer alloc] init];
		_filename = [filename retain];
		CFURLRef ref;

		CFURLCreateWithFileSystemPath(kCFAllocatorDefault,(CFStringRef) filename,
													   kCFURLPOSIXPathStyle, false);
		ref = CFURLCreateWithString(NULL, (CFStringRef) filename, NULL);		
		OSStatus result = ExtAudioFileOpenURL(ref, &_extAudioFile);
		UInt32 dataSize = sizeof(AudioStreamBasicDescription);

		result = ExtAudioFileGetProperty(_extAudioFile, kExtAudioFileProperty_FileDataFormat, &dataSize, &_sourceFormat);

		_pcmFormat = _sourceFormat;
		_pcmFormat.mFormatID = kAudioFormatLinearPCM;
		_pcmFormat.mFormatFlags	= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsPacked;
		_pcmFormat.mBitsPerChannel = (0 == _pcmFormat.mBitsPerChannel ? 16 : _pcmFormat.mBitsPerChannel);
		_pcmFormat.mBytesPerPacket = (_pcmFormat.mBitsPerChannel / 8) * _pcmFormat.mChannelsPerFrame;
		_pcmFormat.mFramesPerPacket = 1;
		_pcmFormat.mBytesPerFrame = _pcmFormat.mBytesPerPacket * _pcmFormat.mFramesPerPacket;

		result = ExtAudioFileSetProperty(_extAudioFile, kExtAudioFileProperty_ClientDataFormat, sizeof(_pcmFormat), &_pcmFormat);
	}
	return self;
}

- (SInt64) currentFrame {
	return _currentFrame;
}

- (NSString *) sourceFormatDescription {
	OSStatus result;
	UInt32 specifierSize;
	AudioStreamBasicDescription	asbd;
	NSString *fileFormat;
	
	asbd = _sourceFormat;
	specifierSize = sizeof(fileFormat);
	result = AudioFormatGetProperty(kAudioFormatProperty_FormatName, sizeof(AudioStreamBasicDescription), &asbd, &specifierSize, &fileFormat);
	
	return [fileFormat autorelease];
}

- (SInt64) totalFrames {
	OSStatus result;
	UInt32 dataSize;
	SInt64 frameCount;
	
	dataSize = sizeof(frameCount);
	result = ExtAudioFileGetProperty(_extAudioFile, kExtAudioFileProperty_FileLengthFrames, &dataSize, &frameCount);	
	return frameCount;
}

- (BOOL) supportsSeeking {
	return YES;
}

- (SInt64) seekToFrame:(SInt64)frame {
	OSStatus result = ExtAudioFileSeek(_extAudioFile, frame);
	if (noErr == result) {
		[[self pcmBuffer] reset];
		_currentFrame = frame;
	}
	
	return [self currentFrame];
}

- (void) fillPCMBuffer {
	CircularBuffer *buffer = [self pcmBuffer];
	OSStatus result;
	AudioBufferList	bufferList;
	UInt32 frameCount;
	 
	bufferList.mNumberBuffers = 1;
	bufferList.mBuffers[0].mNumberChannels = [self pcmFormat].mChannelsPerFrame;
	bufferList.mBuffers[0].mData = [buffer exposeBufferForWriting];
	bufferList.mBuffers[0].mDataByteSize = [buffer freeSpaceAvailable];
	
	frameCount = bufferList.mBuffers[0].mDataByteSize / [self pcmFormat].mBytesPerFrame;
	result = ExtAudioFileRead(_extAudioFile, &frameCount, &bufferList);	
	[buffer wroteBytes:bufferList.mBuffers[0].mDataByteSize];
}

- (NSString *) filename	{ 
	return [[_filename retain] autorelease]; 
}

- (AudioStreamBasicDescription)	pcmFormat { 
	return _pcmFormat; 
}
- (CircularBuffer *) pcmBuffer { 
	return [[_pcmBuffer retain] autorelease]; 
}

- (NSString *) pcmFormatDescription {
	OSStatus result;
	UInt32 specifierSize;
	AudioStreamBasicDescription	asbd;
	NSString *fileFormat;
	 
	asbd = _pcmFormat;
	specifierSize = sizeof(fileFormat);
	result = AudioFormatGetProperty(kAudioFormatProperty_FormatName, sizeof(AudioStreamBasicDescription), &asbd, &specifierSize, &fileFormat);	
	return [fileFormat autorelease];
}

- (UInt32) readAudio:(AudioBufferList *)bufferList frameCount:(UInt32)frameCount {
	
	UInt32 framesRead = 0;	
	UInt32 byteCount = frameCount * [self pcmFormat].mBytesPerPacket;
	UInt32 bytesRead = 0;
		
	if([[self pcmBuffer] bytesAvailable] < byteCount)
		[self fillPCMBuffer];
	
	if([[self pcmBuffer] bytesAvailable] < byteCount)
		byteCount = [[self pcmBuffer] bytesAvailable];
	
	bytesRead = [[self pcmBuffer] getData:bufferList->mBuffers[0].mData byteCount:byteCount];
	bufferList->mBuffers[0].mNumberChannels	= [self pcmFormat].mChannelsPerFrame;
	bufferList->mBuffers[0].mDataByteSize = bytesRead;
	framesRead = bytesRead / [self pcmFormat].mBytesPerFrame;
	_currentFrame += framesRead;
	
	return framesRead;
}

- (void) dealloc {
	ExtAudioFileDispose(_extAudioFile);
	[_filename release];
	[_pcmBuffer release];
	
	[super dealloc];
}

@end
