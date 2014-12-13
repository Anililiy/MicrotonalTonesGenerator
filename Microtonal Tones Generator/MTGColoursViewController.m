//
//  MTGColoursViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 21/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGColoursViewController.h"
#import "MTGCreateNewViewController.h"

@interface MTGColoursViewController ()
@property (nonatomic, strong) NSArray* colorButtons;

@end

@implementation MTGColoursViewController

@synthesize colours, wellView;
@synthesize colourChosen;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize size = self.view.bounds.size;
    
    CGSize wheelSize = CGSizeMake(size.width * .9, size.width * .9);
    
    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(size.width / 2 - wheelSize.width / 2,
                                                                 size.height * .01,
                                                                 wheelSize.width,
                                                                 wheelSize.height*0.9)];
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    [self.view addSubview:_colorWheel];
    
    _brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(0.1,
                                                                   size.height * .9,
                                                                   size.width,
                                                                   size.height * .1)];
    _brightnessSlider.minimumValue = 0.0;
    _brightnessSlider.maximumValue = 1.0;
    _brightnessSlider.value = 1.0;

    [_brightnessSlider addTarget:self action:@selector(changeBrightness:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_brightnessSlider];
    
    _wellView = [[UIView alloc] initWithFrame:CGRectMake(10,
                                                         10,
                                                         size.width * .2,
                                                         size.height * .1)];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                        action:@selector(handleSingleTap:)];
    [_wellView addGestureRecognizer:singleFingerTap];

    _wellView.layer.borderColor = [UIColor blackColor].CGColor;
    _wellView.layer.borderWidth = 0.5;
    [self.view addSubview:_wellView];
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
     [delegate colorPopoverControllerDidSelectColor:_colorWheel.currentColor];

    //Do stuff here...
}

- (void)changeBrightness:(UISlider*)sender
{
    [_colorWheel setBrightness:_brightnessSlider.value];
    [_colorWheel updateImage];
    [_wellView setBackgroundColor:_colorWheel.currentColor];
}

- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    MTGCreateNewViewController* newView = [[MTGCreateNewViewController alloc] init];
    newView.colourButton.backgroundColor = _colorWheel.currentColor;
    [_wellView setBackgroundColor:_colorWheel.currentColor];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
