//
//  MTGAppDelegate.m
//  Microtonal Tones Generator
//
//  Created by Anna on 13/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGAppDelegate.h"
#import "MTGViewController.h"
//#import "SWRevealViewController.h"

@implementation MTGAppDelegate

@synthesize audioController = _audioController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PdBase setDelegate:self];
    [self initAudio];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Store the data
    [defaults setInteger:12 forKey:@"deaultNumberOfSplits"];
    [defaults setFloat:440 forKey:@"defaultFrequency"];
    [defaults setFloat:0.7 forKey:@"initThemeHue"];
    [defaults setFloat:1 forKey:@"initThemeSat"];
    [defaults setFloat:1 forKey:@"initThemeBrg"];
    [defaults setInteger:0 forKey:@"currentScale"];
    [defaults setInteger:0 forKey:@"currentScaleIndex"];
    [defaults setInteger:0 forKey:@"noOfScalesCreated"];
    
    [defaults synchronize];
    
    NSLog(@"Data saved");

    self.authenticated = [defaults boolForKey:@"firstRun"];
    NSLog(@"Logged in: %hhd", self.authenticated);
    
    [self.window makeKeyAndVisible];
   
    return YES;
}

- (void)setAudioActive:(BOOL)active {
	[self.audioController setActive:active];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    self.audioController.active = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.audioController.active = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}
-(void)initAudio
{
    _audioController = [[PdAudioController alloc] init];
    PdAudioStatus status = [self.audioController configurePlaybackWithSampleRate:44100 numberChannels:2 inputEnabled:YES mixingEnabled:NO];
    if (status == PdAudioError) {
        NSLog(@"failed to initialize audio component");
    } else if (status == PdAudioPropertyChanged) {
        NSLog(@"Audio properties changed.");
    }
}
@end
