//
//  Ingredient.h
//  FoodBudgeter
//
//  Created by Student on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ingredient : NSObject

@property(nonatomic, assign) double portion;        // Amount of the item used, 4/16 of a 16oz can
@property(nonatomic, assign) NSString *unitType;    // oz, lbs, slices
@property(nonatomic, strong) NSString *ingredientName; // ex. chicken breast

@end
