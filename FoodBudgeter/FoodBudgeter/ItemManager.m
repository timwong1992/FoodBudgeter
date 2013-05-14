//
//  ItemManager.m
//  FoodBudgeter
//
//  Created by Student on 5/7/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "ItemManager.h"

@implementation ItemManager

@synthesize dbManager, items;

- (id)init {
    self = [super init];
    if (self) {
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)buildItems {
    [self setItems:[dbManager buildItems]];
    return true;
}

- (BOOL)addItem:(NSString*)itemName withType:(NSString*)itemType withIngredients:(NSMutableArray*)ingredients withCost:(double)itemCost {
    if ([self getItemByName:itemName] == nil) {
        Item *item = [[Item alloc] initWithName:itemName];
        [items addObject:item];
        NSLog(@"num of items %lu", (unsigned long)[items count]);
#warning need to hook up to GUI
        return [dbManager addItem:itemName withType:itemType withIngredients:ingredients withCost:itemCost];
    }
    return false;
}

- (Item*)getItemByName:(NSString*)itemName {
    for (Item *item in items) {
        if ([[item itemName] isEqualToString:itemName]) {
            return item;
        }
    }
    return nil;
}

- (BOOL)removeItem:(Item *)item {
    if ([self.items indexOfObject:item] != -1) {
        [items removeObject:item];
        return true;
    }
    return false;
}

- (BOOL)removeItemByName:(NSString *)name {
    for (Item *item in items) {
        if ([[item itemName] isEqualToString:name]) {
            [items removeObject:item];
            return [dbManager removeItem:name];
        }
    }
    return false;
}

- (int)numOfItems {
    return [items count];
}

@end
