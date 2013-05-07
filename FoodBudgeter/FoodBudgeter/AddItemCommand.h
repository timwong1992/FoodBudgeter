//
//  AddItemCommand.h
//  FoodBudgeter
//
//  Created by Student on 5/6/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryCommand.h"

@interface AddItemCommand : QueryCommand

/*
 override
 */
- (void)execute:(NSString*)itemName withType:(int)itemType withIngredients:(NSMutableArray*)_ingredients withCost:(double)itemCost;

@end