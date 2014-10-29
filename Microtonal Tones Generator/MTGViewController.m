//
//  MTGViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 13/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGViewController.h"
#import "PdFile.h"
#import "PdBase.h"
#import "MTGAppDelegate.h"
#import "MTGRootViewController.h"
#import "MTGLoadTableViewController.h"

NSString *const kTestPatchName = @"test2.pd";
NSString *const kShortPatchName =@"KeyNote.pd";

@interface MTGViewController ()

@property (nonatomic, retain) NSMutableArray *patches;
@property (nonatomic, assign) int dollarZero;
@end

@implementation MTGViewController

@synthesize startButton;
@synthesize patches = _patches;
@synthesize dollarZero = dollarZero_;
@synthesize loading, indexOfFileLoading;

float calcFreqOfNote (int position, int splits, float f0){
    
    float a = powf(2, 1/((float)(splits)));
    //float n = (tag+40) - 49;
    float n = position;
    float frequencyOfNote = f0 * (powf(a,n));
    
    NSLog(@"frequency calculated: %f", frequencyOfNote);
    
    return frequencyOfNote;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self customSetup];
    
    if(![(MTGAppDelegate*)[[UIApplication sharedApplication] delegate] authenticated]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        MTGRootViewController *initView =  (MTGRootViewController*)[storyboard instantiateViewControllerWithIdentifier:@"initialView"];
        [initView setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:initView animated:NO completion:nil];
        
    } else{
        /*
         UIGraphicsBeginImageContext(self.view.frame.size);
         [[UIImage imageNamed:@"textures_1.jpg"] drawInRect:self.view.bounds];
         UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         
         self.view.backgroundColor = [UIColor colorWithPatternImage:image];
         */
        //setting of prog
        //
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if (![defaults integerForKey:@"numberOfSplits"]) {
            numberOfSplits = [defaults integerForKey:@"deaultNumberOfSplits"];
            frequency = [defaults floatForKey:@"defaultFrequency"];
            hueOfKeys = [defaults floatForKey:@"initThemeHue"];
            saturOfKeys = [defaults floatForKey:@"initThemeSat"];
            brightOfKey = [defaults floatForKey:@"initThemeBrg"];
        }
        else if (loading){
            
            NSMutableArray *archivedScales = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"scales"]];
            NSLog(@"Index of file loading: %li",(long)indexOfFileLoading);
            scaleLoading = [NSKeyedUnarchiver unarchiveObjectWithData:archivedScales[indexOfFileLoading]];
            numberOfSplits = scaleLoading.splitsNumber;
            frequency = scaleLoading.freqInitial;
            loading = false;
        }
        else{
            numberOfSplits = [defaults integerForKey:@"numberOfSplits"];
            frequency = [defaults floatForKey:@"frequency"];
            hueOfKeys = [defaults floatForKey:@"themeHue"];
            saturOfKeys = [defaults floatForKey:@"themeSat"];
            brightOfKey = [defaults floatForKey:@"themeBrg"];
        }

        NSLog(@"Received %i splits, %4.1f Hz frequency",numberOfSplits, frequency);
        creationState = false;
        scale = [[MTGSavedScale alloc] init];
        // sound creation
        dispatcher = [[PdDispatcher alloc]init];
        [PdBase setDelegate:dispatcher];
        patch = [PdBase openFile:kShortPatchName path:[[NSBundle mainBundle] resourcePath]];
        if (!patch) {
            NSLog(@"Failed to open patch!");
        }
        _patches = [NSMutableArray array];
        keyboard = [NSMutableArray array];
        scales = [NSMutableArray array];
        
        for (int i = 0; i<numberOfSplits; i++)[_patches addObject:@"1"];
        NSLog(@"Patches: %lu", (unsigned long)[_patches count]);
                //create an array of buttons
        for( int i = 0; i <= numberOfSplits; i++ ) {
            [self createButton: i];
        }
        
        //control of a start button
        self.startButton.tintColor = [UIColor colorWithHue:hueOfKeys saturation:1.0 brightness:0.8 alpha:1];
        [self.startButton addTarget:self action:@selector(startPressed:) forControlEvents:UIControlEventTouchUpInside];
    }

}


- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        //change slidebar button color
        _sidebarButton.tintColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
        _savedStatesSlideButton.tintColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
        
        //set the slide bar button action. When it is tapped, it will show up the slidebar.
        _sidebarButton.target = self.revealViewController;
        _sidebarButton.action = @selector(revealToggle:);
        
        
        //set the slide bar button action. When it is tapped, it will show up the slidebar.
        _savedStatesSlideButton.target = self.revealViewController;
        _savedStatesSlideButton.action = @selector(rightRevealToggle:);
        
        //set the gesture
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }


}


