//
//  MTGCreateNewViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 15/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGCreateNewViewController.h"
#import "SWRevealViewController.h"

#import "MTGAppDelegate.h"

@implementation MTGCreateNewViewController
@synthesize popoverController, colorCollection, frequencyInput;
@synthesize freqButtons,frequencyLabel,splitLabel,splitSlider,chooseTheme,chosenFrequency,frequency,split,colourHue,colourSat, colourBrg, freqTextField, continueButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // init
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    split       = [defaults integerForKey:  @"deaultNumberOfSplits" ];
    frequency   = [defaults floatForKey:    @"defaultFrequency"     ];
    colourHue   = [defaults floatForKey:    @"initThemeHue"         ];
    colourSat   = [defaults floatForKey:    @"initThemeSat"         ];
    colourBrg   = [defaults floatForKey:    @"initThemeBrg"         ];
    
    splitLabel.text     = [NSString stringWithFormat:@"%li", (long)split];
    frequencyLabel.text = [NSString stringWithFormat:@"%4.0f Hz", frequency];
    
    chooseTheme.hue = colourHue;
    chooseTheme.saturation = colourSat;
    chooseTheme.brightness = colourBrg;
    
    [self createColorsArray ];
    [self setupColorButtons ];
    [self customSetup       ];

    continueButton.enabled = true;
    
    [_ViewCover setHidden:true];
        //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(openLeftMenu)];
    [_ViewCover addGestureRecognizer:singleFingerTap];
    _menuCalled = false;

}
- (void)customSetup{
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        UIBarButtonItem *barBtnMenu = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openLeftMenu)];
        barBtnMenu.tintColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
        
        self.navigationItem.leftBarButtonItem = barBtnMenu;

        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}
