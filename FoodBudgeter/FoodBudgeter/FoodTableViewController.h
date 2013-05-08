//
//  FoodTableViewController.h
//  FoodBudgeter
//
//  Created by Student on 5/2/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "ItemManager.h"

@interface FoodTableViewController : UITableViewController

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign)id <ViewItemsProtocol>viewDelegate;

@end
