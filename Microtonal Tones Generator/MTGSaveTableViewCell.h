//
//  MTGSaveTableViewCell.h
//  Microtonal Tones Generator
//
//  Created by Anna on 21/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGSaveTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *freqLabel;
@property (weak, nonatomic) IBOutlet UILabel *splitLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameOfScale;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *lastUpdateLabel;


@end
