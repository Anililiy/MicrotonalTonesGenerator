//
//  MTGColoursViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 21/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGColourWheel.h"

@class MTGColoursViewController;

@protocol MTGColoursViewControllerDelegate<NSObject>

- (void)colorPopoverControllerDidSelectColor:(UIColor*)colour;

@end

@interface MTGColoursViewController : UIViewController <MTGColourWheelDelegate>
{
    MTGColourWheel* _colorWheel;
    UISlider* _brightnessSlider;
    UIView* _wellView;
}


@property NSMutableArray *colours;
@property (nonatomic, strong) NSArray *colorCollection;
@property UIView* wellView;

@property (nonatomic, strong) NSArray* colorButtons;

@property (nonatomic, weak) id <MTGColoursViewControllerDelegate> delegate;

@property float colourChosen;

@end
