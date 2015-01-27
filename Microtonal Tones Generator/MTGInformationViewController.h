//
//  MTGInformationViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 13/01/2015.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGInformationViewController : UIViewController

/**
	loads view
 */
- (void)viewDidLoad;

/**
	calls for SWRevealViewController to open left menu - MTGSidebarTableViewController
    also turns off all sound production and releasing all keys pressed
    makes ViewCover visible, so it covers all view
 */
-(void)openLeftMenu;

@end
