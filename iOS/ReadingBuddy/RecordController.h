//
//  The UIViewController responsible for recording
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>


// Different states of the record button.
// Define which should be the next state of the record button after being pressed.
// The states are used to determine what should be the behaviour of the recording button
// since the recording button is used for start recording, stop recording, start playing the recorder audio
// and pause playing the recorder audio.
typedef enum
{
	// The next state should be "start recording".
	// The is the state after the view is loaded, before the record button is pressed
	// or the state after the re-record button is pressed.
	SHOULD_START_RECORDING= 0,
	
	// The next state should be "stop recording".
	// The is the state after the the record button is pressed.
	SHOULD_STOP_RECORDING,
	
	// The next state should be "start playing".
	// This is the state after the recording process is stopped or after playing of the recorderded audio is paused.
	SHOULD_START_PLAYING,

	// The next state should be "pause playing".
	// This is the state after the recorder audio is playing.
	SHOULD_PAUSE_PLAYING
} RecordingState;

@interface RecordController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate> {
	
	AVAudioRecorder* recorder;
	NSError* error;
	
	NSTimer* progressUpdateTimer;
	float recordingLength;
	NSURL* recordedTmpFile;
		
	@private
		RecordingState state;
		AVAudioPlayer* avPlayer;
}

// Invoked when record button is pressed nevertheless what is the state of the record button.
- (IBAction)recordButtonPressed;

// Invoked when re-record button is pressed/
- (IBAction)reRecordButtonPressed;

// Activated by the timer. Responsible for updating the progress bar while recording.
- (void)updateRecordingProgress;

// Activated by the timer. Responsible for updating the progress bar while playing the recorder audio.
- (void)updatePlayingProgress;

// Invoked when accept button is pressed
- (IBAction)acceptRecording: (id)sender;

// pause playing
- (void)pausePlaying;

// stop recording
- (void)stopRecording;

// setup audio session
- (void)setupAudioSession;

- (IBAction) hide;

@property (nonatomic,retain) IBOutlet UILabel* hintLabel;
@property (nonatomic,retain) IBOutlet UIButton* recordButton;
@property (nonatomic,retain) IBOutlet UIButton* recordingLengthButton;
@property (nonatomic,retain) IBOutlet UIButton* reRecordButton;
@property (nonatomic,retain) IBOutlet UIButton* acceptButton;
@property (nonatomic,retain) NSURL *recordedTmpFile;
@property (nonatomic,retain) UIViewController * parentController;

@end
