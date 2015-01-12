//
//  MTGSavedScale.h
//  Microtonal Tones Generator
//
//  Created by Anna on 19/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTGSavedState.h"

@interface MTGSavedScale : NSObject <NSCoding>{
    NSInteger splitsNumber;
    float freqInitial, hue, saturarion, brightness;
}

@property NSInteger splitsNumber, scaleNumber;
@property NSMutableArray* savedStates;
@property float freqInitial, hue, saturarion, brightness;
@property UIImage* imageOfScale;
@property NSDate *dateCreated;
@property NSDate *dateLastUpdated;

@end
