//
//  MTGHelpViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 03/02/2015.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MTGHelpViewController : UIViewController
@property NSString* text /**information about different parts of the system*/;
@property (strong, nonatomic) IBOutlet UITextView *helpTextView /** text view representing the information*/;

/**
   Sets up SWRevealViewController to be called
 */
- (void)setupMenuRevelation;
/**
	calls for SWRevealViewController to open left menu - MTGSidebarTableViewController
 */
-(void)openLeftMenu;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
- (void)playMovie;

@end
