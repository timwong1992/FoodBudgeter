//
//  PurchasedItem.m
//  FoodBudgeter
//
//  Created by Student on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "PurchasedItem.h"

@implementation PurchasedItem

@synthesize itemCost;

- (id)initWithID:(int)_itemId withName:(NSString*)_itemName withCost:(double)cost {
    self = [super initWithID:_itemId withName:_itemName];
    if (self) {
        self.itemCost = cost;
    }
    return self;
}

@end
