//
//  MTGSavedScale.m
//  Microtonal Tones Generator
//
//  Created by Anna on 19/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGSavedScale.h"

@implementation MTGSavedScale
@synthesize splitsNumber,freqInitial;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:splitsNumber forKey:@"splitsNumber"];
    [encoder encodeFloat:freqInitial forKey:@"frequencyInitial"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        splitsNumber = [decoder decodeIntegerForKey:@"splitsNumber"];
        freqInitial  = [decoder decodeFloatForKey:@"frequencyInitial"];

    }
    return self;
}

@end
