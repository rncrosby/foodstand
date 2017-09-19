//
//  feedCell.m
//  Food Stand
//
//  Created by Robert Crosby on 9/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "feedCell.h"

@implementation feedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeType:(id)sender {
    if ([sender isOn]) {
        _currentType.text = @"Delivery";
    } else {
        _currentType.text = @"Pickup";
    }
}
@end
