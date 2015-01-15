//
//  MTGKeyObject.m
//  Microtonal Tones Generator
//
//  Created by Anna on 09/11/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGKeyObject.h"

@implementation MTGKeyObject

@synthesize index, keyFrequency;

// NSCoding is a protcol that you can implement on your data classes to support encoding and decoding your data into a data buffer, which can then be persisted to disk.

//convert data into coded format which can be saved in NSUserDefaults
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:index       forKey:@"indexOfKey" ];
    [encoder encodeFloat:keyFrequency  forKey:@"freqOfKey"  ];
}

//convert encoded data into the format which can be used in application
- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        index         = [decoder decodeIntegerForKey:   @"indexOfKey" ];
        keyFrequency  = [decoder decodeFloatForKey:     @"freqOfKey"  ];

    }
    return self;
}

@end
