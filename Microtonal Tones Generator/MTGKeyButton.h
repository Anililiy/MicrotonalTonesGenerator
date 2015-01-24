//
//  MTGKeyButton.h
//  Microtonal Tones Generator
//
//  Created by Anna on 09/12/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MTGKeyButton : UIButton

@property (nonatomic, assign) CGFloat hue /** hue of keys */;
@property (nonatomic, assign) CGFloat saturation /** hue of keys */;
@property (nonatomic, assign) CGFloat brightness /** hue of keys */;

@property UIColor *colourOfScale /** hue of keys */;

/**
	<#Description#>
	@param colour <#colour description#>
	@returns <#return value description#>
 */
-(void)setColour:(UIColor *)colour;

/**
	<#Description#>
	@param rect <#rect description#>
	@returns <#return value description#>
 */
-(void)drawRect:(CGRect)rect;

@end
