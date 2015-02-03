//
//  MTGHelpViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 03/02/2015.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGHelpViewController : UIViewController
@property NSString* text;
@property (strong, nonatomic) IBOutlet UITextView *helpTextView;

@end
