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

@protocol MTGColoursViewControllerDelegate <NSObject>

/**
	A protocol is used to declare methods and properties that are independent of any specific class.
	@param colour color chosen
 */
- (void)colorPopoverControllerDidSelectColor:(UIColor*)colour;

@end

@interface MTGColoursViewController : UIViewController <MTGColourWheelDelegate>
{
    MTGColourWheel* _colorWheel /** colour wheel */;
    UISlider* _brightnessSlider /** brightness slider */;
    UIView* _wellView /** colour chosen view */;
}
@property (nonatomic, weak) id <MTGColoursViewControllerDelegate> delegate /**  */;

/**
	Method called after the view controller has loaded its view hierarchy into memory.
    In this method all main initialization is performed:
 */
- (void)viewDidLoad;

/**
	The event handling method
 */
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;

/**
	Updates brightness of the colorWheel
 */
- (void)changeBrightness:(UISlider*)sender;

/**
	Updates wellView background colour
	@param colorWheel color wheel
*/
- (void)colorWheelDidChangeColor:(MTGColourWheel *)colorWheel;

@end
