//  Helper for using only one circular buffer when buffering the data stream.
//

@interface CircularBuffer : NSObject {
	uint8_t	*_buffer;
	unsigned _bufsize;
	
	uint8_t *_readPtr;
	uint8_t *_writePtr;
}

- (id) initWithSize:(unsigned)size;
- (void) reset;
- (unsigned) size;
- (void) resize:(unsigned)size;
- (unsigned) bytesAvailable;
- (unsigned) freeSpaceAvailable;
- (unsigned) putData:(const void *)data byteCount:(unsigned)byteCount;
- (unsigned) getData:(void *)buffer byteCount:(unsigned)byteCount;
- (const void *) exposeBufferForReading;
- (void) readBytes:(unsigned)byteCount;
- (void *) exposeBufferForWriting;
- (void) wroteBytes:(unsigned)byteCount;
- (void) normalizeBuffer;
- (unsigned) contiguousBytesAvailable;
- (unsigned) contiguousFreeSpaceAvailable;

@end
