//
//  RecipeItem.m
//  FoodBudgeter
//
//  Created by Student on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "RecipeItem.h"
#import "Ingredient.h"

@implementation RecipeItem

@synthesize itemIngredients;
    
- (id)initWithID:(int)_itemId withName:(NSString*)_itemName withDate:(NSDate*)date withIngredients:(NSMutableArray*)_ingredients{
    self = [super initWithID:_itemId withName:_itemName withDate:date];
    if (self) {
        self.itemIngredients = _ingredients;
    }
    return self;
}

- (NSString*)createAddDBQuery {
    return [NSString stringWithFormat:@"INSERT INTO item (itemName, itemType, date) VALUES (\"%@\", \"Recipe\", \"%@\")", self.itemName, [self.dateLogged description]];
}

- (NSString*)createAddSubtableQuery {
    return [NSString stringWithFormat:@"INSERT INTO recipe VALUES \"%d\"", self.itemId];
}

- (int)numOfProperties {
    return 3;
}

- (double)getCost {
    double cost = 0.0;
    
    for( int i = 0; i < [itemIngredients count]; i++) {
        //cost += itemIngredients[i].itemCost * itemIngredients[i].portion / itemIngredients[i].amount;
        cost += [[itemIngredients objectAtIndex:i]itemCost] * [(Ingredient*)[itemIngredients objectAtIndex:i]portion] / [[(Ingredient*)[itemIngredients objectAtIndex:i]grocery]unitAmount];
    }
    return cost;
}
- (NSString*)itemType {
    return @"Recipe";
}
@end
