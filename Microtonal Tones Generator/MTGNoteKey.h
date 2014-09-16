//
//  MTGNoteKey.h
//  Microtonal Tones Generator
//
//  Created by Anna on 14/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PdDispatcher.h"

@interface MTGNoteKey : NSObject{
    PdDispatcher *dispatcher;
    void *patch;
}


@property float frequency;
@property int   index;

@end
