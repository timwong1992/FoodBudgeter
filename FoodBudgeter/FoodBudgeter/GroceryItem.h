//
//  GroceryItem.h
//  FoodBudgeter
//
//  Created by Student on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroceryItem : Item

@property(nonatomic, assign) double itemCost;       // Cost of the item, $2.30
@property(nonatomic, assign) NSInteger unitAmount;  // Amount of units ex. 24 slices, 6 chicken breasts
@property(nonatomic, strong) NSString *unitType;    // ex. lbs, slices, (vegetable)heads, chicken breasts

@end
