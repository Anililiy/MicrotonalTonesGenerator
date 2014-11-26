//
//  MTGFirstLoginViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 21/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGColoursViewController.h"

@interface MTGFirstLoginViewController : UIViewController<UIPopoverControllerDelegate, MTGColoursViewControllerDelegate, UITextFieldDelegate>{

    IBOutlet UIButton *colorSelector;
    IBOutletCollection(UIButton) NSArray *defFreqInp;
    IBOutlet UILabel *errorSplit;
    BOOL freqInput;
    BOOL splitInput;
    NSString* chosenFrequency;
    float colourHue;
    float colourSat;
    float colourBrg;
}

@property (nonatomic,retain) UIPopoverController *popoverController;
@property IBOutlet UITextField *nameOfUser;
@property IBOutlet UITextField *defaultSplitsInp;
- (IBAction)save:(id)sender;
- (IBAction)validateInput:(id)sender;
- (IBAction)colorSelection:(id)sender;
- (IBAction)goToNext:(UITextField *)sender;

@end
