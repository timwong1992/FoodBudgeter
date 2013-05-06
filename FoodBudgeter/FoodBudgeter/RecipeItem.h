//
//  RecipeItem.h
//  FoodBudgeter
//
//  Created by Student on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeItem : NSObject

@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSMutableArray *itemIngredients;

@end
