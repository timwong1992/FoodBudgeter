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
    NSMutableArray *arr = [dbManager buildItems];
    NSLog(@"%d",arr.count);
    [self setItems:[dbManager buildItems]];
    return true;
}

- (BOOL)addItem:(NSString*)itemName withType:(NSString*)itemType withIngredients:(NSMutableArray*)ingredients withCost:(double)itemCost {
    if ([self getItemByName:itemName] != nil) {
        return false;
    }
    Item *item;
    if ([itemType isEqualToString:@"Purchase"]) {
        item = [[PurchasedItem alloc] initWithID:0 withName:itemName withCost:itemCost];
    }
    else if ([itemType isEqualToString:@"Recipe"])
        item = [[RecipeItem alloc] initWithName:itemName];
    else if ([itemType isEqualToString:@"Grocery"])
        item = [[GroceryItem alloc] initWithName:itemName];
    else
        return false;
    [items addObject:item];
    return [dbManager addItem:item];
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
