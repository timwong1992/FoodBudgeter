//
//  DatabaseTest.h
//  FoodBudgeter
//
//  Created by Student on 5/2/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>
#import "LogFoodViewController.h"

@interface DatabaseTest : SenTest

@property(nonatomic, strong) LogFoodViewController *logVC;

- (id)init;
- (void)testDatabaseAddition;
- (void)testDatabaseRetrieval;

@end
