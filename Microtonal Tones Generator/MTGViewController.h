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

@interface MTGViewController : UIViewController{
    PdDispatcher *dispatcher;
    void *patch;
    NSMutableArray *keyboard, *scales, *pressedKeys, *savedStates;
    NSInteger numberOfSplits;
    float hueOfKeys, saturOfKeys, brightOfKey, frequency;
    BOOL creationState, sessionIsSaved;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *savedStatesSlideButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveStateButon;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveSessionButton;

@property(nonatomic) NSInteger indexOfFileLoading;
@property(nonatomic) BOOL loading;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *startButtonItem;


- (IBAction)rightArrowPressed:(id)sender;
- (IBAction)leftArrowPressed:(id)sender;
- (IBAction)saveSession:(id)sender;
- (IBAction)saveState:(id)sender;

- (IBAction)polifoniaStart:(id)sender;


@end
