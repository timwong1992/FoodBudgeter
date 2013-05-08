//
//  ItemManager.h
//  FoodBudgeter
//
//  Created by Student on 5/7/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface ItemManager : NSObject

@property (nonatomic,strong) DBManager *dbManager;
@property (nonatomic,strong) NSMutableArray *items;

/*
 Reads all items from the database and creates its object representation
 To be run at start.
 */
- (BOOL)buildItems;

@end
