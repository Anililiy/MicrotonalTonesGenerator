//
//  MTGAppDelegate.m
//  Microtonal Tones Generator
//
//  Created by Anna on 13/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGAppDelegate.h"
#import "MTGViewController.h"

@implementation MTGAppDelegate

@synthesize audioController = _audioController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PdBase setDelegate:self];
    [self initAudio];
    
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Frangelica" size:18.0]];
    [[UILabel appearanceWhenContainedIn:[UIButton class], nil] setFont:[UIFont fontWithName:@"Frangelica" size:14.0]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"Frangelica" size:20.0f]}];
    
    NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"Frangelica" size:15.0]};

    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Store the data
    [defaults setInteger:   12  forKey:@"deaultNumberOfSplits"  ];
    [defaults setFloat:     440 forKey:@"defaultFrequency"      ];
    [defaults setFloat:     0.7 forKey:@"initThemeHue"          ];
    [defaults setFloat:     1   forKey:@"initThemeSat"          ];
    [defaults setFloat:     1   forKey:@"initThemeBrg"          ];
    [defaults setInteger:   0   forKey:@"initScale"             ];
    [defaults setInteger:   0   forKey:@"initScaleIndex"        ];
    [defaults setInteger:   0   forKey:@"initNoOfScalesCreated" ];
    
    [defaults synchronize];
    
    NSLog(@"Data saved");

    self.authenticated = [defaults boolForKey:@"firstRun"];
    //NSLog(@"Logged in: %hhi", self.authenticated);
    
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
