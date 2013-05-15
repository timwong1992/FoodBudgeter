//
//  RecipeItem.m
//  FoodBudgeter
//
//  Created by Student on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "RecipeItem.h"

@implementation RecipeItem

@synthesize itemIngredients;
    
- (id)initWithID:(int)_itemId withName:(NSString*)_itemName withIngredients:(NSMutableArray*)_ingredients{
    self = [super initWithID:_itemId withName:_itemName];
    if (self) {
        self.itemIngredients = _ingredients;
    }
    return self;
}

- (NSString*)createAddDBQuery {
    return [NSString stringWithFormat:@"INSERT INTO item (itemName, itemType) VALUES (\"%@\", \"Recipe\")", self.itemName];
}

- (double) getCost {
    for (int i = 0; i < [itemIngredients count]; i++) {
        itemIngredients[i].
    }
    return 0.0;
}
@end
