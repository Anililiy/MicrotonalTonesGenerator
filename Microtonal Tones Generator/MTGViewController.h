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
    MTGSavedScale *scale, *scaleLoading;
    NSMutableArray *keyboard, *scales;
    int numberOfSplits;
    float hueOfKeys, saturOfKeys, brightOfKey;
    BOOL creationState, saved;
    int buttonPressedTimes;
    float frequency;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *savedStatesSlideButton;

@property(nonatomic) NSInteger indexOfFileLoading;
@property(nonatomic) BOOL loading;

@property (weak, nonatomic) IBOutlet UIButton *startButton;


- (IBAction)rightArrowPressed:(id)sender;
- (IBAction)leftArrowPressed:(id)sender;
- (IBAction)saveScale:(id)sender;

@end
