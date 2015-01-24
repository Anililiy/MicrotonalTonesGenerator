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

@property NSInteger index /** key (button) position in the array created */;
@property float frequency /** frequency of the key */;

/**
	
 */
-(void)setColour:(UIColor *)colour;

/**
 
 */
-(void)drawRect:(CGRect)rect;

@end
