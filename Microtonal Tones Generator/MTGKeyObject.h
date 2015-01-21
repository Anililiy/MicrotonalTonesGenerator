//
//  MTGKeyObject.h
//  Microtonal Tones Generator
//
//  Created by Anna on 09/11/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

//the object class which holds values for patricular key
#import <Foundation/Foundation.h>

@interface MTGKeyObject : NSObject

@property NSInteger index /** key (button) position in the array created */;
@property float keyFrequency /** frequency of the key */;

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
