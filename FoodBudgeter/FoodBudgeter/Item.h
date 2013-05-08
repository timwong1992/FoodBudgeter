//
//  Item.h
//  FoodBudgeter
//
//  Created by Tim Wong on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property(nonatomic, assign) NSInteger itemId;      // The identification
@property(nonatomic, strong) NSString *itemName;    // American Cheese

- (id)initWithName:(NSString *)_itemName;
- (id)initWithID:(int)_itemId withName:(NSString*)_itemName;

@end
