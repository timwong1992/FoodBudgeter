//
//  RecipeItem.h
//  FoodBudgeter
//
//  Created by Student on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "GroceryItem.h"

@interface RecipeItem : Item <ItemProtocol>

@property (nonatomic, strong) NSMutableArray *itemIngredients;

- (id)initWithID:(int)_itemId withName:(NSString*)_itemName withDate:(NSString*)itemDate withIngredients:(NSMutableArray*)_ingredients;

- (double) getCost;
@end
