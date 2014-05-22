//
//  ItemModelTest.h
//  FoodBudgeter
//
//  Created by Student on 5/13/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ItemManager.h"
#import "DBManager.h"

@interface ItemModelTest : XCTestCase

@property(nonatomic, strong)ItemManager *itemManager;
@property(nonatomic, strong)DBManager *dbManager;

@end
