//
//  MTGAppDelegate.h
//  Microtonal Tones Generator
//
//  Created by Anna on 13/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdAudioController.h"

@class MTGViewController;
@interface MTGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MTGViewController *viewController;

@property (strong,nonatomic,readonly) PdAudioController *audioController;
@end
