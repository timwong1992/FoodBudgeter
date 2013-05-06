//
//  AddItemCommand.m
//  FoodBudgeter
//
//  Created by Student on 5/6/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "AddItemCommand.h"

@implementation AddItemCommand

- (void)execute:(NSString*)itemName withType:(int)itemType withIngredients:(NSMutableArray*)_ingredients withCost:(double)itemCost {
    [[super dbManager] addItem:itemName withType:itemType withIngredients:_ingredients withCost:itemCost];
}

@end
