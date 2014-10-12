//
//  MTGColourButton.h
//  Microtonal Tones Generator
//
//  Created by Anna on 12/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MTGColourButton : UIButton
@property UIColor *colourOfScale;
-(void)setColour:(UIColor *)colour;

@end
