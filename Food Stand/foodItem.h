//
//  foodItem.h
//  Food Stand
//
//  Created by Robert Crosby on 9/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface foodItem : NSObject

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) NSString* seller;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* descript;
@property (nonatomic, strong) NSString* item;
@property (nonatomic, strong) NSNumber* price;
@property (nonatomic, strong) NSNumber* qty;
@property (nonatomic, strong) NSNumber* zip;
@property (nonatomic, strong) NSNumber* delivers;
@property (nonatomic, strong) NSString* allergy;

-(instancetype)initWithImage:(UIImage*)image andName:(NSString*)name andDescription:(NSString*)description andItem:(NSString*)item andQty:(NSNumber*)qty andZip:(NSNumber*)zip andDelivers:(NSNumber*)delivers andAllergy:(NSString*)allergy andSeller:(NSString*)seller andPrice:(NSNumber*)price;


@end
