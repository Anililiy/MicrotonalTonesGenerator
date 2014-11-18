//
//  MTGSavedScale.m
//  Microtonal Tones Generator
//
//  Created by Anna on 19/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGSavedScale.h"

@implementation MTGSavedScale
@synthesize splitsNumber, scaleNumber, freqInitial, hue, saturarion, brightness,savedStates;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:scaleNumber  forKey:@"scaleNumber"];
    [encoder encodeInteger:splitsNumber forKey:@"splitsNumber"];
    [encoder encodeObject:savedStates   forKey:@"states"];
    [encoder encodeFloat:freqInitial    forKey:@"frequencyInitial"];
    [encoder encodeFloat:hue            forKey:@"hue"];
    [encoder encodeFloat:saturarion     forKey:@"saturation"];
    [encoder encodeFloat:brightness     forKey:@"brightness"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        splitsNumber = [decoder decodeIntegerForKey:@"splitsNumber"];
        scaleNumber  = [decoder decodeIntegerForKey:@"scaleNumber"];
        freqInitial  = [decoder decodeFloatForKey:@"frequencyInitial"];
        hue          = [decoder decodeFloatForKey:@"hue"];
        saturarion   = [decoder decodeFloatForKey:@"saturation"];
        brightness   = [decoder decodeFloatForKey:@"brightness"];
        savedStates  = [decoder decodeObjectForKey:@"states"];
    }
    return self;
}

@end
