//
//  feedCell.h
//  Food Stand
//
//  Created by Robert Crosby on 9/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface feedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *card;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *shadow;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
