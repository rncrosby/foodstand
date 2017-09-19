//
//  transactionObject.m
//  Hitch
//
//  Created by Robert Crosby on 8/21/17.
//  Copyright © 2017 fully toasted. All rights reserved.
//

#import "foodObject.h"

@implementation foodObject

-(instancetype)initWithType:(UIImage*)image andName:(NSString*)name{
    self = [super init];
    if(self)
    {
        self.image = image;
        self.name = name;

    }
    return self;
}



@end
