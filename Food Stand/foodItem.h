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
@property (nonatomic, strong) NSString* name;

-(instancetype)initWithImage:(UIImage*)image andName:(NSString*)name;


@end
