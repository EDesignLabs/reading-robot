//
//  RecordController.m
//

#import "RecordController.h"
#import "FormatUtil.h"
#import "MP3Encoder.h"
#import "CreatePostRequest.h"

static const int DefaultPostSubtypeID = 1;

@interface RecordController ()

- (void)adjustButtons:(RecordingState)state;
- (void)updateRemainingTime:(long)remaining;

@property(nonatomic, assign) RecordingState state;

@end

@implementation RecordController

static NSString * const RECORD_BUTTON_ICON = @"record_button";
static NSString * const STOP_RECORDING_BUTTON_ICON = @"record_stop";
static NSString * const PLAY_RECORDING_BUTTON_ICON = @"record_play";
static NSString * const PAUSE_RECORDING_BUTTON_ICON = @"record_pause";
static NSString * const RECORD_BUTTON_DOWN_ICON = @"record_button_down";
static NSString * const STOP_RECORDING_BUTTON_DOWN_ICON = @"record_stop_down";
static NSString * const PLAY_RECORDING_BUTTON_DOWN_ICON = @"record_play_down";
static NSString * const PAUSE_RECORDING_BUTTON_DOWN_ICON = @"record_pause_down";


static long const MAX_RECORDING_LENGTH = 180;
static long const MIN_RECORDING_LENGTH = 10;

@synthesize hintLabel, recordButton, recordingLengthButton, reRecordButton, acceptButton;
@synthesize state;
@synthesize recordedTmpFile;
@synthesize parentController;


- (RecordController *) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *)nibBundle
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundle])) {
        dispatchQueue = dispatch_queue_create("broadcastr.uploadqueue", NULL);
	}
	return self;
}

//Adjusts icons, visibility, etc of the buttons according to the passed state
- (void)adjustButtons:(RecordingState)state_ {
    NSString* recordButtonImage;
    NSString* pressedButtonImage;
    
    NSString* recordButtonTitle;
    
    switch (state_) {
        case SHOULD_START_PLAYING:
            recordButtonImage = PLAY_RECORDING_BUTTON_ICON;
            pressedButtonImage = PLAY_RECORDING_BUTTON_DOWN_ICON;
            
            recordButtonTitle = @"PLAY";
            
            reRecordButton.hidden = NO;
            acceptButton.hidden = NO;
            
            hintLabel.text = @"Record your thoughts";
            
            break;
        case SHOULD_STOP_RECORDING:
            recordButtonImage = STOP_RECORDING_BUTTON_ICON;
            pressedButtonImage = STOP_RECORDING_BUTTON_DOWN_ICON;
            
            recordButtonTitle = @"STOP";
            
            break;
        case SHOULD_PAUSE_PLAYING:
            recordButtonImage = PAUSE_RECORDING_BUTTON_ICON;
            pressedButtonImage = PAUSE_RECORDING_BUTTON_DOWN_ICON;
            
            recordButtonTitle = @"PAUSE";
            
            break;
        case SHOULD_START_RECORDING:
            recordButtonImage = RECORD_BUTTON_ICON;
            pressedButtonImage = RECORD_BUTTON_DOWN_ICON;
            
            recordButtonTitle = @"RECORD";
            
            reRecordButton.hidden = YES;
            acceptButton.hidden = YES;
            
            hintLabel.text = NSLocalizedString(@"recordStoryHint", @"");
            
            break;
        default:
            break;
    }
    
//    UIImage* normalImage = [UIImage imageNamed:recordButtonImage];
//    UIImage* pressedImage = [UIImage imageNamed:pressedButtonImage];
    
//    [recordButton setImage:normalImage forState:UIControlStateNormal];
//    [recordButton setImage:pressedImage forState:UIControlStateHighlighted];
    
    [recordButton setTitle:recordButtonTitle forState:UIControlStateNormal];
}

- (void)setState:(RecordingState)state_ {
    if (state != state_) {
        state = state_;
        [self adjustButtons:state];
    }
}

- (void)updateRemainingTime:(long)remaining {
    [recordingLengthButton setTitle:[FormatUtil formatDuration:remaining] forState:UIControlStateNormal];
}

- (void)cancelRecording {
    UIAlertView* cancelAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"oops",@"")
                                                          message:NSLocalizedString(@"recordStepCancel", @"")
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                                otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [cancelAlert show];
    [cancelAlert release];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: //Cancel -> do nothing
            break;
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}


# pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[self setupAudioSession];
	
	self.state = SHOULD_START_RECORDING;

    [self updateRemainingTime:MAX_RECORDING_LENGTH];
    
}

- (void)setupAudioSession {
	AVAudioSession * audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
	
	OSStatus propertySetError = 0;
	UInt32 defaultToSpeaker = true;
    propertySetError = 
		AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof (defaultToSpeaker), &defaultToSpeaker);
	[audioSession setActive:YES error: &error];
}	

- (void)updateRecordingProgress {
	float newValue = recorder.currentTime;
	
	recordingLength = newValue;
	long remaining = MAX_RECORDING_LENGTH - recordingLength;
	[self updateRemainingTime:remaining];
}

- (void)updatePlayingProgress {
	if (state == SHOULD_PAUSE_PLAYING) {
		long remaining = avPlayer.duration - avPlayer.currentTime;
        [self updateRemainingTime:remaining];
	}	
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	if (progressUpdateTimer != nil) {
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
	}
	
    [self updateRemainingTime:avPlayer.duration];
	
	[avPlayer stop];
	avPlayer.currentTime = 0.0;
		
	self.state = SHOULD_START_PLAYING;
}

