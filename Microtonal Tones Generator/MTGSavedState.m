//
//  MTGSavedState.m
//  Microtonal Tones Generator
//
//  Created by Anna on 02/11/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGSavedState.h"

@implementation MTGSavedState

@synthesize indexes, frequencies;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:indexes forKey:@"indexesOfKey"];
   // [encoder encodeFloat:keyFrequency     forKey:@"freqOfKey"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        indexes = [decoder decodeObjectForKey:@"indexOfKey"];
        //keyFrequency  = [decoder decodeFloatForKey:@"freqOfKey"];
        
    }
    return self;
}
@end
