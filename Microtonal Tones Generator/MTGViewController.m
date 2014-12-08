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
#import "MTGSavedStatesTableViewController.h"

NSString *const kTestPatchName  = @"test2.pd";
NSString *const kShortPatchName = @"KeyNote.pd";

@interface MTGViewController ()

@property (nonatomic, retain) NSMutableArray *patches;
@property (nonatomic, assign) int dollarZero;
@end

@implementation MTGViewController

@synthesize patches;
@synthesize dollarZero = dollarZero_;
@synthesize loading, indexOfFileLoading, saveStateButon, startButtonItem, saveSessionButton;
@synthesize numberOfSavedScales, stateSelected, indexOfStateChosen, frequencyLabel;
@synthesize playNextStateButton, playPreviousStateButton, ViewCover, ViewCover2;
@synthesize upTheOctave, downTheOctave, changeOctave;

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
       if(![(MTGAppDelegate*)[[UIApplication sharedApplication] delegate] authenticated]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        MTGRootViewController *initView =  (MTGRootViewController*)[storyboard instantiateViewControllerWithIdentifier:@"initialView"];
        [initView setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:initView animated:NO completion:nil];
        
    } else{
        [self changeSize];
        
        [ViewCover setHidden:true];
        [ViewCover2 setHidden:true];
        //The setup code (in viewDidLoad in your view controller)
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(openLeftMenu)];
        [ViewCover addGestureRecognizer:singleFingerTap];
        
        UITapGestureRecognizer *singleFingerTap2 =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(openRightMenu)];
        [ViewCover2 addGestureRecognizer:singleFingerTap2];

        //setting of prog
        //
        [self customSetup];
        [self initialiseValues];

        creationState = false;
        menuCalled = false;
        octaveNumber = 0;
        
        if (sessionIsSaved){
            saveSessionButton.enabled = false;
            self.navigationItem.rightBarButtonItem.enabled = true;
        }
        else {
            saveSessionButton.enabled = true;
            self.navigationItem.rightBarButtonItem.enabled = false;
        }
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
        
        for (int i = 0; i<=numberOfSplits; i++){
            [patches addObject:@"1"];
             [self createButton: i];
        }
        NSLog(@"Patches: %lu", (unsigned long)[patches count]);
        
        //_scaleNavigationItem.title = [NSString stringWithFormat:@"Session № %i", scaleNumber];
        
        [self representStateSeleted];
        frequencyLabel.text = [NSString stringWithFormat:@"fo = %2.2f Hz", frequency];
        freqInitial = frequency;
        [self takeScreenshot];
    }
}

- (void)customSetup{
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        UIBarButtonItem *barBtnMenu = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openLeftMenu)];
        barBtnMenu.tintColor = [UIColor colorWithWhite:0.2f alpha:0.7f];

        self.navigationItem.leftBarButtonItem = barBtnMenu;
        
        UIBarButtonItem *barBtnStates = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openRightMenu)];
        barBtnStates.tintColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
        
        self.navigationItem.rightBarButtonItem = barBtnStates;
        
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

-(void)changeSize{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect frame = ViewCover.frame;
    frame.size.height = screenRect.size.height;
    frame.size.width  = screenRect.size.width;
    frame.origin = CGPointMake (0, 0);
    ViewCover.frame = frame;
    
    //ViewCover.backgroundColor = [UIColor colorWithRed:0.3 green:0.6 blue:0.3 alpha:0.3];
    [self.view bringSubviewToFront:ViewCover];
}

-(void)openLeftMenu{
    [self clearUp];
    menuCalled = !menuCalled;
    //[self changeSize];
    [self.view bringSubviewToFront:ViewCover];

    if (menuCalled)[ViewCover setHidden:false];
    else [ViewCover setHidden:true];
    
    SWRevealViewController *reveal = self.revealViewController;
    [reveal revealToggleAnimated:YES];
}

-(void)openRightMenu{
    
    menuCalled = !menuCalled;
    //[self changeSize];
    [self.view bringSubviewToFront:ViewCover2];

    if (menuCalled)[ViewCover2 setHidden:false];
    else [ViewCover2 setHidden:true];

    [startButtonItem setTitle:@"Polyphony"];
    
    creationState = false;
    saveStateButon.enabled = false;
    playPreviousStateButton.enabled = false;
    playNextStateButton.enabled = false;
    [self clearUp];
    
    SWRevealViewController *reveal = self.revealViewController;
    [reveal rightRevealToggleAnimated:YES];
}

