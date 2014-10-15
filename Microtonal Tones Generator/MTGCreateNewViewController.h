//
//  MTGCreateNewViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 15/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGCreateNewViewController : UIViewController{

    IBOutletCollection(UIButton) NSArray *freqButtons;
    IBOutlet UILabel *frequencyLabel;
    IBOutlet UISlider *freqInputSlider;
    IBOutlet UILabel *splitLabel;
    IBOutlet UISlider *splitSlider;
    IBOutlet UIButton *chooseTheme;
    BOOL splitInputed;
    BOOL frequInputed;
    NSString* chosenFrequency;
    float frequency;
    int   split;
    float colourHue;
    float colourSat;
    float colourBrg;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

- (IBAction)createIt:(id)sender;
- (IBAction)splitInputChanged:(UISlider *)slider;
- (IBAction)frequencyInputChanged:(UISlider *)slider;

@end
