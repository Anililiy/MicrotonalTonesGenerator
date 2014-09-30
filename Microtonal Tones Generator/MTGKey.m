//
//  MTGKey.m
//  Microtonal Tones Generator
//
//  Created by Anna on 28/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGKey.h"
#import "PdBase.h"


@implementation MTGKey

@synthesize dollarZero = dollarZero_;

- (id)initWithDollarZeroArg:(int)dollarZero reuseIdentifier:(NSString *)reuseIdentifier {
    
    self.reuseIdentifier = reuseIdentifier;
    self.dollarZero = dollarZero;
    
    return self;
}

@end