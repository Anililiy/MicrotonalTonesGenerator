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
#import "MTGHelpViewController.h"

@implementation MTGCreateNewViewController
@synthesize popoverController, colorCollection;
@synthesize freqButtons,frequencyLabel,splitLabel,chooseTheme,frequency,split,colourHue,colourSat, colourBrg, freqTextField, continueButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
        -set background image
     */
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background3.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    /**
    	- add a gesture recognizer
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    /**
    	- set initial values using NSUserDefaults
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    split       = [defaults integerForKey:  @"deaultNumberOfSplits" ];
    frequency   = [defaults floatForKey:    @"defaultFrequency"     ];
    colourHue   = [defaults floatForKey:    @"initThemeHue"         ];
    colourSat   = [defaults floatForKey:    @"initThemeSat"         ];
    colourBrg   = [defaults floatForKey:    @"initThemeBrg"         ];
    
    splitLabel.text     = [NSString stringWithFormat:@"%li", (long)split];
    frequencyLabel.text = [NSString stringWithFormat:@"%4.0f Hz", frequency];

    chooseTheme.hue        = colourHue;
    chooseTheme.saturation = colourSat;
    chooseTheme.brightness = colourBrg;
    
    /**
    	- calls creation of color array
     */
    [self createColorsArray ];
    
    /**
    	- set ups color button representation
     */
    [self setupColorButtons ];
    
    /**
    	- sets up menu
     */
    [self setupMenuRevelation];

    continueButton.enabled = true;
}

- (void)setupMenuRevelation{
    /** - allocates Navigation Item Bar Buttons to open and show menus */

    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        UIBarButtonItem *barBtnMenu = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openLeftMenu)];
        barBtnMenu.tintColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
        
        self.navigationItem.leftBarButtonItem = barBtnMenu;

        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
    /**
    	- adds Gesture Recognizers to cover view so that if they pressed menu would be closed and if menu opens then the view to be shown
 
     */
    [_ViewCover setHidden:true];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(openLeftMenu)];
    [_ViewCover addGestureRecognizer:singleFingerTap];
    _menuCalled = false;
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
    popoverController.popoverContentSize = CGSizeMake(250.0, 250.0);
    [popoverController presentPopoverFromRect:[(UIButton *)sender frame]
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
}

-(void)colorPopoverControllerDidSelectColor:(UIColor*) colour{
    [self setColor:colour];
    [self.view setNeedsDisplay];
    [popoverController dismissPopoverAnimated:YES];
     popoverController = nil;

}


-(void)setColor:(UIColor*)color{
    CGFloat alpha;
    BOOL success = [color getHue:&colourHue saturation:&colourSat brightness:&colourBrg alpha:&alpha];
    NSLog(@"colour extracted: %i",success);
    chooseTheme.hue = colourHue;
    chooseTheme.saturation = colourSat;
    chooseTheme.brightness = colourBrg;
}

-(void)setupColorButtons{
    int maxNCol = 10;
    
    if (nil == self.colorButtons)
    {
        NSMutableArray* newColorButtons = [NSMutableArray arrayWithCapacity:maxNCol];
        int colorNumber = 0;
        for (int i=0;i<maxNCol;i++){
            
            MTGKeyButton *colorButton = [MTGKeyButton buttonWithType:UIButtonTypeCustom];
            colorButton.frame = CGRectMake(200+i*80, 500, 70, 70);
            
            [colorButton addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
            
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
-(void)chooseColor:(MTGKeyButton *)button{
    chooseTheme.hue         = button.hue;
    chooseTheme.saturation  = button.saturation;
    chooseTheme.brightness  = button.brightness;
    
    colourHue = button.hue;
    colourSat = button.saturation;
    colourBrg = button.brightness;
    
    /*
    UIImage *img = [UIImage imageNamed:@"background1.jpg"];
    
    img = [self imageNamed:@"background1.jpg" withColor:[UIColor colorWithHue:colourHue saturation:colourSat brightness:colourBrg alpha:0.1]];

    UIGraphicsBeginImageContext(self.view.frame.size);
    [img drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
     */
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
/*
-(UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color {
    // load the image
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}
*/
- (IBAction)chooseFreq:(UIButton*)aButton {
    NSString *buttonName = [aButton titleForState:UIControlStateNormal];
    
    for (UIButton* button in freqButtons){
        if (button == aButton) button.selected = true;
        else button.selected = false;
    }
    
    NSLog(@"Frequency selected: %@", buttonName);
    frequency = [buttonName floatValue];
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
   
    // Store the data inputed in NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger: split       forKey:@"numberOfSplits"];
    [defaults setFloat:   frequency   forKey:@"frequency"     ];
    [defaults setFloat:   colourHue   forKey:@"themeHue"      ];
    [defaults setFloat:   colourSat   forKey:@"themeSat"      ];
    [defaults setFloat:   colourBrg   forKey:@"themeBrg"      ];
    [defaults setBool:    YES         forKey:@"authenticated" ];
    [defaults setBool:    NO          forKey:@"saved"         ];
    
    //update number of sessions created
    long numberOfSession = 0;
    if ([defaults integerForKey:@"noOfScalesCreated"]) numberOfSession = [defaults integerForKey:@"noOfScalesCreated"];
    numberOfSession+=1;
    [defaults setInteger:numberOfSession forKey:@"noOfScalesCreated"];
    
    [defaults synchronize];
    
    NSLog(@"Data saved");
    
    // sets MTGViewController as the first view loading in the app - when app is exited and then opened again user sees MTGViewController
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"newHelp"])
    {
        MTGHelpViewController *detailViewController = [segue destinationViewController];
        detailViewController.text = @"You can select number of splits by moving the slider.\n\nTo select initial frequency press either one of 3 buttons presented or input your own in the text field, just remember that the frequency should be in the range from 100 to 600 Hz.\n\nThe last thing is to choose colour.  You can either choose one of the color given or choose your own by pressing on the Colour button and selecting color in color wheel.\n\nWhen you have completed configuration press Continue to create new Session.";
    }
}



@end
