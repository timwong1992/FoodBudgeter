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
        self.dateLogged = [NSDate date];
    }
    return self;
}

- (id)initWithID:(int)_itemId withName:(NSString*)_itemName{
    self = [super init];
    if (self) {
        self.itemId = _itemId;
        self.itemName = _itemName;
        self.dateLogged = [NSDate date];
    }
    return self;
}

- (id)initWithID:(int)_itemId withName:(NSString *)_itemName withDate:(NSDate*)date {
    self = [super init];
    if (self) {
        self.itemId = _itemId;
        self.itemName = _itemName;
        self.dateLogged = date;
    }
    return self;
}

- (NSString *)createAddDBQuery {
    return nil;
}

- (NSString *)createAddSubtableQuery {
    return nil;
}

- (NSString *)createRemoveSubtableQuery {
    return nil;
}

@end
