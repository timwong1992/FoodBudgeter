//
//  RecipeItem.h
//  FoodBudgeter
//
//  Created by Student on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface RecipeItem : Item

@property (nonatomic, strong) NSMutableArray *itemIngredients;

- (id)initWithID:(int)_itemId withName:(NSString*)_itemName withIngredients:(NSMutableArray*)_ingredients;

@end
