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

- (id)initWithID:(int)_itemId withName:(NSString*)_itemName withDate:(NSDate*)date withCost:(double)_cost unitAmount:(double)amount unitType:(NSString *)type {
    self = [super initWithID:_itemId withName:_itemName withDate:date];
    if (self) {
        self.itemCost = _cost;
        self.unitAmount = amount;
        self.unitType = type;
    }
    return self;
}

- (NSString*)createAddDBQuery {
    return [NSString stringWithFormat:@"INSERT INTO item (itemName, itemType, date) VALUES (\"%@\", \"Grocery\", \"%@\")", self.itemName, [self.dateLogged description]];
}

- (NSString*)createAddSubtableQuery {
    return [NSString stringWithFormat:@"INSERT INTO grocery (groceryID, itemCost, unitAmount, unitType) VALUES (%d, \"%.2f\", \"%.2f\", \"%@\")", self.itemId, self.itemCost, self.unitAmount, self.unitType];
}

- (NSString*)createRemoveSubtableQuery {
    return [NSString stringWithFormat:@"DELETE FROM grocery WHERE groceryID = %d", self.itemId];
}

- (int)numOfProperties {
    return 6;
}

- (NSString*)itemType {
    return @"Grocery";
}

- (double)itemCost {
    return itemCost;
}

@end
