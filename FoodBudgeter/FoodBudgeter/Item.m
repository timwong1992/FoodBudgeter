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

- (id)initWithName:(NSString *)_itemName {
    self = [super init];
    if (self) {
        self.itemName = _itemName;
        self.itemId = 0;
    }
    return self;
}

- (id)initWithID:(int)_itemId withName:(NSString*)_itemName {
    self = [super init];
    if (self) {
        self.itemId = _itemId;
        self.itemName = _itemName;
    }
    return self;
}

- (NSString *)createAddDBQuery {
    NSLog(@"this is why it aint working");
    return nil;
}

- (NSString *)createAddSubtableQuery {
    NSLog(@"this is why it aint working");
    return nil;
}

@end
