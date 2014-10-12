//
//  MTGFirstLoginViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 21/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGFirstLoginViewController : UIViewController{
    
    IBOutlet UITextField *nameOfUser;
    IBOutlet UITextField *defaultSplitsInp;
    IBOutlet UIButton *colorSelector;
    IBOutletCollection(UIButton) NSArray *defFreqInp;
    IBOutlet UILabel *errorSplit;
    BOOL freqInput;
    BOOL splitInput;
    NSString* chosenFrequency;
}

@property (nonatomic,retain) UIPopoverController *popoverController;

- (IBAction)save:(id)sender;
- (IBAction)validateInput:(id)sender;
- (IBAction)colorSelection:(id)sender;

@end
