//
//  MTGAppDelegate.h
//  Microtonal Tones Generator
//
//  Created by Anna on 13/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdAudioController.h"
#import "PdBase.h"
#import <CoreData/CoreData.h>


@interface MTGAppDelegate : UIResponder <UIApplicationDelegate, PdReceiverDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic,readonly) PdAudioController *audioController;
@property (nonatomic) BOOL authenticated;

@end
