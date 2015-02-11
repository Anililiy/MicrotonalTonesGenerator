//
//  MTGKeyButton.h
//  Microtonal Tones Generator
//
//  Created by Anna on 09/12/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PdDispatcher.h"

@interface MTGKeyButton : UIButton
/*{
    PdDispatcher *dispatcher;
    void *patch;
}
*/

@property (nonatomic, assign) CGFloat hue /** hue of key */;
@property (nonatomic, assign) CGFloat saturation /** saturation of key */;
@property (nonatomic, assign) CGFloat brightness /** brightness of key */;
@property (nonatomic, assign) CGFloat alpha /** alpha of keys */;

@property NSInteger index /** key (button) position in the array created */;
@property float frequency /** frequency of the key */;

/**
	convert data into coded format which can be saved in NSUserDefaults
	@param encoder Abstract class declares the interface used by concrete subclasses to transfer objects and other values between memory and some other format
 */
- (void)encodeWithCoder:(NSCoder *)encoder;

/**
	convert encoded data into the format which can be used in application
	@param decoder Abstract class declares the interface used by concrete subclasses to transfer objects and other values between memory and some other format
	@returns self
 */
- (id)initWithCoder:(NSCoder *)decoder;

/**
	sets values to hue, saturation, brightness and alpha of the key
	@param colour colour chosen by user in MTGCreateNewViewController
 */
-(void)setColourOfTheButton:(UIColor *)colour;
/**
	sets hue of the key
	@param hue hue of the key
 */
-(void) setHue:(CGFloat)hue;
/**
	sets saturation of the key
	@param saturation saturation of the key
 */
-(void) setSaturation:(CGFloat)saturation;
/**
	sets brightness of the key
	@param brightness brightness of the key
 */
-(void) setBrightness:(CGFloat)brightness;
/**
    sets the design of the key, its appearane, using CoreGraphics and foundation libruary as well as external additional code
 */
-(void)drawRect:(CGRect)rect;
/**
	updates key view
 */
- (void)hesitateUpdate;

/**
  Tells the receiver when one or more fingers touch down in a button.
 */
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
/**
   Tells the receiver when one or more fingers associated with an event move within a view.
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

/**
   Sent to the receiver when a system event (such as a low-memory warning) cancels a touch event.
*/
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

/**
	Tells the receiver when one or more fingers are raised from a view or window.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
