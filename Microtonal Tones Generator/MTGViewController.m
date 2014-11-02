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

@synthesize patches;
@synthesize dollarZero = dollarZero_;
@synthesize loading, indexOfFileLoading, saveStateButon, startButtonItem, saveSessionButton;

float calcFreqOfNote (NSInteger position, NSInteger splits, float f0){
    
    float a = powf(2, 1/((float)(splits)));
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
        [self initialiseValues];

        creationState = false;
        
        if (sessionIsSaved) saveSessionButton.enabled=false;
        else saveSessionButton.enabled=true;
        
        // sound creation
        dispatcher = [[PdDispatcher alloc]init];
        [PdBase setDelegate:dispatcher];
        patch = [PdBase openFile:kShortPatchName path:[[NSBundle mainBundle] resourcePath]];
        if (!patch) {
            NSLog(@"Failed to open patch!");
        }
        patches = [NSMutableArray array];
        
        //
        
        keyboard = [NSMutableArray array];
        pressedKeys = [NSMutableArray array];
        savedStates =[NSMutableArray array];
        
        for (int i = 0; i<=numberOfSplits; i++){
            [patches addObject:@"1"];
             [self createButton: i];
        }
        NSLog(@"Patches: %lu", (unsigned long)[patches count]);
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

-(void) initialiseValues{
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
        MTGSavedScale *scaleLoading;
        scaleLoading = [NSKeyedUnarchiver unarchiveObjectWithData:archivedScales[indexOfFileLoading]];
        numberOfSplits = scaleLoading.splitsNumber;
        frequency = scaleLoading.freqInitial;
        hueOfKeys = scaleLoading.hue;
        saturOfKeys = scaleLoading.saturarion;
        brightOfKey = scaleLoading.brightness;
        loading = false;
        sessionIsSaved = true;
        
        [defaults setInteger:numberOfSplits forKey:@"numberOfSplits"];
        [defaults setFloat:frequency forKey:@"frequency"];
        [defaults setFloat:hueOfKeys forKey:@"themeHue"];
        [defaults setFloat:saturOfKeys forKey:@"themeSat"];
        [defaults setFloat:brightOfKey forKey:@"themeBrg"];
        [defaults setBool:sessionIsSaved forKey:@"saved"];
        [defaults synchronize];
    }
    else{
        numberOfSplits = [defaults integerForKey:@"numberOfSplits"];
        frequency = [defaults floatForKey:@"frequency"];
        hueOfKeys = [defaults floatForKey:@"themeHue"];
        saturOfKeys = [defaults floatForKey:@"themeSat"];
        brightOfKey = [defaults floatForKey:@"themeBrg"];
        sessionIsSaved = [defaults boolForKey:@"saved"];
    }
    NSLog(@"Received %li splits, %4.1f Hz frequency",numberOfSplits, frequency);
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
- (IBAction)polifoniaStart:(id)sender {
    
    if (!creationState){
        [startButtonItem setTitle:@"Stop"];
        creationState = true;
        saveStateButon.enabled = true;
    }
    else
    {
        [startButtonItem setTitle:@"Start"];
        
        creationState = false;
        saveStateButon.enabled = false;
        
        for(UIButton* button in keyboard){
            button.selected = false;
        }
        
        [patches removeAllObjects];
        [pressedKeys removeAllObjects];
        
        for (int i = 0; i<=numberOfSplits; i++)
        {
            [patches addObject:@"1"];
        }
        NSLog(@"Patches: %lu", [patches count]);
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

    //x values
    NSInteger maxNumberOfKeysInRow = 8;
    float keyWidth, keyHeight, divisionOfScreen, xPosition, yPosition;
    NSInteger n;
    keyHeight = screenHeight/(2*(numberOfSplits/8+1));
    for (int rows=1; rows<6;rows++){
        if (numberOfSplits>(rows-1)*maxNumberOfKeysInRow){
            n = numberOfSplits/rows;
            keyWidth  = 3*screenWidth /(4*(n+3));
            divisionOfScreen = screenWidth/(n+3);
            yPosition = 150+(index/maxNumberOfKeysInRow)*(keyHeight+10);
            xPosition = (index%maxNumberOfKeysInRow)*divisionOfScreen+(divisionOfScreen-keyWidth)/2;
            aButton.frame = CGRectMake(xPosition, yPosition, keyWidth, keyHeight);
        }
    }
    [keyboard addObject:aButton];
    [self.view addSubview:aButton];
}

- (void)buttonClicked:(UIButton*)aButton{
    
    NSLog(@"Button %li clicked.",[aButton tag]);
    
    float frequencyOfNote = calcFreqOfNote([aButton tag], numberOfSplits, frequency);
    
    if (creationState){
        if(!aButton.selected) {
            aButton.selected = true;
            [self playNoteLong:frequencyOfNote at:[aButton tag]];
        }
        else{
            NSLog(@"Patch removed with %li", [aButton tag]);
            [patches removeObjectAtIndex:[aButton tag]];
            [pressedKeys removeObject:[NSNumber numberWithInt:[aButton tag]]];
            [patches insertObject:@"1" atIndex:[aButton tag]];
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
        NSLog(@"Patches: %li", [patches count]);
        [patches removeObjectAtIndex:index];
        [patches insertObject:patchOfKey atIndex:index];
        [pressedKeys addObject:[NSNumber numberWithInt:index]];
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

- (IBAction)saveSession:(id)sender {
    NSMutableArray* archScales;
    MTGSavedScale* scale = [[MTGSavedScale alloc] init];
    scale.freqInitial = frequency;
    scale.splitsNumber = numberOfSplits;
    scale.hue = hueOfKeys;
    scale.brightness = brightOfKey;
    scale.saturarion = saturOfKeys;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedScale = [NSKeyedArchiver archivedDataWithRootObject:scale];

    if ([defaults objectForKey:@"scales"]){
       archScales = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"scales"]];
    }
    for (NSData *data in archScales){
        MTGSavedScale* scaleStored = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ((scale.freqInitial == scaleStored.freqInitial) && (scale.splitsNumber == scaleStored.splitsNumber) ) sessionIsSaved = YES;
        else sessionIsSaved = NO;
    }
    if (!sessionIsSaved){
        [archScales addObject:encodedScale];
        [defaults setObject:archScales forKey:@"scales"];
        sessionIsSaved = YES;
        saveSessionButton.enabled = false;
        NSLog(@"Saved");
    }
    [defaults setBool:sessionIsSaved forKey:@"saved"];

}

- (IBAction)saveState:(id)sender {
    sessionIsSaved = false;
    saveSessionButton.enabled = true;
    NSLog(@"%@", pressedKeys);
 
    
    [savedStates addObject:pressedKeys];
    NSLog(@"States saved %@", savedStates);
    
    //wrong >
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:savedStates forKey:@"savedStates"];
    [defaults synchronize];
}


@end
