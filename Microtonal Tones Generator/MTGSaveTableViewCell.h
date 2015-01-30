//
//  MTGSaveTableViewCell.h
//  Microtonal Tones Generator
//
//  Created by Anna on 21/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGSaveTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *freqLabel   /** frequency label */;
@property (strong, nonatomic) IBOutlet UILabel *splitLabel /** split label */;
@property (strong, nonatomic) IBOutlet UILabel *nameOfScale /** label representing the name of the session */;
@property (strong, nonatomic) IBOutlet UIImageView *imageView /** image of the session */;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel /** date created label */;
@property (strong, nonatomic) IBOutlet UILabel *lastUpdateLabel /** date last updated label */;

@end
