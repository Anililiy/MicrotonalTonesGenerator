//
//  MTGColourWheel.h
//  Microtonal Tones Generator
//
//  Created by Anna on 15/01/2015.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MTGColourWheel;

@protocol MTGColourWheelDelegate <NSObject>
@required
- (void)colorWheelDidChangeColor:(MTGColourWheel*)colorWhee;
@end

@interface MTGColourWheel : UIView {
    UIImage* _radialImage;
    float _radius;
    float _cursorRadius;
    CGPoint _touchPoint;
    float _brightness;
    bool _continuous;
    id <MTGColourWheelDelegate> delegate;
    
}

@property(nonatomic, assign)float radius;
@property(nonatomic, assign)float cursorRadius;
@property(nonatomic, assign)float brightness;
@property(nonatomic, assign)bool continuous;
@property(nonatomic, assign)id <MTGColourWheelDelegate> delegate;


- (void)updateImage;
- (UIColor*)currentColor;
- (void)setCurrentColor:(UIColor*)color;

- (void)setTouchPoint:(CGPoint)point;


@end
