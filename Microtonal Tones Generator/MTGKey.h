//
//  MTGKey.h
//  Microtonal Tones Generator
//
//  Created by Anna on 28/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTGKey : NSObject

@property BOOL pressed;
@property float frequency;
@property int index;
@property int patchNumber;

@property (nonatomic, assign) int dollarZero;
@property NSString *reuseIdentifier;

- (id)initWithDollarZeroArg:(int)dollarZero reuseIdentifier:(NSString *)reuseIdentifier;

@end
