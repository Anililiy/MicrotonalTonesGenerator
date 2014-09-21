//
//  MTGColoursViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 21/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGColoursViewController.h"

@interface MTGColoursViewController ()


@end

@implementation MTGColoursViewController

@synthesize colours;
@synthesize colourChosen;
//@synthesize viewCotroller = _viewCotroller;

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
         for (int i=0;i<12;i++){
        
        CGRect rect = CGRectMake(10+(i%4)*52, 10+(i/4)*27, 50, 25);
        UITapGestureRecognizer *tapGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorSelected:)];

        UIView *colourView = [[UIView alloc] initWithFrame:rect];
        float hue = (1/11.0)*(i);
        colourView.backgroundColor = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0*i/2 alpha:1.0];
        [colourView addGestureRecognizer:tapGestureRecogniser];
        [colours addObject:colourView];
        //NSLog(@"%@",colours);
        [self.view addSubview:colourView];
    }
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)colorSelected:(UITapGestureRecognizer*)tapGestureRecognizer
{
    self.view =  (UIView*)[colours objectAtIndex:4];
    NSLog(@"Color tapped:");
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
