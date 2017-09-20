//
//  foodItem.m
//  Food Stand
//
//  Created by Robert Crosby on 9/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "foodItem.h"

@implementation foodItem

-(instancetype)initWithImage:(UIImage*)image andName:(NSString*)name andDescription:(NSString*)description andItem:(NSString*)item andQty:(NSNumber*)qty andZip:(NSNumber*)zip andDelivers:(NSNumber*)delivers andAllergy:(NSString*)allergy andSeller:(NSString *)seller andPrice:(NSNumber *)price{
    self = [super init];
    if(self)
    {
        self.image = image;
        self.name = name;
        self.descript = description;
        self.item = item;
        self.qty = qty;
        self.zip = zip;
        self.delivers = delivers;
        self.allergy = allergy;
        self.seller = seller;
        self.price = price;
    }
    return self;
}
@end
