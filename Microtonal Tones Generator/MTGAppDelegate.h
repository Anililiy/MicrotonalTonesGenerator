//
//  MTGAppDelegate.h
//  Microtonal Tones Generator
//
//  Created by Anna on 13/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "PdAudioController.h"
#import "PdBase.h"

@interface MTGAppDelegate : UIResponder <UIApplicationDelegate, PdReceiverDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
	PdAudioController: A class for managing PdAudioUnit within iOS 
    by using the AVFoundation and Audio Services APIs.
    Handles phone interruptions and provides high level configuration methods
    The returned PdAudioStatus is used to indicate success, failure, or
    that parameters had to be adjusted in order to work.
 */
@property (strong,nonatomic,readonly) PdAudioController *audioController;

/**
	Boolean value which holds information if the app loads for the first time or not
 */
@property (nonatomic) BOOL authenticated;

/**
    Initiating audio components, which allow Pure Data objects to be opened
 */
-(void)initAudio;

/**
	sets Audio Controller active or not active depening on the parameter passed
	@param active boolean which is set true, when application is opened, and false when it is closed
 */
- (void)setAudioActive:(BOOL)active;

/**
	function which checks if application is exited
    sets active to be false
 */
- (void)applicationWillResignActive:(UIApplication *)application;

/**
	function which checks if application is entered
    sets active to be true
 */
- (void)applicationDidBecomeActive:(UIApplication *)application;

/**
	The UIApplicationDelegate protocol defines methods that are called by the singleton UIApplication object in response to important events in the lifetime of your app. 
    The app delegate works alongside the app object to ensure your app interacts properly with the system and with other apps.
    Specifically, the methods of the app delegate give you a chance to respond to important changes.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


@end
