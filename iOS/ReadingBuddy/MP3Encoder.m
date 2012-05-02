#import "MP3Encoder.h"
#import "Decoder.h"
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioFormat.h>
#import <AudioToolbox/AudioConverter.h>
#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/ExtendedAudioFile.h>
#import "lame.h"
#import <fcntl.h>
#import <stdio.h>
#import <sys/stat.h>

@implementation MP3Encoder

- (id) init {
	if((self = [super init])) {
		_gfp	= lame_init();
		NSAssert(nil != _gfp, @"Unable to allocate memory.");
	}
	return self;
}

- (oneway void) encodeToFile:(NSString *) sourceFilename:(NSString *) filename {
	
	FILE *file = nil;
	int	result;
	AudioBufferList	bufferList;
	ssize_t	bufferLen = 0;
	UInt32 bufferByteSize = 0;
	SInt64 totalFrames, framesToRead;
	UInt32 frameCount;
	unsigned long iterations = 0;
	
	@try {
		bufferList.mBuffers[0].mData = nil;
		
		[self parseSettings];
		id decoder = nil;

		decoder = [[Decoder alloc] initWithFilename:sourceFilename];
				
		_sourceBitsPerChannel = [decoder pcmFormat].mBitsPerChannel;
		totalFrames	= [decoder totalFrames];
		framesToRead = totalFrames;
		
		bufferList.mNumberBuffers = 1;
		bufferList.mBuffers[0].mData = nil;
		bufferList.mBuffers[0].mNumberChannels = [decoder pcmFormat].mChannelsPerFrame;
		
		bufferLen = 1024;

		switch([decoder pcmFormat].mBitsPerChannel) {
		
			case 8:				
			case 24:
				bufferList.mBuffers[0].mData = calloc(bufferLen, sizeof(int8_t));
				bufferList.mBuffers[0].mDataByteSize = bufferLen * sizeof(int8_t);
				break;
				
			case 16:
				bufferList.mBuffers[0].mData = calloc(bufferLen, sizeof(int16_t));
				bufferList.mBuffers[0].mDataByteSize = bufferLen * sizeof(int16_t);
				break;
				
			case 32:
				bufferList.mBuffers[0].mData = calloc(bufferLen, sizeof(int32_t));
				bufferList.mBuffers[0].mDataByteSize = bufferLen * sizeof(int32_t);
				break;
				
			default:
				@throw [NSException exceptionWithName:@"IllegalInputException" reason:@"Sample size not supported" userInfo:nil]; 
				break;				
		}
		
		bufferByteSize = bufferList.mBuffers[0].mDataByteSize;
		NSAssert(nil != bufferList.mBuffers[0].mData, @"Unable to allocate memory.");
		
		lame_set_num_channels(_gfp, [decoder pcmFormat].mChannelsPerFrame);
		lame_set_in_samplerate(_gfp, [decoder pcmFormat].mSampleRate);
		result = lame_init_params(_gfp);
		NSAssert(-1 != result, @"Unable to initialize the LAME encoder.");
		
		_out = fopen([filename fileSystemRepresentation], "w");
		NSAssert(nil != _out, @"Unable to create the output file.");
		
		for(;;) {

			bufferList.mBuffers[0].mNumberChannels = [decoder pcmFormat].mChannelsPerFrame;
			bufferList.mBuffers[0].mDataByteSize = bufferByteSize;
			frameCount = bufferList.mBuffers[0].mDataByteSize / [decoder pcmFormat].mBytesPerFrame;
			
			frameCount = [decoder readAudio:&bufferList frameCount:frameCount];
			
			if(0 == frameCount) {
				break;
			}
			
			[self encodeChunk:&bufferList frameCount:frameCount];
			++iterations;
		}
		[self finishEncode];
		[decoder release];
		result = fclose(_out);
		NSAssert(0 == result,@"Unable to close the output file.");
		_out = nil;
		
		file = fopen([filename fileSystemRepresentation], "r+");
		NSAssert(nil != file, @"Unable to open the output file.");
		
		lame_mp3_tags_fid(_gfp, file);
	}
	
	@catch(NSException *exception) {
		NSLog(@"exception while encoding the mp3!");
	}
	
	@finally {
		NSException *exception;
		
		// Close the output file if not already closed
		if(NULL != _out && EOF == fclose(_out)) {
			exception = [NSException exceptionWithName:@"IOException"
												reason:NSLocalizedStringFromTable(@"Unable to close the output file.", @"Exceptions", @"") 
											  userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:errno], 
											[NSString stringWithCString:strerror(errno) encoding:NSASCIIStringEncoding], nil] forKeys:[NSArray arrayWithObjects:@"errorCode", @"errorString", nil]]];
			NSLog(@"%@", exception);
		}
		
		// And close the other output file
		if(NULL != file && EOF == fclose(file)) {
			exception = [NSException exceptionWithName:@"IOException" 
												reason:NSLocalizedStringFromTable(@"Unable to close the output file.", @"Exceptions", @"")
											    userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:errno], 
												[NSString stringWithCString:strerror(errno) encoding:NSASCIIStringEncoding], nil] forKeys:[NSArray arrayWithObjects:@"errorCode", @"errorString", nil]]];
			NSLog(@"%@", exception);
		}		
		
		free(bufferList.mBuffers[0].mData);
	}
}

