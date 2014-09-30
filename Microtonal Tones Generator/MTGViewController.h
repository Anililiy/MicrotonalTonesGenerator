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


@interface MTGViewController : UIViewController{
    PdDispatcher *dispatcher;
    void *patch;
    MTGKey *key;
    NSMutableArray *keyboard;
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *savedStatesSlideButton;
@property float frequency;
@property int numberOfSplits;
@property float hueOfKeys;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property BOOL creationState;
@property int buttonPressedTimes;

@property (nonatomic, strong) id numberOfSplitsRequest;
@property (nonatomic, strong) id frquencyRequest;

@end
