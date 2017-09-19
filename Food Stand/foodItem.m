//
//  foodItem.m
//  Food Stand
//
//  Created by Robert Crosby on 9/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "foodItem.h"

@implementation foodItem

-(instancetype)initWithImage:(UIImage*)image andName:(NSString*)name{
    self = [super init];
    if(self)
    {
        self.image = image;
        self.name = name;
        
    }
    return self;
}
@end
