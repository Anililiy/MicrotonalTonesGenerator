//
//  MTGSavedScale.h
//  Microtonal Tones Generator
//
//  Created by Anna on 19/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

// notice Scale == Session

#import <Foundation/Foundation.h>

@interface MTGSavedScale : NSObject <NSCoding>{
    NSInteger splitsNumber;
    float freqInitial, hue, saturation, brightness;
}

@property NSInteger splitsNumber /** number of splits entered by user */;
@property NSMutableArray* savedStates /** array of saved states,
                                       each saved state is holding array of keys pressed in polyfony */;
@property float freqInitial /** initial frequency chosen by user */;


/** theme of each session's keys is created using hue, saturation and brightness, therefore those 3 values are stored */
@property float hue;
@property float saturation;
@property float brightness;

@property UIImage*imageOfScale /** image of how created scale looks like */;
@property NSDate *dateCreated /** date on which the session was created */;
@property NSDate *dateUpdated /** date on which the session was last updated */;

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

@end
