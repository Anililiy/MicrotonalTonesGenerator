//
//  MTGSavedScale.h
//  Microtonal Tones Generator
//
//  Created by Anna on 19/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTGSavedScale : NSObject <NSCoding>{
    NSInteger splitsNumber;
    float freqInitial, hue, saturarion, brightness;
    UIColor *keyColor;
}

@property NSInteger splitsNumber;
@property float freqInitial, hue, saturarion, brightness;

@end
