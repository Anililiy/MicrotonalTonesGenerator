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
    MTGSavedScale *scale, *scaleLoading;
    NSMutableArray *keyboard, *scales;
    NSInteger numberOfSplits;
    float hueOfKeys, saturOfKeys, brightOfKey, frequency;
    BOOL creationState, saved;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *savedStatesSlideButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveStateButon;

@property(nonatomic) NSInteger indexOfFileLoading;
@property(nonatomic) BOOL loading;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *startButtonItem;


- (IBAction)rightArrowPressed:(id)sender;
- (IBAction)leftArrowPressed:(id)sender;
- (IBAction)saveSession:(id)sender;
- (IBAction)saveState:(id)sender;

- (IBAction)polifoniaStart:(id)sender;


@end
