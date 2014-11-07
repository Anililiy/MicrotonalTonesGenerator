//
//  MTGCreateNewViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 15/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGCreateNewViewController.h"
#import "SWRevealViewController.h"
#import "MTGColourButton.h"

@interface MTGCreateNewViewController ()

@property NSArray *colorCollection;
@property (nonatomic, strong) NSArray* colorButtons;

@end

@implementation MTGCreateNewViewController
@synthesize popoverController, colorCollection;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];

    // init
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    split = [defaults integerForKey:@"deaultNumberOfSplits"];
    frequency = [defaults floatForKey:@"defaultFrequency"];
    colourHue = [defaults floatForKey:@"initThemeHue"];
    colourSat = [defaults floatForKey:@"initThemeSat"];
    colourBrg = [defaults floatForKey:@"initThemeBrg"];
    
    splitLabel.text = [NSString stringWithFormat:@"%li", (long)split];
    frequencyLabel.text = [NSString stringWithFormat:@"%4.0f Hz", frequency];
    chooseTheme.backgroundColor = [UIColor colorWithHue:colourHue saturation:colourSat brightness:colourBrg alpha:1.0];
    //chooseTheme.tintColor = [UIColor colorWithHue:colourHue saturation:colourSat brightness:colourBrg alpha:1.0];
    [self createColorsArray];
    [self setupColorButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)createIt:(id)sender {

    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:   split       forKey:@"numberOfSplits"   ];
    [defaults setFloat:     frequency   forKey:@"frequency"        ];
    [defaults setFloat:     colourHue   forKey:@"themeHue"         ];
    [defaults setFloat:     colourSat   forKey:@"themeSat"         ];
    [defaults setFloat:     colourBrg   forKey:@"themeBrg"         ];
    [defaults setBool:      false       forKey:@"saved"            ];
    
    [defaults synchronize];
    
    NSLog(@"Data saved");

}

- (IBAction)showColourPopup:(id)sender {
    
    MTGColoursViewController *newViewController = [[MTGColoursViewController alloc] initWithNibName:@"MTGColoursViewController" bundle:nil];
    
    newViewController.delegate = self;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:newViewController];
    popoverController.popoverContentSize = CGSizeMake(225.0, 100.0);
    [popoverController presentPopoverFromRect:[(UIButton *)sender frame]
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];

}

-(void)colorPopoverControllerDidSelectColor:(UIColor*) colour{
    
    chooseTheme.backgroundColor = colour;
    [self.view setNeedsDisplay];
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;
    [self setColor:colour];

}

- (IBAction)chooseFreq:(UIButton*)aButton {
    NSString *buttonName = [aButton titleForState:UIControlStateNormal];
    
    for (UIButton* button in freqButtons){
        if (button == aButton) button.selected = true;
        else button.selected = false;
    }
    if (chosenFrequency != buttonName) {
        chosenFrequency = buttonName;
        NSLog(@"Frequency selected: %@", chosenFrequency);
        frequency = [chosenFrequency floatValue];
    }
}

-(void)setupColorButtons{
    int maxNCol = 10;
    
    if (nil == self.colorButtons)
    {
        NSMutableArray* newColorButtons = [NSMutableArray arrayWithCapacity:maxNCol];
        int colorNumber = 0;
        for (int i=0;i<maxNCol;i++){
            
            MTGColourButton *colorButton = [MTGColourButton buttonWithType:UIButtonTypeCustom];
            colorButton.frame = CGRectMake(310+i*60, 500, 50, 50);
            
            [colorButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
            
            [colorButton setSelected:NO];
            [colorButton setNeedsDisplay];
            [colorButton setBackgroundColor:[self.colorCollection objectAtIndex:colorNumber]];
            [colorButton setColour:[self.colorCollection objectAtIndex:colorNumber]];
            colorButton.tag = colorNumber;
            
            colorNumber ++;
            [newColorButtons addObject:colorButton];
            [self.view addSubview:colorButton];
        }
        self.colorButtons = [newColorButtons copy];
        
    }
    else{
        for (UIButton* colorButton in self.colorButtons)
        {
            NSInteger colorNumber = colorButton.tag;
            
            NSInteger i = colorNumber;
            colorButton.frame = CGRectMake(10+(i%4)*52, 10+(i/4)*27, 50, 25);
        }
    }
}

-(void) buttonPushed:(UIButton *)button{
    chooseTheme.backgroundColor = button.backgroundColor;
    [self setColor:button.backgroundColor];
}

- (IBAction)frequencyInputChanged:(UISlider *)slider {
    frequency = slider.value;
    frequencyLabel.text = [NSString stringWithFormat:@"%4.0f Hz", frequency];
    for (UIButton* button in freqButtons)button.selected = false;
}

- (IBAction)splitInputChanged:(UISlider *)slider{
    split = slider.value;
    splitLabel.text = [NSString stringWithFormat:@"%li", split];
}

-(void)setColor:(UIColor*)color{
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    BOOL success = [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    NSLog(@"success: %i hue: %0.2f, saturation: %0.2f, brightness: %0.2f, alpha: %0.2f", success, hue, saturation, brightness, alpha);
    colourHue = hue;
    colourSat = saturation;
    colourBrg = brightness;
}
-(void) createColorsArray{
    colorCollection = [NSArray arrayWithObjects:
                       [UIColor redColor],
                       [UIColor orangeColor],
                       [UIColor yellowColor],
                       [UIColor greenColor],
                       [UIColor cyanColor],
                       [UIColor blueColor],
                       [UIColor purpleColor],
                       [UIColor magentaColor],
                       [UIColor blackColor],
                       [UIColor brownColor],
                       nil];
}

@end
