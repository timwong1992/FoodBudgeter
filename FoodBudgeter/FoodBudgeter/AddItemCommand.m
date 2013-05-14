//
//  AddItemCommand.m
//  FoodBudgeter
//
//  Created by Student on 5/6/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "AddItemCommand.h"

@implementation AddItemCommand

- (BOOL)execute:(NSString*)itemName withType:(NSString*)itemType withIngredients:(NSMutableArray*)_ingredients withCost:(double)itemCost {
    NSLog(@"Command executes");
    return [[super itemManager] addItem:itemName withType:itemType withIngredients:_ingredients withCost:itemCost];
}

@end
