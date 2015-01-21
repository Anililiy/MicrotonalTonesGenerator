//
//  MTGSavedScale.m
//  Microtonal Tones Generator
//
//  Created by Anna on 19/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGSavedScale.h"

@implementation MTGSavedScale
@synthesize splitsNumber, freqInitial, hue, saturation, brightness,savedStates, imageOfScale;
@synthesize dateCreated, dateUpdated;

//convert data into coded format which can be saved in NSUserDefaults
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:splitsNumber forKey:@"splitsNumber"    ];
    [encoder encodeObject:savedStates   forKey:@"states"          ];
    [encoder encodeFloat:freqInitial    forKey:@"frequencyInitial"];
    [encoder encodeFloat:hue            forKey:@"hue"             ];
    [encoder encodeFloat:saturation     forKey:@"saturation"      ];
    [encoder encodeFloat:brightness     forKey:@"brightness"      ];
    [encoder encodeObject:imageOfScale  forKey:@"image"           ];
    [encoder encodeObject:dateCreated   forKey:@"dateCreated"     ];
    [encoder encodeObject:dateUpdated   forKey:@"dateLastUpdated" ];

}

//convert encoded data into the format which can be used in application
- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        splitsNumber = [decoder decodeIntegerForKey:@"splitsNumber"     ];
        freqInitial  = [decoder decodeFloatForKey:  @"frequencyInitial" ];
        hue          = [decoder decodeFloatForKey:  @"hue"              ];
        saturation   = [decoder decodeFloatForKey:  @"saturation"       ];
        brightness   = [decoder decodeFloatForKey:  @"brightness"       ];
        savedStates  = [decoder decodeObjectForKey: @"states"           ];
        imageOfScale = [decoder decodeObjectForKey: @"image"            ];
        dateCreated  = [decoder decodeObjectForKey: @"dateCreated"      ];
        dateUpdated  = [decoder decodeObjectForKey: @"dateLastUpdated"  ];
    }
    return self;
}

@end