-(void)openLeftMenu{
    _menuCalled = !_menuCalled;
    [self.view bringSubviewToFront:_ViewCover];
    
    if (_menuCalled)[_ViewCover setHidden:false];
    else            [_ViewCover setHidden:true];
    
    SWRevealViewController *reveal = self.revealViewController;
    [reveal revealToggleAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)showColourPopup:(id)sender {
    
    MTGColoursViewController *newViewController = [[MTGColoursViewController alloc] initWithNibName:@"MTGColoursViewController" bundle:nil];
    
    newViewController.delegate = self;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:newViewController];
    popoverController.popoverContentSize = CGSizeMake(250.0, 300.0);
    [popoverController presentPopoverFromRect:[(UIButton *)sender frame]
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
}

-(void)colorPopoverControllerDidSelectColor:(UIColor*) colour{
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    BOOL success = [colour getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    NSLog(@"success: %i hue: %0.2f, saturation: %0.2f, brightness: %0.2f, alpha: %0.2f", success, hue, saturation, brightness, alpha);
    
    chooseTheme.hue = hue;
    chooseTheme.saturation = saturation;
    chooseTheme.brightness = brightness;

    [self.view setNeedsDisplay];
    [popoverController dismissPopoverAnimated:YES];
     popoverController = nil;
    [self setColor:colour];

}

-(void)setupColorButtons{
    int maxNCol = 10;
    
    if (nil == self.colorButtons)
    {
        NSMutableArray* newColorButtons = [NSMutableArray arrayWithCapacity:maxNCol];
        int colorNumber = 0;
        for (int i=0;i<maxNCol;i++){
            
            MTGKeyButton *colorButton = [MTGKeyButton buttonWithType:UIButtonTypeCustom];
            colorButton.frame = CGRectMake(310+i*60, 500, 50, 50);
            
            [colorButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
            
            [colorButton setSelected:NO];
            [colorButton setNeedsDisplay];
            
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

-(void) buttonPushed:(MTGKeyButton *)button{
    chooseTheme.hue         = button.hue;
    chooseTheme.saturation  = button.saturation;
    chooseTheme.brightness  = button.brightness;

    [self setColor:[UIColor colorWithHue:button.hue saturation:button.saturation brightness:button.brightness alpha:1.0]];
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
                       [UIColor brownColor],
                       [UIColor lightGrayColor],
                       nil];
}

- (IBAction)chooseFreq:(UIButton*)aButton {
    NSString *buttonName = [aButton titleForState:UIControlStateNormal];
    
    for (UIButton* button in freqButtons){
        if (button == aButton) button.selected = true;
        else button.selected = false;
    }
    
    chosenFrequency = buttonName;
    NSLog(@"Frequency selected: %@", chosenFrequency);
    frequency = [chosenFrequency floatValue];
    frequencyLabel.text = [NSString stringWithFormat:@"%4.0f Hz", frequency];
    freqTextField.text  = [NSString stringWithFormat:@"%4.0f", frequency];
    freqTextField.backgroundColor = nil;
    [freqTextField resignFirstResponder];
    
    continueButton.enabled = true;
}

- (IBAction)frequencyInputTxtField:(id)sender {
    frequency = [[freqTextField text] integerValue];
    frequencyLabel.text = [NSString stringWithFormat:@"%4.0f Hz", frequency];
    [sender resignFirstResponder];
    [self validateFreq];
}

-(void)dismissKeyboard {
   if ([freqTextField isFirstResponder]){
       frequency = [[freqTextField text] integerValue];
       frequencyLabel.text = [NSString stringWithFormat:@"%4.0f Hz", frequency];
       [freqTextField resignFirstResponder];
       [self validateFreq];
   }
}

- (void)validateFreq{
    BOOL numberInputOnly = true;
    char y = [freqTextField.text characterAtIndex:(freqTextField.text.length-1)];
    if (y < '0' || y > '9'){
        NSLog(@"wrong input");
        numberInputOnly = false;
    }
    
    if (freqTextField.text.integerValue < 100 || freqTextField.text.integerValue> 600 || !numberInputOnly){
        freqTextField.backgroundColor = [UIColor redColor];
        frequencyLabel.text = @"f value should be between 100 and 600";
        continueButton.enabled = false;
    }
    else{
        freqTextField.backgroundColor = nil;
        continueButton.enabled = true;
        frequency = [[freqTextField text] integerValue];
        frequencyLabel.text = [NSString stringWithFormat:@"%4.0f Hz", frequency];
    }
}

- (IBAction)releaseFreqBts:(id)sender {
    for (UIButton* button in freqButtons)button.selected = false;
}

-(IBAction)splitInputChanged:(UISlider *)slider{
    split = slider.value;
    splitLabel.text = [NSString stringWithFormat:@"%li", (long)split];
}

- (IBAction)createIt:(id)sender {
   
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"firstRun"];
    
    [defaults setInteger:   split       forKey:@"numberOfSplits"   ];
    [defaults setFloat:     frequency   forKey:@"frequency"        ];
    [defaults setFloat:     colourHue   forKey:@"themeHue"         ];
    [defaults setFloat:     colourSat   forKey:@"themeSat"         ];
    [defaults setFloat:     colourBrg   forKey:@"themeBrg"         ];
    [defaults setBool:      false       forKey:@"saved"            ];
    
    long numberOfSession = 0;
    if (![defaults integerForKey:@"noOfScalesCreated"])
            numberOfSession = [defaults integerForKey:@"initNoOfScalesCreated"];
    else    numberOfSession = [defaults integerForKey:@"noOfScalesCreated"];
    numberOfSession+=1;
    [defaults setInteger:numberOfSession forKey:@"currentScale"];
    [defaults setInteger:numberOfSession forKey:@"noOfScalesCreated"];
    
    [defaults synchronize];
    
    NSLog(@"Data saved");
    
    MTGAppDelegate *authObj = (MTGAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (authObj.authenticated == NO)
    {
        authObj.authenticated = YES;
        
        SWRevealViewController *revealViewController = self.revealViewController;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MTGCreateNewViewController *frontViewController = [sb instantiateViewControllerWithIdentifier:@"frontViewController"];
        
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        [revealViewController setFrontViewController:frontNavigationController animated:YES];
    }
}


@end
