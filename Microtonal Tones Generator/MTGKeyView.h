//
//  MTGKeyView.h
//  Microtonal Tones Generator
//
//  Created by Anna on 07/11/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGKeyView : UIView

@property NSInteger index;
@property float freqOfKey;
@property BOOL pressed;
@property NSInteger pathNumber;

@end
