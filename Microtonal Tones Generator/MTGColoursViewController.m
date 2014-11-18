//
//  MTGColoursViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 21/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGColoursViewController.h"

@interface MTGColoursViewController ()
@property (nonatomic, strong) NSArray* colorButtons;

@end

@implementation MTGColoursViewController

@synthesize colours;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createColorsArray];
    [self setupColorButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) createColorsArray{
    self.colorCollection = [NSArray arrayWithObjects:
                            [UIColor redColor],
                            [UIColor orangeColor],
                            [UIColor yellowColor],
                            [UIColor purpleColor],
                            [UIColor greenColor],
                            [UIColor blueColor],
                            [UIColor blackColor],
                            [UIColor brownColor],
                            [UIColor cyanColor],
                            [UIColor magentaColor],
                            [UIColor redColor],
                            [UIColor redColor],nil];
}


-(void)setupColorButtons{
    int maxNCol = 12;
    
    if (nil == self.colorButtons)
    {
        NSMutableArray* newColorButtons = [NSMutableArray arrayWithCapacity:maxNCol];
        int colorNumber = 0;
        for (int i=0;i<maxNCol;i++){

            MTGColourButton *colorButton = [MTGColourButton buttonWithType:UIButtonTypeCustom];
            colorButton.frame = CGRectMake(10+(i%4)*52, 10+(i/4)*27, 50, 25);
            
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



-(void) buttonPushed:(id)sender{
   
    MTGColourButton *btn = (MTGColourButton *)sender;
    [delegate colorPopoverControllerDidSelectColor:btn.colourOfScale];
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
