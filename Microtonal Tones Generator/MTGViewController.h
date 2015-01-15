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
    PdDispatcher *dispatcher;
    void *patch;
    NSMutableArray *keyboard, *scales, *pressedKeys, *savedStates;
    NSInteger numberOfSplits;
    float hueOfKeys, saturOfKeys, brightOfKey, frequency, freqInitial;
    BOOL creationState, sessionIsSaved, menuCalled;
    MTGSavedScale* currentScale;
    NSInteger scaleNumber, octaveNumber;
}

@property (strong, nonatomic)   IBOutlet UINavigationItem *scaleNavigationItem;
@property (weak, nonatomic)     IBOutlet UIBarButtonItem  *sidebarButton;
@property (weak, nonatomic)     IBOutlet UIBarButtonItem  *savedStatesSlideButton;
@property (strong, nonatomic)   IBOutlet UIBarButtonItem  *saveButton;
@property (strong, nonatomic)   IBOutlet UIBarButtonItem  *playNextStateButton;
@property (strong, nonatomic)   IBOutlet UIBarButtonItem  *playPreviousStateButton;
@property (strong, nonatomic)   IBOutlet UILabel          *frequencyLabel;

@property(nonatomic) NSInteger indexOfFileLoading, numberOfSavedScales, indexOfStateChosen;
@property(nonatomic) BOOL loading, stateSelected;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *startButtonItem;
@property (strong, nonatomic) IBOutlet UIToolbar *changeOctave;

@property (strong, nonatomic) IBOutlet UIView *ViewCover;
@property (strong, nonatomic) IBOutlet UIView *ViewCover2;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *downTheOctave;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *upTheOctave;
@property (strong, nonatomic) IBOutlet UIToolbar *mainToolbar;


- (IBAction)rightArrowPressed:(id)sender;
- (IBAction)leftArrowPressed:(id)sender;
- (IBAction)saveState:(id)sender;

- (IBAction)polifoniaStart:(id)sender;
- (IBAction)playNextStateAction:(id)sender;
- (IBAction)playPreviousStateAction:(id)sender;


@end