- (IBAction)recordButtonPressed{    
	if (state == SHOULD_START_RECORDING) {
		NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
		[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
		[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
		[recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
		
		self.recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
		//NSLog(@"Using File called: %@", recordedTmpFile);
		
		[recorder release];
		recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
		[recorder setDelegate:self];
		[recorder prepareToRecord];
		
		while (![recorder recordForDuration:MAX_RECORDING_LENGTH]) { 
			[self setupAudioSession];
		}
		
		self.state = SHOULD_STOP_RECORDING;

#ifdef ADHOC
        [TestFlight passCheckpoint:TF_RECORD];
#endif
        
		progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateRecordingProgress) userInfo:nil repeats:YES];
	}	
	
	else if (state == SHOULD_STOP_RECORDING) {
		[self stopRecording];
	}
	
	else if (state == SHOULD_START_PLAYING) {
		self.state = SHOULD_PAUSE_PLAYING;		
		
		[avPlayer play];
		
		if (progressUpdateTimer == nil) {
			progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updatePlayingProgress) userInfo:nil repeats:YES];
		}
	}
	
	else if (state == SHOULD_PAUSE_PLAYING) {		
		[self pausePlaying];
	}
}

- (void)pausePlaying {
	self.state = SHOULD_START_PLAYING;
     
	[avPlayer pause];
}

- (void) showMinLengthAlert
{
    UIAlertView *minLength = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"holdUp", @"") message:[NSString stringWithFormat: NSLocalizedString(@"secMinimum", @""), (int) MIN_RECORDING_LENGTH] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [minLength show];
    [minLength release];
}

- (void)stopRecording {
	[recorder stop];
    
	if (recordingLength < MIN_RECORDING_LENGTH) {
        [self reRecordButtonPressed];
        [self showMinLengthAlert];
    }
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
	if (!flag) { //discard unsuccessful recordings
		return;
	}	
	
	if (state != SHOULD_STOP_RECORDING) {
		return;
	}
	
	self.state = SHOULD_START_PLAYING;

	if (progressUpdateTimer != nil) {
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
	}
    
	avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedTmpFile error:&error];
	avPlayer.delegate = self;
	[avPlayer prepareToPlay];
	
	
	[self updateRemainingTime:recordingLength];	
}

- (IBAction)reRecordButtonPressed {
	self.state = SHOULD_START_RECORDING;
    
	if (avPlayer != nil) {
		[avPlayer stop];
		[avPlayer release];
		avPlayer = nil;
	}

    [self updateRemainingTime:MAX_RECORDING_LENGTH];
	
	NSFileManager * fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:[recordedTmpFile path] error:&error];
	
	recordedTmpFile = nil;
	
	if (progressUpdateTimer != nil) {
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
	}
	
	[self setupAudioSession];
    
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	NSFileManager * fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:[recordedTmpFile path] error:&error];
	[recorder dealloc];
	recorder = nil;
	recordedTmpFile = nil;
	
	if (progressUpdateTimer != nil) {
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
	}
}

- (IBAction)acceptRecording:(id)sender {
    
    NSLog(@"[record controller] - accept recording");
    [self doConversion];
	//NSString *audioLocation = [self.recordedTmpFile path];
    
//    recordInfo.audioPath = audioLocation;
//    recordInfo.audioItem.duration = recordingLength * 1000;
    
}

//Utility method
-(NSString*) getMP3Location:(NSString*)rawFileLocation {
	static NSString *MP3_SUFFIX = @".mp3";
    
    return [[rawFileLocation stringByDeletingPathExtension] stringByAppendingString:MP3_SUFFIX];
}

- (void) doConversion
{
    dispatch_async(dispatchQueue, ^{
        NSLog(@"[record controller] - do conversion");
        NSString *rawFilename = [self.recordedTmpFile path];
        NSString *mp3Filename = [self getMP3Location:rawFilename];
        
        MP3Encoder *mp3Encoder = [[MP3Encoder alloc] init];
        
        
        [mp3Encoder encodeToFile:rawFilename :mp3Filename];
        
        [mp3Encoder release];
        NSLog(@"[record controller] - finished conversion"); 
        
        [self sendPostData:mp3Filename];
    });
    
}


- (void)sendPostData:(NSString *) filePath
{
    NSLog(@"[record controller] - send post data");
    createPostRequest = [[CreatePostRequest alloc] initWithMediaType:(int)[self mediaType]
                                                             subType:DefaultPostSubtypeID
                                                               title:@"audioItemTitle"
                                                         description:@"audioItemDescr"
                                                                tags:@"audioItemTags"];
    if (filePath) {
        [createPostRequest setAudioDataWithPath:filePath withFileName:[filePath lastPathComponent] andContentType:@"audio"];
    }
    createPostRequest.delegate = self;
    [createPostRequest start];
}

- (kMediaType)mediaType
{
    return kMediaTypeAudio;
}


- (void)viewWillDisappear:(BOOL)animated {
	if (state == SHOULD_PAUSE_PLAYING) {
		[self pausePlaying];
	} else if (state == SHOULD_STOP_RECORDING) {
		[self stopRecording];
	}
}

- (IBAction) hide
{
    [self.parentController hideRecordPane];
}

- (void) hideModal
{
    [self.parentController dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideModal)];
}

- (void)dealloc {
	
	[recordButton release];
	[recordingLengthButton release];
	[reRecordButton release];
	[acceptButton release];
	[recordedTmpFile release];
		
	if (progressUpdateTimer != nil) {
		[progressUpdateTimer invalidate];		
		progressUpdateTimer = nil;
	}
	
	[avPlayer release];
	
    [super dealloc];
}

@end

