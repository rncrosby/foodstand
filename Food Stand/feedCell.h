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
@property (weak, nonatomic) IBOutlet UILabel *topShadow;
@property (weak, nonatomic) IBOutlet UILabel *blur;
@property (weak, nonatomic) IBOutlet UILabel *bottomShadow;
@property (weak, nonatomic) IBOutlet UISwitch *control;
@property (weak, nonatomic) IBOutlet UILabel *currentType;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *card2;
@property (weak, nonatomic) IBOutlet UILabel *bottomShadow2;
- (IBAction)changeType:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *actualShadow2;
@property (weak, nonatomic) IBOutlet UILabel *actualShadow3;

@end
