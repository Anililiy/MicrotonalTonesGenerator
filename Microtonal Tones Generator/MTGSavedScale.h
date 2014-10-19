//
//  MTGSavedScale.h
//  Microtonal Tones Generator
//
//  Created by Anna on 19/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTGSavedScale : NSObject{
    int numberOfSplits;
    float initialFrequency;
    UIColor *keyColor;
}
-(void)saveSplits:(int)sp;
-(void)saveFrequency:(float)f;
-(void)saveColour:(UIColor*)c;
@end
