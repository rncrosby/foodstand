//
//  transactionObject.h
//  Hitch
//
//  Created by Robert Crosby on 8/21/17.
//  Copyright © 2017 fully toasted. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface foodObject : NSObject

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) NSString* name;

-(instancetype)initWithType:(UIImage*)image andName:(NSString*)name;

@end