- (NSString *) settingsString {
	NSString *bitrateString;
	NSString *qualityString;
	
	switch(lame_get_VBR(_gfp)) {
		case vbr_mt:
		case vbr_rh:
		case vbr_mtrh:
			bitrateString = [NSString stringWithFormat:@"VBR(q=%i)", lame_get_VBR_q(_gfp)];
			break;
		case vbr_abr:
			bitrateString = [NSString stringWithFormat:@"average %d kbps", lame_get_VBR_mean_bitrate_kbps(_gfp)];
			break;
		default:
			bitrateString = [NSString stringWithFormat:@"%3d kbps", lame_get_brate(_gfp)];
			break;
	}
		
	qualityString = [NSString stringWithFormat:@"qval=%i", lame_get_quality(_gfp)];
	
	return [NSString stringWithFormat:@"LAME settings: %@ %@", bitrateString, qualityString];
}

- (void) parseSettings {	
	lame_set_mode(_gfp, MONO);
	lame_set_quality(_gfp, 5);
}

- (void) encodeChunk:(const AudioBufferList *)chunk frameCount:(UInt32)frameCount;
{
	unsigned char *buffer = NULL;
	unsigned bufferLen = 0;
	
	void **channelBuffers = NULL;
	short **channelBuffers16 = NULL;
	long **channelBuffers32	= NULL;
	
	int8_t *buffer8 = NULL;
	int16_t *buffer16 = NULL;
	int32_t	*buffer32 = NULL;
	
	int8_t byteOne, byteTwo, byteThree;
	int32_t	constructedSample;
	
	int	result;
	size_t	numWritten;
	
	unsigned wideSample;
	unsigned sample, channel;
	
	@try {
		bufferLen = 1.25 * (chunk->mBuffers[0].mNumberChannels * frameCount) + 7200;
		buffer = (unsigned char *) calloc(bufferLen, sizeof(unsigned char));
		NSAssert(NULL != buffer, NSLocalizedStringFromTable(@"Unable to allocate memory.", @"Exceptions", @""));
		
		// Allocate channel buffers for sample de-interleaving
		channelBuffers = calloc(chunk->mBuffers[0].mNumberChannels, sizeof(void *));
		NSAssert(NULL != channelBuffers, NSLocalizedStringFromTable(@"Unable to allocate memory.", @"Exceptions", @""));
		
		// Initialize each channel buffer to zero
		for(channel = 0; channel < chunk->mBuffers[0].mNumberChannels; ++channel) {
			channelBuffers[channel] = NULL;
		}
		
		// Split PCM data into channels and convert to appropriate sample size for LAME
		switch(_sourceBitsPerChannel) {
			
			case 8:				
				channelBuffers16 = (short **)channelBuffers;
				
				for(channel = 0; channel < chunk->mBuffers[0].mNumberChannels; ++channel) {
					channelBuffers16[channel] = calloc(frameCount, sizeof(short));
					NSAssert(NULL != channelBuffers16[channel], NSLocalizedStringFromTable(@"Unable to allocate memory.", @"Exceptions", @""));
				}
				
				buffer8 = chunk->mBuffers[0].mData;
				for(wideSample = sample = 0; wideSample < frameCount; ++wideSample) {
					for(channel = 0; channel < chunk->mBuffers[0].mNumberChannels; ++channel, ++sample) {
						// Rescale values to short
						channelBuffers16[channel][wideSample] = (short)(((buffer8[sample] << 8) & 0xFF00) | (buffer8[sample] & 0xFF));
					}
				}
				
				result = lame_encode_buffer(_gfp, channelBuffers16[0], channelBuffers16[1], frameCount, buffer, bufferLen);
				
				break;
				
			case 16:
				channelBuffers16 = (short **)channelBuffers;
				
				for(channel = 0; channel < chunk->mBuffers[0].mNumberChannels; ++channel) {
					channelBuffers16[channel] = calloc(frameCount, sizeof(short));
					NSAssert(NULL != channelBuffers16[channel], NSLocalizedStringFromTable(@"Unable to allocate memory.", @"Exceptions", @""));
				}
				
				buffer16 = chunk->mBuffers[0].mData;
				for(wideSample = sample = 0; wideSample < frameCount; ++wideSample) {
					for(channel = 0; channel < chunk->mBuffers[0].mNumberChannels; ++channel, ++sample) {
						channelBuffers16[channel][wideSample] = (short)OSSwapBigToHostInt16(buffer16[sample]);
					}
				}
				
				result = lame_encode_buffer(_gfp, channelBuffers16[0], channelBuffers16[1], frameCount, buffer, bufferLen);
				
				break;
				
			case 24:
				channelBuffers32 = (long **)channelBuffers;
				
				for(channel = 0; channel < chunk->mBuffers[0].mNumberChannels; ++channel) {
					channelBuffers32[channel] = calloc(frameCount, sizeof(long));
					NSAssert(NULL != channelBuffers32[channel], NSLocalizedStringFromTable(@"Unable to allocate memory.", @"Exceptions", @""));
				}
				
				// Packed 24-bit data is 3 bytes, while unpacked is 24 bits in an int32_t
				buffer8 = chunk->mBuffers[0].mData;
				for(wideSample = sample = 0; wideSample < frameCount; ++wideSample) {
					for(channel = 0; channel < chunk->mBuffers[0].mNumberChannels; ++channel, ++sample) {
						// Reconstruct the original sample
						byteOne	= buffer8[sample];
						byteTwo	= buffer8[++sample];
						byteThree = buffer8[++sample];
#if __BIG_ENDIAN
						constructedSample = ((byteOne << 16) & 0xFF0000) | ((byteTwo << 8) & 0xFF00) | (byteThree & 0xFF);
#else
						constructedSample = ((byteThree << 16) & 0xFF0000) | ((byteTwo << 8) & 0xFF00) | (byteOne & 0xFF);
#endif
						
						// Convert to 32-bit sample scaling
						channelBuffers32[channel][wideSample] = (long)((constructedSample << 8) | constructedSample);
					}
				}
				
				result = lame_encode_buffer_long2(_gfp, channelBuffers32[0], channelBuffers32[1], frameCount, buffer, bufferLen);
				
				break;
				
			case 32:
				channelBuffers32 = (long **)channelBuffers;
				
				for(channel = 0; channel < chunk->mBuffers[0].mNumberChannels; ++channel) {
					channelBuffers32[channel] = calloc(frameCount, sizeof(long));
					NSAssert(NULL != channelBuffers32[channel], NSLocalizedStringFromTable(@"Unable to allocate memory.", @"Exceptions", @""));
				}
				
				buffer32 = chunk->mBuffers[0].mData;
				for(wideSample = sample = 0; wideSample < frameCount; ++wideSample) {
					for(channel = 0; channel < chunk->mBuffers[0].mNumberChannels; ++channel, ++sample) {
						channelBuffers32[channel][wideSample] = (long)OSSwapBigToHostInt32(buffer32[sample]);
					}
				}
				
				result = lame_encode_buffer_long2(_gfp, channelBuffers32[0], channelBuffers32[1], frameCount, buffer, bufferLen);
				
				break;
				
			default:
				@throw [NSException exceptionWithName:@"IllegalInputException" reason:@"Sample size not supported" userInfo:nil]; 
				break;
		}
		
		NSAssert(0 <= result, NSLocalizedStringFromTable(@"LAME encoding error.", @"Exceptions", @""));
		
		numWritten = fwrite(buffer, sizeof(unsigned char), result, _out);
		NSAssert(numWritten == result, NSLocalizedStringFromTable(@"Unable to write to the output file.", @"Exceptions", @""));
	}
	
	@finally {
		for(channel = 0; channel < chunk->mBuffers[0].mNumberChannels; ++channel) {
			free(channelBuffers[channel]);
		}
		free(channelBuffers);
		
		free(buffer);
	}
}

- (void) finishEncode {
	unsigned char	*buf;
	int	bufSize;
	
	int	result;
	size_t numWritten;
	
	@try {
		buf = NULL;
		bufSize	= 7200;
		buf	= (unsigned char *) calloc(bufSize, sizeof(unsigned char));		
		result = lame_encode_flush(_gfp, buf, bufSize);		
		numWritten = fwrite(buf, sizeof(unsigned char), result, _out);
	}
	
	@finally {
		free(buf);
	}
}

- (void) dealloc {
	lame_close(_gfp);	
	[_sourceFilename release];
	
	[super dealloc];
}

@end