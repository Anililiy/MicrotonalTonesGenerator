//
//  MTGColoursViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 21/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGColourButton.h"

@class MTGColoursViewController;

@protocol MTGColoursViewControllerDelegate<NSObject>

- (void)colorPopoverControllerDidSelectColor:(UIColor*)colour;

@end

@interface MTGColoursViewController : UIViewController

@property NSMutableArray *colours;
@property (nonatomic, strong) NSArray *colorCollection;

@property (nonatomic, weak) id <MTGColoursViewControllerDelegate> delegate;

@property float colourChosen;

@end
