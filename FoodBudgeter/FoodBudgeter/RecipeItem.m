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
    
- (id)initWithID:(int)_itemId withName:(NSString*)_itemName withDate:(NSString*)date withIngredients:(NSMutableArray*)_ingredients{
    self = [super initWithID:_itemId withName:_itemName withDate:date];
    if (self) {
        self.itemIngredients = _ingredients;
    }
    return self;
}

- (NSString*)createAddDBQuery {
    return [NSString stringWithFormat:@"INSERT INTO item (itemName, itemType, date) VALUES (\"%@\", \"Recipe\", \"%@\")", self.itemName, [self.dateLogged description]];
}

- (int)numOfProperties {
    return 3;
}

- (NSString*)itemType {
    return @"Recipe";
}

- (double)itemCost {
    return 0;
}

@end
