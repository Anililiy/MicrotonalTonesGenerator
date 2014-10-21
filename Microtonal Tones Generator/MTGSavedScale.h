//
//  MTGSavedScale.h
//  Microtonal Tones Generator
//
//  Created by Anna on 19/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTGSavedScale : NSObject <NSCoding>{
    int splitsNumber;
    float freqInitial;
    UIColor *keyColor;
}

@property int splitsNumber;
@property float freqInitial;

//+ (MTGSavedScale *) sharedGameState;
@end
