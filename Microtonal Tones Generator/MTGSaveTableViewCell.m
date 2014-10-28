//
//  MTGSaveTableViewCell.m
//  Microtonal Tones Generator
//
//  Created by Anna on 21/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGSaveTableViewCell.h"

@implementation MTGSaveTableViewCell
@synthesize freqLabel=_freqLabel;
@synthesize splitLabel=_splitLabel;
@synthesize nameOfScale=_nameOfScale;
@synthesize dateLabel=_dateLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
