//
//  GroceryTableViewController.h
//  FoodBudgeter
//
//  Created by Student on 5/14/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemManager.h"
#import "GroceryItem.h"
#import "IngredientDetailViewController.h"

@interface GroceryTableViewController : UITableViewController

@property(nonatomic, strong)ItemManager *itemManager;
@property(nonatomic, strong)NSMutableArray *groceries;

@end
