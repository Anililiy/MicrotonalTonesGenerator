//
//  MTGViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 13/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGViewController.h"

@interface MTGViewController ()

@end

@implementation MTGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatcher = [[PdDispatcher alloc]init];
    [PdBase setDelegate:dispatcher];
    patch = [PdBase openFile:@"tuner.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
        // Gracefully handle failure...
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [PdBase closeFile:patch];
    [PdBase setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button call back

-(void)playNote:(int)n{
    [PdBase sendFloat:n toReceiver:@"midinote"];
    [PdBase sendBangToReceiver:@"trigger"];
}

- (IBAction)playE:(id)sender {
    [self playNote:40];
}

- (IBAction)playA:(id)sender {
    [self playNote:45];
}

- (IBAction)playD:(id)sender {
    [self playNote:50];
}

- (IBAction)playG:(id)sender {
    [self playNote:55];
}

- (IBAction)playB:(id)sender {
    [self playNote:59];
}

- (IBAction)playE2:(id)sender {
    [self playNote:64];
}

@end
