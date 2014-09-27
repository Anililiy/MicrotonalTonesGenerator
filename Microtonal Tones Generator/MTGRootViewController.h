//
//  MTGRootViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 27/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGFirstLoginViewController.h"

@protocol MTGFirstLoginViewProtocol <NSObject>

- (void)dismissAndLoginView;

@end

@interface MTGRootViewController : UIViewController

@property (nonatomic, weak) id <MTGFirstLoginViewProtocol> delegate;
@property (nonatomic, retain) MTGFirstLoginViewController *loginView;

@end