-(void) initialiseValues{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    currentScale = [[MTGSavedScale alloc]init];
    NSMutableArray *archivedScales = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"savedSessions"]];
    sessionIsSaved = [defaults boolForKey:@"saved"];

    if (![defaults integerForKey:@"numberOfSplits"]) {
        numberOfSplits  = [defaults integerForKey:@"deaultNumberOfSplits"];
        frequency       = [defaults floatForKey:@"defaultFrequency"];
        hueOfKeys       = [defaults floatForKey:@"initThemeHue"];
        saturOfKeys     = [defaults floatForKey:@"initThemeSat"];
        brightOfKey     = [defaults floatForKey:@"initThemeBrg"];
        savedStates     = [NSMutableArray array];
    }
    else if (loading){
        
        NSLog(@"Index of file loading: %li",(long)indexOfFileLoading);
        currentScale = [NSKeyedUnarchiver unarchiveObjectWithData:archivedScales[indexOfFileLoading]];
    
        savedStates = [NSMutableArray arrayWithArray:currentScale.savedStates];
        numberOfSplits = currentScale.splitsNumber;
        frequency = currentScale.freqInitial;
        hueOfKeys = currentScale.hue;
        saturOfKeys = currentScale.saturarion;
        brightOfKey = currentScale.brightness;
        loading = false;
        sessionIsSaved = true;
        scaleNumber= currentScale.scaleNumber;
        
        [defaults setInteger:numberOfSplits forKey:@"numberOfSplits"];
        [defaults setFloat:frequency        forKey:@"frequency"];
        [defaults setFloat:hueOfKeys        forKey:@"themeHue"];
        [defaults setFloat:saturOfKeys      forKey:@"themeSat"];
        [defaults setFloat:brightOfKey      forKey:@"themeBrg"];
        [defaults setBool:sessionIsSaved    forKey:@"saved"];
        [defaults setInteger:scaleNumber    forKey:@"currentScale"];
        [defaults setInteger:indexOfFileLoading forKey:@"currentScaleIndex"];
        [defaults synchronize];
         
    }
    else if (sessionIsSaved){
        
        int currentScaleIndex = [defaults integerForKey:@"currentScaleIndex"];
        currentScale    = [NSKeyedUnarchiver unarchiveObjectWithData:archivedScales[currentScaleIndex]];
        savedStates     = [NSMutableArray arrayWithArray:currentScale.savedStates];
        numberOfSplits  = currentScale.splitsNumber;
        frequency       = currentScale.freqInitial;
        hueOfKeys       = currentScale.hue;
        saturOfKeys     = currentScale.saturarion;
        brightOfKey     = currentScale.brightness;
        scaleNumber     = currentScale.scaleNumber;
        
    }
    else{
        numberOfSplits  =  [defaults integerForKey:@"numberOfSplits"];
        frequency       =  [defaults floatForKey:@"frequency"];
        hueOfKeys       =  [defaults floatForKey:@"themeHue"];
        saturOfKeys     =  [defaults floatForKey:@"themeSat"];
        brightOfKey     =  [defaults floatForKey:@"themeBrg"];
        scaleNumber     =  [defaults integerForKey:@"currentScale"];
        
        int scalePositionInArray = [archivedScales count];
        [defaults setInteger:scalePositionInArray forKey:@"currentScaleIndex"];
        NSLog(@"Index passed %i",scalePositionInArray);
        
        [defaults synchronize];

        [savedStates removeAllObjects];
        savedStates     = [NSMutableArray array];
    }
    
    NSLog(@"Received %i splits, %4.1f Hz frequency",numberOfSplits, frequency);
    currentScale.freqInitial = frequency;
    currentScale.splitsNumber = numberOfSplits;
    currentScale.hue = hueOfKeys;
    currentScale.brightness = brightOfKey;
    currentScale.saturarion = saturOfKeys;
    currentScale.scaleNumber = scaleNumber;
    currentScale.savedStates = savedStates;
    if (sessionIsSaved) {
        [changeOctave setHidden:true];
        [frequencyLabel setHidden:true];
    }

}

