//
//  ItemModelTest.m
//  FoodBudgeter
//
//  Created by Student on 5/13/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "ItemModelTest.h"

@implementation ItemModelTest

@synthesize itemManager;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    itemManager = [[ItemManager alloc] init];
    itemManager.dbManager = [[DBManager alloc] init];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    itemManager.dbManager = nil;
    itemManager = nil;
}

- (void)testPurchase {
    // adding
    STAssertTrue([itemManager addItem:@"Test Food" withType:@"Purchase" withIngredients:nil withCost:10.00], @"Adding item should succeed");
    STAssertEquals([[itemManager items]count], 1, @"Only one item should be in mutable array");
    STAssertEquals([itemManager.dbManager numItemsInDatabase], 1, @"Only one item should be in database");
    
    STAssertFalse([itemManager addItem:@"Test Food" withType:@"Purchase" withIngredients:nil withCost:10.00], @"Adding duplicate item should fail");
    STAssertEquals([[itemManager items]count], 1, @"Only one item should be in mutable array");
    STAssertEquals([itemManager.dbManager numItemsInDatabase], 1, @"Only one item should be in database");
    
    STAssertTrue([itemManager addItem:@"Another test" withType:@"Purchase" withIngredients:nil withCost:20.00], @"Adding second item should succeed");
    STAssertEquals([[itemManager items]count], 2, @"Only two items should be in mutable array");
    STAssertEquals([self.dbManager numItemsInDatabase], 2, @"Only two items should be in database");
    
    // retrieving
    STAssertTrue([itemManager getItemByName:@"Test Food"] != nil, @"Retrieving existing item should succeed");
    STAssertTrue([self.dbManager itemID:@"Test Food"] != -1, @"Retrieving existing item should succeed");
    STAssertFalse([itemManager getItemByName:@"Not food"] != nil, @"Retrieving existing item should succeed");
    STAssertFalse([self.dbManager itemID:@"Not food"] != -1, @"Retrieving nonexistent item should fail");
    
    // removing
    STAssertTrue([itemManager removeItemByName:@"Test Food"], @"Removing existing item should succeed");
    STAssertFalse([itemManager removeItemByName:@"Not Food"], @"Removing existing item should succeed");

    STAssertEquals([[itemManager items]count], 1, @"Only one item should be in mutable array");
    STAssertEquals([self.dbManager numItemsInDatabase], 1, @"Only one item should be in database");
    
    STAssertTrue([itemManager removeItemByName:@"Another test"], @"Removing existing item should succeed");
    
    STAssertEquals([[itemManager items]count], 0, @"No item should be in mutable array");
    STAssertEquals([self.dbManager numItemsInDatabase], 0, @"No item should be in database");
}

@end
