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
#import "MTGKey.h"
#import "MTGSavedScale.h"


@interface MTGViewController : UIViewController{
    PdDispatcher *dispatcher;
    void *patch;
    MTGKey *key;
    MTGSavedScale *scale;
    NSMutableArray *keyboard, *scales;
    int numberOfSplits;
    float hueOfKeys, saturOfKeys, brightOfKey;
    BOOL creationState;
    int buttonPressedTimes;
    float frequency;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *savedStatesSlideButton;


@property (weak, nonatomic) IBOutlet UIButton *startButton;

- (IBAction)rightArrowPressed:(id)sender;
- (IBAction)leftArrowPressed:(id)sender;
- (IBAction)saveScale:(id)sender;

@end
