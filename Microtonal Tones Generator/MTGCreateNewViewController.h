//
//  MTGCreateNewViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 15/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGColoursViewController.h"

#import "MTGKeyButton.h"

@interface MTGCreateNewViewController : UIViewController<UIPopoverControllerDelegate, MTGColoursViewControllerDelegate>

@property NSArray *colorCollection;
@property (nonatomic, strong) NSArray* colorButtons;

@property    IBOutletCollection(UIButton) NSArray *freqButtons;
@property   IBOutlet UILabel *frequencyLabel;
@property   IBOutlet UISlider *freqInputSlider;
@property   NSString* chosenFrequency;
@property   CGFloat frequency;
@property (strong, nonatomic) IBOutlet UITextField *freqTextField;

@property BOOL menuCalled, frequencyInput;

@property   IBOutlet UILabel *splitLabel;
@property  IBOutlet UISlider *splitSlider;
    
@property  IBOutlet MTGKeyButton *chooseTheme;
   
@property  NSInteger split;
@property  CGFloat colourHue;
@property  CGFloat colourSat;
@property  CGFloat colourBrg;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic,retain) UIPopoverController *popoverController;
@property (strong, nonatomic) IBOutlet UIButton *colourButton;
@property (strong, nonatomic) IBOutlet UIView *ViewCover;

- (IBAction)createIt:(id)sender;
- (IBAction)showColourPopup:(id)sender;
- (IBAction)splitInputChanged:(UISlider *)slider;
- (IBAction)frequencyInputTxtField:(id)sender;
- (IBAction)validateFreq:(id)sender;
- (IBAction)releaseFreqBts:(id)sender;

@end
