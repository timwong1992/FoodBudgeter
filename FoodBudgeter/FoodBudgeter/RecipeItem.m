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
    return 4;
}

<<<<<<< HEAD
- (double)getCost {
    double cost = 0.0;
    
    for( int i = 0; i < [itemIngredients count]; i++) {
        //cost += itemIngredients[i].itemCost * itemIngredients[i].portion / itemIngredients[i].amount;
        cost += [[itemIngredients objectAtIndex:i]itemCost] * [(Ingredient*)[itemIngredients objectAtIndex:i]portion] / [[(Ingredient*)[itemIngredients objectAtIndex:i]grocery]unitAmount];
    }
}
=======
- (NSString*)itemType {
    return @"Recipe";
}

>>>>>>> c4a69d5c9be7f06c6830b5b60113b104ed078c70
@end
