//
//  MTGFirstLoginViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 21/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGColoursViewController.h"

@interface MTGFirstLoginViewController :UIViewController<UIPopoverControllerDelegate, MTGColoursViewControllerDelegate>{
    
    IBOutletCollection(UIButton) NSArray *freqButtons;
    IBOutlet UILabel *frequencyLabel;
    IBOutlet UISlider *freqInputSlider;
    
    IBOutlet UILabel *splitLabel;
    IBOutlet UISlider *splitSlider;
    
    IBOutlet UIButton *chooseTheme;
    
    NSString* chosenFrequency;
    CGFloat frequency;
    NSInteger split;
    CGFloat colourHue;
    CGFloat colourSat;
    CGFloat colourBrg;
}


@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic,retain) UIPopoverController *popoverController;

- (IBAction)createIt:(id)sender;
- (IBAction)showColourPopup:(id)sender;
- (IBAction)splitInputChanged:(UISlider *)slider;
- (IBAction)frequencyInputChanged:(UISlider *)slider;

@end
