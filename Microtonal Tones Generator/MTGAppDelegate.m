//
//  MTGAppDelegate.m
//  Microtonal Tones Generator
//
//  Created by Anna on 13/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGAppDelegate.h"
#import "MTGViewController.h"
#import "SWRevealViewController.h"

@implementation MTGAppDelegate

@synthesize audioController = _audioController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PdBase setDelegate:self];
    [self initAudio];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.authenticated = [defaults boolForKey:@"firstRun"];
  /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"firstRun"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SWRevealViewController *initView =  (SWRevealViewController*)[storyboard instantiateViewControllerWithIdentifier:@"initialView"];
        [initView setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.viewController presentViewController:initView animated:NO completion:nil];
         rootViewController =[[SWRevealViewController alloc]init];
        [self.window setRootViewController:rootViewController];
    }
    
    [self.window makeKeyAndVisible];
   */
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
