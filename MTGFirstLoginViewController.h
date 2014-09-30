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
    IBOutlet UITextField *defaultFrequencyInp;
    IBOutlet UITextField *defaultSplitsInp;
    IBOutlet UIButton *colorSelector;
    IBOutletCollection(UIButton) NSArray *defFreqInp;
    NSString* chosenFrequency;
}

- (IBAction)save:(id)sender;

@end
