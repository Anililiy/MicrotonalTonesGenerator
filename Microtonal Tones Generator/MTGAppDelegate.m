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
    //initiating Pd base
    [PdBase setDelegate:self];
    [self initAudio];
    
    //design of application setting: sets main font to be Frangelica in every main object which contains text
    //set for labels
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Frangelica" size:18.0]];
    //set for buttons
    [[UILabel appearanceWhenContainedIn:[UIButton class], nil] setFont:[UIFont fontWithName:@"Frangelica" size:14.0]];
    //set for navigation bars
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"Frangelica" size:20.0f]}];
    //set for bar buttons
    NSDictionary *barButtonAppearanceDict  = @{NSFontAttributeName : [UIFont fontWithName:@"Frangelica" size:20.0]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];

    /**
     create inital settings of the app with NSUserDefaults class, which allows to save
     settings and properties related to application or user data.
     The objects will be saved in what is known as the iOS “defaults system”.
     The iOS defaults system is available throughout all of the code in app,
     and any data saved to the defaults system will persist through application sessions.
     This means that even if the user closes application or reboots their phone,
     the saved data will still be available the next time they open the app.
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
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
    
    [self.window makeKeyAndVisible];
   
    return YES;
}

/**
 Create and configure the audio controller on launch, and check the return value in case something
 goes wrong. Log a warning and give up if the desired configuration is not available.The configuration
 that we are requesting here, two output channels at CD sample rate with an ambient
 audio session category, is common and will probably be available.
 */
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
@end
