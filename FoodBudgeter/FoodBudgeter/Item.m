//
//  Item.m
//  FoodBudgeter
//
//  Created by Student on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize itemId, itemName;

- (id)initWithID:(int)_itemId withName:(NSString*)_itemName {
    self = [super init];
    if (self) {
        self.itemId = _itemId;
        self.itemName = _itemName;
    }
    return self;
}

@end
