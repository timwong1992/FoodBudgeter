//
//  ItemVisitor.h
//  FoodBudgeter
//
//  Created by Student on 5/7/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "RecipeItem.h"
#import "PurchasedItem.h"
#import "GroceryItem.h"

@protocol ItemVisitor <NSObject>

@required

- (id)visitRecipeItem:(RecipeItem*)item;
- (id)visitPurchasedItem:(PurchasedItem*)item;
- (id)visitGroceryItem:(GroceryItem*)item;

@end
