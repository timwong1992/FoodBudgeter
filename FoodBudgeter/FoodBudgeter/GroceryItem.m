//
//  GroceryItem.m
//  FoodBudgeter
//
//  Created by Student on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "GroceryItem.h"

@implementation GroceryItem

@synthesize itemCost, unitAmount, unitType;

- (id)initWithID:(int)_itemId withName:(NSString*)_itemName withCost:(double)_cost unitAmount:(double)amount unitType:(NSString *)type {
    self = [super initWithID:_itemId withName:_itemName];
    if (self) {
        self.itemCost = _cost;
        self.unitAmount = amount;
        self.unitType = type;
    }
    return self;
}

- (NSString*)createAddDBQuery {
    return [NSString stringWithFormat:@"INSERT INTO item (itemName, itemType) VALUES (\"%@\", \"Purchase\")", self.itemName];
}

@end