-(void)representStateSeleted{
    if (stateSelected){
        NSMutableArray *keysSelected = savedStates[indexOfStateChosen];

        for (MTGKeyObject *key in keysSelected){
            for(UIButton* button in keyboard){
                if (button.tag == key.index){
                    button.selected = true;
                    [pressedKeys addObject:key];
                }

            }
            [self playNoteLong:key.keyFrequency at:key.index];
            [startButtonItem setTitle:@"Stop polyphony"];
            creationState = true;
            if (indexOfStateChosen<([savedStates count]-1)) playNextStateButton.enabled = true;
            if (indexOfStateChosen>=([savedStates count]-1)) playNextStateButton.enabled = false;
            if (indexOfStateChosen>0) playPreviousStateButton.enabled = true;
            if (indexOfStateChosen==0) playPreviousStateButton.enabled = false;
        }
    }
}

- (void)viewDidUnload{
    [self clearUp];
    [super viewDidUnload];
    [PdBase closeFile:patch];
    [PdBase setDelegate:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)clearUp{
    for(UIButton* button in keyboard)button.selected = false;
    
    [patches removeAllObjects];
    [pressedKeys removeAllObjects];
    
    for (int i = 0; i<=numberOfSplits; i++) [patches addObject:@"1"];
    
}

#pragma mark - buttons regulation
- (IBAction)polifoniaStart:(id)sender {
    
    if (!creationState){
        [startButtonItem setTitle:@"Stop polyphony"];
        creationState = true;
        if (sessionIsSaved) saveStateButon.enabled = true;
 
    }
    else
    {
        [startButtonItem setTitle:@"Polyphony"];
        
        creationState = false;
        saveStateButon.enabled = false;
        playPreviousStateButton.enabled = false;
        playNextStateButton.enabled = false;
        [self clearUp];
    }
}

- (IBAction)playNextStateAction:(id)sender {
    indexOfStateChosen +=1;
    [self clearUp];
    [self representStateSeleted];
}

- (IBAction)playPreviousStateAction:(id)sender {
    indexOfStateChosen -=1;
    [self clearUp];
    [self representStateSeleted];
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
    
    NSLog(@"Button %li clicked.",(long)[aButton tag]);
    
    float frequencyOfNote = calcFreqOfNote([aButton tag], numberOfSplits, frequency);
   
    MTGKeyObject *keyPressed = [[MTGKeyObject alloc]init];

    if (creationState){
        if(!aButton.selected) {
            aButton.selected = true;
            [self playNoteLong:frequencyOfNote at:[aButton tag]];
            
            keyPressed.index = [aButton tag];
            keyPressed.keyFrequency = frequencyOfNote;
            
            NSLog(@"Index %i, freq %f",keyPressed.index, keyPressed.keyFrequency);
            [pressedKeys addObject:keyPressed];
        }
        else{
            NSLog(@"Patch removed with %li", (long)[aButton tag]);
            [patches removeObjectAtIndex:[aButton tag]];
            [pressedKeys removeObject:[NSNumber numberWithInteger:[aButton tag]]];
            [patches insertObject:@"1" atIndex:[aButton tag]];
            for (int i=0; i<[pressedKeys count];i++){
                keyPressed = pressedKeys[i];
                if (keyPressed.index == [aButton tag]) [pressedKeys removeObjectAtIndex:i];
            }
            aButton.selected =!aButton.selected;
        }
        if (sessionIsSaved) saveStateButon.enabled = true;
    }
    else{
        [self playNoteShort:frequencyOfNote];
        aButton.selected = false;
    }
}

#pragma mark - button call back

-(void)playNoteLong:(float)f at:(NSInteger)index{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    PdFile *patchOfKey = [PdFile openFileNamed:kTestPatchName path:bundlePath];
    if (patchOfKey) {
        NSLog(@"opened patch with $0 = %d", [patchOfKey dollarZero]);
        NSLog(@"Patches: %li", (unsigned long)[patches count]);
        [patches removeObjectAtIndex:index];
        [patches insertObject:patchOfKey atIndex:index];
    }
    else {
        NSLog(@"error: couldn't open patch");
    }
    [PdBase sendFloat:f toReceiver:[NSString stringWithFormat:@"%d-pitch", [patchOfKey dollarZero]]];
}

-(void)playNoteShort:(float)freqValue{
    [PdBase sendFloat:freqValue toReceiver:@"midinote"];
    [PdBase sendBangToReceiver:@"trigger"];
}

- (IBAction)rightArrowPressed:(id)sender {
    if (frequency<=600){
        frequency =2*frequency;
        //frequency +=freqInitial;
        /*octaveNumber+=1;
        for (UIButton* button in keyboard){
            NSString *string =[NSString stringWithFormat:@"%i", ([button tag]+numberOfSplits*octaveNumber)];
            [button setTitle:string forState:UIControlStateNormal];
        }
         */
        frequencyLabel.text = [NSString stringWithFormat:@"fo = %2.2f Hz", frequency];
        downTheOctave.enabled = true;
    }
    else upTheOctave.enabled= false;
}

- (IBAction)leftArrowPressed:(UIButton*)sender {
    if (frequency>200){
        upTheOctave.enabled = true;
        frequency=frequency/2;
        frequencyLabel.text = [NSString stringWithFormat:@"fo = %2.2f Hz", frequency];
    }
    else downTheOctave.enabled = false;
}

- (IBAction)saveSession:(id)sender {
    
    //[self takeScreenshot];
    currentScale.freqInitial = frequency;
    currentScale.dateCreated = [NSDate date];
    NSMutableArray* archScales  = [NSMutableArray array];
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    NSData *encodedScale        = [NSKeyedArchiver archivedDataWithRootObject:currentScale];
    
    
    if ([defaults objectForKey:@"savedSessions"]){
       archScales = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"savedSessions"]];
    }
    /*
    for (NSData *data in archScales){
        MTGSavedScale* scaleStored = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ((currentScale.freqInitial == scaleStored.freqInitial) && (currentScale.splitsNumber == scaleStored.splitsNumber) ) sessionIsSaved = YES;
        else sessionIsSaved = NO;
    }
     */
    if (!sessionIsSaved){
        [archScales addObject:encodedScale];
        [defaults setObject:archScales forKey:@"savedSessions"];
        sessionIsSaved = YES;
        saveSessionButton.enabled = false;
        NSLog(@"Saved");
    }
    [defaults setBool:sessionIsSaved forKey:@"saved"];
    [changeOctave setHidden:true];
    [frequencyLabel setHidden:true];
   if (creationState) saveStateButon.enabled = true;

}

