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

- (id)initWithID:(int)_itemId withName:(NSString*)_itemName withDate:(NSString*)date withCost:(double)cost {
    self = [super initWithID:_itemId withName:_itemName withDate:date];
    if (self) {
        self.itemCost = cost;
    }
    return self;
}

- (NSString*)createAddDBQuery {
    return [NSString stringWithFormat:@"INSERT INTO item (itemName, itemType, date) VALUES (\"%@\", \"Purchase\", \"%@\")", self.itemName, [self.dateLogged description]];
}

- (NSString*)createAddSubtableQuery {
    return [NSString stringWithFormat:@"INSERT INTO purchase (purchaseID, itemCost) VALUES (%ld, \"%.2f\")", (long)self.itemId, self.itemCost];
}

- (NSString*)createRemoveSubtableQuery {
    return [NSString stringWithFormat:@"DELETE FROM purchase WHERE purchaseID = %ld", (long)self.itemId];
}

- (int)numOfProperties {
    return 3;
}

- (NSString*)itemType {
    return @"Purchase";
}

- (double)itemCost {
    return itemCost;
}

@end
