//
//  MTGKeyButton.m
//  Microtonal Tones Generator
//
//  Created by Anna on 09/12/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGKeyButton.h"
#import "Common.h"

#import "PdFile.h"
#import "PdBase.h"

@implementation MTGKeyButton

@synthesize index, frequency;

//convert data into coded format which can be saved in NSUserDefaults
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:index    forKey:@"indexOfKey" ];
    [encoder encodeFloat:frequency  forKey:@"freqOfKey"  ];
}

//convert encoded data into the format which can be used in application
- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        index      = [decoder decodeIntegerForKey:   @"indexOfKey" ];
        frequency  = [decoder decodeFloatForKey:     @"freqOfKey"  ];
    }
    if (self = [super initWithCoder:decoder]){
        self.opaque = NO;
        self.backgroundColor= [UIColor clearColor];
        _hue = 0.5;
        _saturation = 0.5;
        _brightness = 0.5;
    }
    return self;
}

-(void)setColourOfTheButton:(UIColor *)colour{
    BOOL success = [colour getHue:&_hue saturation:&_saturation brightness:&_brightness alpha:&_alpha];
    
    NSLog(@"colour extracted and set to the button: %i",success);
    [self setNeedsDisplay];
}

-(void) setHue:(CGFloat)hue
{
    _hue = hue;
    [self setNeedsDisplay];
}

-(void) setSaturation:(CGFloat)saturation
{
    _saturation = saturation;
    [self setNeedsDisplay];
}

-(void) setBrightness:(CGFloat)brightness
{
    _brightness = brightness;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    self.titleLabel.font =[UIFont fontWithName: @"GillSans" size:30 ];

    CGFloat actualBrightness = self.brightness;
    CGFloat actualAlpha = self.alpha;

    if (self.state == UIControlStateHighlighted || self.state == UIControlStateSelected) {
        actualBrightness -= 0.20;
        actualAlpha +=1;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *  blackColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    UIColor *  highlightStart = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
    UIColor *  highlightStop = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    UIColor *  shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    
    UIColor * outerTop = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:1.0*actualBrightness alpha:actualAlpha];
    UIColor * outerBottom = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:0.80*actualBrightness alpha:actualAlpha];
    UIColor * innerStroke = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:0.80*actualBrightness alpha:actualAlpha];
    UIColor * innerTop = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:0.90*actualBrightness alpha:actualAlpha];
    UIColor * innerBottom = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:0.70*actualBrightness alpha:actualAlpha];
    
    CGFloat outerMargin = 6.0f;
    CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);
    CGMutablePathRef outerPath = createRoundedRectForRect(outerRect, 6.0);
    
    CGFloat innerMargin = 1.0f;
    CGRect innerRect = CGRectInset(outerRect, innerMargin, innerMargin);
    CGMutablePathRef innerPath = createRoundedRectForRect(innerRect, 6.0);
    
    CGFloat highlightMargin = 2.0f;
    CGRect highlightRect = CGRectInset(outerRect, highlightMargin, highlightMargin);
    CGMutablePathRef highlightPath = createRoundedRectForRect(highlightRect, 6.0);
    
    if ((self.state != UIControlStateHighlighted) && (self.state != UIControlStateSelected)) {
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, outerTop.CGColor);
        CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 6.0, shadowColor.CGColor);
        CGContextAddPath(context, outerPath);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
    }

    CGContextSaveGState(context);
    CGContextAddPath(context, outerPath);
    CGContextClip(context);
    drawGlossAndGradient(context, outerRect, outerTop.CGColor, outerBottom.CGColor);
    CGContextRestoreGState(context);

    CGContextSaveGState(context);
    CGContextAddPath(context, innerPath);
    CGContextClip(context);
    drawGlossAndGradient(context, innerRect, innerTop.CGColor, innerBottom.CGColor);
    CGContextRestoreGState(context);
    
    if (self.state != UIControlStateHighlighted) {
        CGContextSaveGState(context);
        CGContextSetLineWidth(context, 1.0);
        CGContextAddPath(context, outerPath);
        CGContextAddPath(context, highlightPath);
        CGContextEOClip(context);
        drawLinearGradient(context, outerRect, highlightStart.CGColor, highlightStop.CGColor);
        CGContextRestoreGState(context);
    }
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, blackColor.CGColor);
    CGContextAddPath(context, outerPath);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, innerStroke.CGColor);
    CGContextAddPath(context, innerPath);
    CGContextClip(context);
    CGContextAddPath(context, innerPath);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CFRelease(outerPath);
    CFRelease(innerPath);
    CFRelease(highlightPath);

}
- (void)hesitateUpdate
{
    [self setNeedsDisplay];

}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

/*
-(void)play{
    dispatcher = [[PdDispatcher alloc]init];
    
    [PdBase setDelegate:dispatcher];
    patch = [PdBase openFile:@"KeyNote.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
    }
    
    [PdBase sendFloat:frequency toReceiver:@"midinote"];
    [PdBase sendBangToReceiver:@"trigger"];
}
*/

@end