- (IBAction)saveState:(id)sender {

    saveStateButon.enabled = false;
    currentScale.dateLastUpdated = [NSDate date];
    
    NSMutableArray *keys =[NSMutableArray array];
    [keys addObjectsFromArray:pressedKeys];
    
    [savedStates addObject:keys];
    
    NSLog(@"States saved %@", savedStates);

    currentScale.scaleNumber = scaleNumber;
    currentScale.savedStates = savedStates;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* archScales = [NSMutableArray array];
    NSData *encodedScale = [NSKeyedArchiver archivedDataWithRootObject:currentScale];

    archScales = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"savedSessions"]];
    int indexOfScaleInTheArray = [defaults integerForKey:@"currentScaleIndex"];
    [archScales replaceObjectAtIndex:indexOfScaleInTheArray withObject:encodedScale];
    
    [defaults setObject:archScales forKey:@"savedSessions"];
    
    NSLog(@"Saved state");
    [defaults synchronize];
    if([savedStates count]>0)self.navigationItem.rightBarButtonItem.enabled = true;
    else self.navigationItem.rightBarButtonItem.enabled = false;
    [self clearUp];
    
}

- (void)takeScreenshot {
    //Define the dimensions of the screenshot you want to take (the entire screen in this case)
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGSize size =  CGRectMake(10, 10, screenWidth , 3*screenHeight/4).size;
    // Create the screenshot
    UIGraphicsBeginImageContext(size);
    // Put everything in the current view into the screenshot
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    // Save the current image context info into a UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    currentScale.imageOfScale = newImage;
}
@end