- (void)viewDidUnload {
    [super viewDidUnload];
    [PdBase closeFile:patch];
    [PdBase setDelegate:nil];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - buttons regulation

-(void)startPressed:(UIButton*)button{
    
    if (!creationState){
        [startButton setTitle:@"Stop" forState:UIControlStateNormal];
        creationState = true;
    }
    else
    {
        [startButton setTitle:@"Start" forState:UIControlStateNormal];
        creationState = false;
        
        for(UIButton* button in keyboard){
            button.selected = false;
        }
        
        [self.patches removeAllObjects];
        
        for (int i = 0; i<numberOfSplits; i++)
        {
            [_patches addObject:@"1"];
        }
        NSLog(@"Patches: %i", [_patches count]);
    }
    
}

-(void)createButton:(int)index{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aButton setTag:index];
    
    //action of button
    [aButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* title =[NSString stringWithFormat:@"%d", index];;
    [aButton setTitle:title forState:UIControlStateNormal];
    //UIImage *btnImage = [UIImage imageNamed:@"transparent.png"];
    //[aButton setImage:btnImage forState:UIControlStateNormal];
    [aButton setTintColor:[UIColor blackColor]];
    float saturation = saturOfKeys*(index+1)/((float)numberOfSplits+1);
    float brightnesOfKey = brightOfKey;
    if (brightOfKey<0.09) brightnesOfKey=1.0*(index+1)/((float)numberOfSplits+1);
    aButton.backgroundColor = [UIColor colorWithHue:hueOfKeys saturation:saturation brightness:brightnesOfKey alpha:1.0];
    //aButton.tintColor = [UIColor colorWithHue:hueOfKeys saturation:saturation brightness:brightnesOfKey alpha:0.5f];
    
    //x values
    float keyWidth  = 3*screenWidth / (4*(((numberOfSplits+1))));
    float keyHeight = screenHeight/(2*(numberOfSplits/8+1));
    float divisionOfScreen = screenWidth / ((numberOfSplits)+1);
    float xPosition = (index%8)*divisionOfScreen+(divisionOfScreen-keyWidth)/2;
    float yPosition = 100+(index/8)*(keyHeight+10);
    int n;
   // NSLog(@"Number %i",n);
    
    if (numberOfSplits<=8) {
        aButton.frame = CGRectMake(xPosition, yPosition, keyWidth, keyHeight);
    }else if (numberOfSplits<=16){
        n = numberOfSplits/2;
        keyWidth  = 3*screenWidth / (4*(((n+1))));
        divisionOfScreen = screenWidth/(n+2);
        yPosition = 100+((index-1)/8)*(keyHeight+10);
        xPosition = ((index-1)%8)*divisionOfScreen+(divisionOfScreen-keyWidth)/2;
        aButton.frame = CGRectMake(xPosition, yPosition, keyWidth, keyHeight);
    }else if (numberOfSplits<=24){
        n = numberOfSplits/3;
        keyWidth  = 3*screenWidth / (4*(((n+2))));
        divisionOfScreen = screenWidth / ((n)+3);
        xPosition = (index%8)*divisionOfScreen+(divisionOfScreen-keyWidth)/2;
        aButton.frame = CGRectMake(xPosition, yPosition, keyWidth, keyHeight);
    }else if (numberOfSplits<=32){
        n = numberOfSplits/4;
        keyWidth  = 3*screenWidth / (4*(((n+3))));
        divisionOfScreen = screenWidth / ((n)+4);
        xPosition = (index%8)*divisionOfScreen+(divisionOfScreen-keyWidth)/2;
        aButton.frame = CGRectMake(xPosition, yPosition, keyWidth, keyHeight);
    }
    
    [keyboard addObject:aButton];
    // NSLog(@"%@", keyboard);
    [self.view addSubview:aButton];

}

- (void)buttonClicked:(UIButton*)aButton{
    
    NSLog(@"Button %i clicked.",[aButton tag]);
    
    float frequencyOfNote = calcFreqOfNote([aButton tag], numberOfSplits, frequency);
    
    if (creationState){
        if(!aButton.selected) {
            aButton.selected = true;
            [self playNoteLong:frequencyOfNote at:[aButton tag]];
        }
        else{
            NSLog(@"Patch removed with %i", [aButton tag]);
            [self.patches removeObjectAtIndex:[aButton tag]];
            [self.patches insertObject:@"1" atIndex:[aButton tag]];
            aButton.selected =!aButton.selected;
        }
    }
    else{
        [self playNoteShort:frequencyOfNote];
        aButton.selected = false;
    }
}

#pragma mark - button call back

-(void)playNoteLong:(int)n at:(int)index{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    PdFile *patchOfKey = [PdFile openFileNamed:kTestPatchName path:bundlePath];
    if (patchOfKey) {
        NSLog(@"opened patch with $0 = %d", [patchOfKey dollarZero]);
        NSLog(@"Patches: %i", [_patches count]);

        [_patches insertObject:patchOfKey atIndex:index];
    }
    else {
        NSLog(@"error: couldn't open patch");
    }
    [PdBase sendFloat:n toReceiver:[NSString stringWithFormat:@"%d-pitch", [patchOfKey dollarZero]]];
}

-(void)playNoteShort:(int)n{
    [PdBase sendFloat:n toReceiver:@"midinote"];
    [PdBase sendBangToReceiver:@"trigger"];
}

- (IBAction)rightArrowPressed:(id)sender {
    if (frequency<=600) frequency =2*frequency;
}

- (IBAction)leftArrowPressed:(id)sender {
    if (frequency>100) frequency=frequency/2;
}

- (IBAction)saveScale:(id)sender {

    scale.freqInitial = frequency;
    scale.splitsNumber = numberOfSplits;
    [scales removeAllObjects];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedScale = [NSKeyedArchiver archivedDataWithRootObject:scale];

    if ([defaults objectForKey:@"scales"]){
        scales = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"scales"]];
    }
    for (NSData *data in scales){
        MTGSavedScale* scaleStored = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ((scale.freqInitial == scaleStored.freqInitial) && (scale.splitsNumber == scaleStored.splitsNumber) ) saved = YES;
        else saved = NO;
    }
    if (!saved){
        [scales addObject:encodedScale];
        [defaults setObject:scales forKey:@"scales"];
        NSLog(@"Saved");
    }
    //[defaults setObject:scales forKey:@"scales"];
}
@end
