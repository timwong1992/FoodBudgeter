//
//  FoodTableViewController.h
//  FoodBudgeter
//
//  Created by Student on 5/2/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemManager.h"
#import "FoodDetailTableViewController.h"
#import "RemoveItemCommand.h"
#import "LogFoodViewController.h"

@class FoodTableViewController;

@interface FoodTableViewController : UITableViewController <AddItemProtocol>

@property (nonatomic, strong) ItemManager *itemManager;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) RemoveItemCommand *removeItemCommand;
@property (nonatomic, assign)id <ViewItemsProtocol>viewDelegate;

@end
