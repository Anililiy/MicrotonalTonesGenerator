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

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:index  forKey:@"indexOfKey"];
    [encoder encodeFloat:keyFrequency     forKey:@"freqOfKey"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        index = [decoder decodeIntegerForKey:@"indexOfKey"];
        keyFrequency  = [decoder decodeFloatForKey:@"freqOfKey"];

    }
    return self;
}

@end
