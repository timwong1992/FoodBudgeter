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
    [itemManager.dbManager createDatabase];
    
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
    XCTAssertTrue([itemManager addPurchaseItem:@"Test Food" withCost:10.00], @"Adding item should succeed");
    XCTAssertEqual([itemManager numOfItems], 1, @"Only one item should be in mutable array");
    
    XCTAssertEqual([itemManager.dbManager numItemsInDatabase], 1, @"Only one item should be in database");
    
    XCTAssertFalse([itemManager addPurchaseItem:@"Test Food" withCost:10.00], @"Adding duplicate item should fail");
    XCTAssertEqual([itemManager numOfItems], 1, @"Only one item should be in mutable array");
    XCTAssertEqual([itemManager.dbManager numItemsInDatabase], 1, @"Only one item should be in database");
    
    XCTAssertTrue([itemManager addPurchaseItem:@"Another Food" withCost:10.00], @"Adding item should succeed");
    XCTAssertEqual([itemManager numOfItems], 2, @"Only two items should be in mutable array");
    XCTAssertEqual([itemManager.dbManager numItemsInDatabase], 2, @"Only two items should be in database");
    
    // retrieving
    XCTAssertTrue([itemManager getItemByName:@"Test Food"] != nil, @"Retrieving existing item should succeed");
    XCTAssertTrue([itemManager.dbManager itemID:@"Test Food"] != -1, @"Retrieving existing item should succeed");
    XCTAssertFalse([itemManager getItemByName:@"Not food"] != nil, @"Retrieving existing item should succeed");
    XCTAssertFalse([itemManager.dbManager itemID:@"Not food"] != -1, @"Retrieving nonexistent item should fail");
    
    // removing
    XCTAssertTrue([itemManager removeItemByName:@"Test Food"], @"Removing existing item should succeed");
    XCTAssertFalse([itemManager removeItemByName:@"Not Food"], @"Removing existing item should succeed");

    XCTAssertEqual([itemManager numOfItems], 1, @"Only one item should be in mutable array");
    XCTAssertEqual([itemManager.dbManager numItemsInDatabase], 1, @"Only one item should be in database");
    
    XCTAssertTrue([itemManager removeItemByName:@"Another Food"], @"Removing existing item should succeed");
    
    XCTAssertEqual([itemManager numOfItems], 0, @"No item should be in mutable array");
    XCTAssertEqual([itemManager.dbManager numItemsInDatabase], 0, @"No item should be in database");
     
}

- (void)testBuildingFromDB {
    PurchasedItem *item = [[PurchasedItem alloc] initWithName:@"test food"];
    PurchasedItem *item2 = [[PurchasedItem alloc] initWithName:@"another food"];
    XCTAssertTrue([itemManager.dbManager addItem:item], @"derp");
    XCTAssertTrue([itemManager.dbManager addItem:item2], @"more derp");
    
    XCTAssertEqual([itemManager.dbManager numItemsInDatabase], 2, @"2 items should be in database");
    XCTAssertEqual([itemManager numOfItems], 0, @"No items should exist in object based model");
    [itemManager buildItems];
    XCTAssertTrue([[[[itemManager items]objectAtIndex:0]itemName] isEqualToString:@"test food"], @"names should be the same");
    
    //cleanup
    XCTAssertTrue([itemManager removeItemByName:@"test food"], @"Removing existing item should succeed");
    XCTAssertTrue([itemManager removeItemByName:@"another food"], @"Removing existing item should succeed");
}


@end
