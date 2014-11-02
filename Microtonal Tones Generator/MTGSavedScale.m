//
//  MTGSavedScale.m
//  Microtonal Tones Generator
//
//  Created by Anna on 19/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGSavedScale.h"

@implementation MTGSavedScale
@synthesize splitsNumber,freqInitial, hue, saturarion, brightness;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:splitsNumber forKey:@"splitsNumber"];
    [encoder encodeFloat:freqInitial forKey:@"frequencyInitial"];
    [encoder encodeFloat:hue forKey:@"hue"];
    [encoder encodeFloat:saturarion forKey:@"saturation"];
    [encoder encodeFloat:brightness forKey:@"brightness"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        splitsNumber = [decoder decodeIntegerForKey:@"splitsNumber"];
        freqInitial  = [decoder decodeFloatForKey:@"frequencyInitial"];
        hue          = [decoder decodeFloatForKey:@"hue"];
        saturarion   = [decoder decodeFloatForKey:@"saturation"];
        brightness   = [decoder decodeFloatForKey:@"brightness"];
    }
    return self;
}

@end
