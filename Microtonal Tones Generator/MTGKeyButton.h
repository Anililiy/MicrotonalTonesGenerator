//
//  MTGKeyButton.h
//  Microtonal Tones Generator
//
//  Created by Anna on 09/12/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGKeyButton : UIButton

@property (nonatomic, assign) CGFloat hue;
@property (nonatomic, assign) CGFloat saturation;
@property (nonatomic, assign) CGFloat brightness;

@property UIColor *colourOfScale;

-(void)setColour:(UIColor *)colour;

@end
