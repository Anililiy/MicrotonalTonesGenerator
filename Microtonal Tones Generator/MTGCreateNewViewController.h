//
//  MTGCreateNewViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 15/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGColoursViewController.h"

@interface MTGCreateNewViewController : UIViewController<UIPopoverControllerDelegate, MTGColoursViewControllerDelegate>

@property    IBOutletCollection(UIButton) NSArray *freqButtons;
@property   IBOutlet UILabel *frequencyLabel;
@property    IBOutlet UISlider *freqInputSlider;
    
@property   IBOutlet UILabel *splitLabel;
@property  IBOutlet UISlider *splitSlider;
    
@property  IBOutlet UIButton *chooseTheme;
   
@property   NSString* chosenFrequency;
@property   CGFloat frequency;
@property  NSInteger split;
@property  CGFloat colourHue;
@property  CGFloat colourSat;
@property CGFloat colourBrg;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic,retain) UIPopoverController *popoverController;
@property (strong, nonatomic) IBOutlet UIButton *colourButton;

- (IBAction)createIt:(id)sender;
- (IBAction)showColourPopup:(id)sender;
- (IBAction)splitInputChanged:(UISlider *)slider;
- (IBAction)frequencyInputChanged:(UISlider *)slider;

@end
