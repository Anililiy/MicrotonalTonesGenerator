//
//  MTGSettingsViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 14/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"


@interface MTGSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITextField *numberOfSplitsInput;
@property NSString *chosenFrequency;

- (IBAction)sendInformation:(id)sender;

@property (nonatomic,retain) UIPopoverController *popoverController;
- (IBAction)showPopover:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *customFrequency;

@end
