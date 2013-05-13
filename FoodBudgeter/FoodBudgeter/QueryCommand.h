//
//  QueryCommand.h
//  FoodBudgeter
//
//  Created by Student on 5/6/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import "ItemManager.h"

@interface QueryCommand : NSObject

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) ItemManager *itemManager;

/*
 Abstract execute method for Concrete Commands
 */
- (void)execute:(NSString*)itemName;

@end
