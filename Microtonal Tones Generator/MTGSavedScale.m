//
//  MTGSavedScale.m
//  Microtonal Tones Generator
//
//  Created by Anna on 19/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGSavedScale.h"

@implementation MTGSavedScale
-(void)saveSplits:(int)sp{
    numberOfSplits = sp;
}
-(void)saveFrequency:(float)f{
    initialFrequency = f;
}
-(void)saveColour:(UIColor*)c{
    keyColor = c;
}
@end
