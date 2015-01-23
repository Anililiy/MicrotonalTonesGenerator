//
//  MTGViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 13/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PdDispatcher.h"
#import "SWRevealViewController.h"

#import "MTGSavedScale.h"
#import "MTGKeyObject.h"
#import "MTGKeyButton.h"

@interface MTGViewController : UIViewController{
    PdDispatcher *dispatcher /** publisher-subscriber (pub/sub) pattern for routing messages from Pd*/;
    void *patch/** pd code inserted in iOS*/;
    int dollarZero /** pointer to pd patch */;
    NSMutableArray  *patches /** array of pd codes */,
                    *keyboard  /** array containig all keys in the view */,
                    *pressedKeys /** array of keys which were pressed */,
                    *savedStates /** array of saved states */;
    NSInteger numberOfSplits /** number of splits in session */;
    
    float  hueOfKeys /** hue of keys */,
           saturOfKeys /** saturation of keys */,
           brightOfKey /** brightness of keys */,
           frequency /** initial frequency chosen by user */;
    BOOL   creationState /** boolean value which shows if polyphony is active */,
           sessionIsSaved /** boolean value which shows if session is saved */,
           menuCalled /** boolean value which shows if either of menus was called */;
    MTGSavedScale* currentScale /** current session holding values */;
}

@property (strong, nonatomic)   IBOutlet UIToolbar *changeOctave /** toolbar that allows to change an octave, while session is not saved */;
@property (strong, nonatomic)   IBOutlet UIToolbar *mainToolbar /** main toolbar containing buttons */;

@property (strong, nonatomic)   IBOutlet UIBarButtonItem  *saveButton /** button that saves session/state */;
@property (strong, nonatomic)   IBOutlet UIBarButtonItem  *startButtonItem /** button that calls for polyphony state to be set/stopped*/;
@property (strong, nonatomic)   IBOutlet UIBarButtonItem  *playNextStateButton /** button that calls for next saved state when pressed, if such state exists */;
@property (strong, nonatomic)   IBOutlet UIBarButtonItem  *playPreviousStateButton /** button that calls for previous saved state when pressed, if such state exists */;
@property (strong, nonatomic)   IBOutlet UIBarButtonItem  *downTheOctave /** button that moves frequency one octave down ba-dum tss */;
@property (strong, nonatomic)   IBOutlet UIBarButtonItem  *upTheOctave /** button that moves frequency one octave up */;

@property (strong, nonatomic)   IBOutlet UILabel *frequencyLabel /** label that represents frequency */;

@property(nonatomic) NSInteger indexOfFileLoading /** index of session loading from MTGLoadTableViewController */;
@property(nonatomic) NSInteger indexOfStateChosen /** index of state   loading from MTGSavedStatesTableViewController */;

@property(nonatomic) BOOL loading /** boolean set true if session is loading from MTGLoadTableViewController*/;
@property(nonatomic) BOOL stateSelected /** boolean set true if state is loading from MTGSavedStatesTableViewController */;

@property (strong, nonatomic) IBOutlet UIView *ViewCover  /** view on the top of View Controller of a size of iPad screen that, if left menu is called, covers the view */;
@property (strong, nonatomic) IBOutlet UIView *ViewCover2 /** view on the top of View Controller of a size of iPad screen that, if left menu is called, covers the view */;


/** Move up the octave by multiplying frequency value on 2 */
- (IBAction)rightArrowPressed:(id)sender;

/** Move down the octave by dividing frequency value by 2 */
- (IBAction)leftArrowPressed:(id)sender;

/**
	Save state by archiving and updating NSUserDefaults
 */
- (IBAction)saveState:(id)sender;

/**
	perform actions that should be taken when user press startButtonItem to start polyphony state
 */
- (IBAction)polphonyStart:(id)sender;

/**
  action of playNextStateButton which removes the current saved state and opens next one in the array of savedStates
 */
- (IBAction)playNextStateAction:(id)sender;

/**
	action of playPreviousStateButton which removes the current saved state and opens previous one in the array of savedStates
 */
- (IBAction)playPreviousStateAction:(id)sender;

/**
	sends a signal to PD to create sound with specified frequency
 */
- (void)playNoteShort:(float)freqValue;
/**
	sends a signal to PD to create sound with specified frequency
	@param f frequency of the note
	@param index position of key in array
 */
- (void)playNoteLong:(float)f at:(NSInteger)index;
/**
	<#Description#>
	@param aButton <#aButton description#>
	@returns <#return value description#>
 */
- (void)buttonClicked:(UIButton*)aButton;
/**
	<#Description#>
	@param index <#index description#>
	@returns <#return value description#>
 */
- (void)createButton:(int)index;
/**
	<#Description#>
	@returns <#return value description#>
 */
- (void)clearUp;
/**
	<#Description#>
	@returns <#return value description#>
 */
- (void)representStateSeleted;

/**
	when MTGViewController is loaded values have to be assigned
 
	@returns nothing
 */
- (void)initialiseValues;
/**
    calls for SWRevealViewController to open right menu - MTGSavedStatesTableViewController
    also turns off all sound production and releasing all keys pressed
    and makes ViewCover2 visible, so it covers all view
 */
- (void)openRightMenu;
/**
    calls for SWRevealViewController to open left menu - MTGSidebarTableViewController
    also turns off all sound production and releasing all keys pressed
    makes ViewCover visible, so it covers all view
 */
- (void)openLeftMenu;
/**
    changes size of ViewCover and ViewCover2 so that they were to cover all the screen, 
    in case they were of the wrong size when app firstly loaded
 */
- (void)changeSize;

/**
	Method called after the view controller has loaded its view hierarchy into memory. 
    In this method all main initialization is performed:
 */
- (void)viewDidLoad;

/**
	function that calculates frequency of the note
    [frequency of a note] = [initial frequency]*
    2^([position in the array relative to the key with initial frequency]/[number of splits])

	@param position position in the array relative to the key with initial frequency
	@param splits number of splits on chosen session
	@param f0 initial frequency
	@returns frequency of the note, key
 */
float calcFreqOfNote (NSInteger position, NSInteger splits, float f0);

/** takes screenshot of the session */
- (void)takeScreenshot;

@end
