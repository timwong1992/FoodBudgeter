//
//  IngredientsTableViewController.h
//  FoodBudgeter
//
//  Created by Student on 5/14/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeItem.h"
#import "Ingredient.h"

@interface IngredientsTableViewController : UITableViewController

@property(nonatomic, strong)RecipeItem *recipe;
@property(nonatomic, strong)NSMutableArray *ingredients;

@end
