//
//  DatabaseTest.m
//  DatabaseTest
//
//  Created by Student on 5/2/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "DatabaseTest.h"

@implementation DatabaseTest

@synthesize dbManager;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    dbManager = [[DBManager alloc] init];
    [dbManager createDatabase];

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    dbManager = nil;
}

// Run the tests only if hardware to be tested on does not have the app installed.
- (void)testPurchase {
    // adding
    STAssertTrue([self.dbManager addItem:@"Test Food" withType:1 withIngredients:nil withCost:10.00], @"Adding item should succeed");
    STAssertEquals([self.dbManager numItemsInDatabase], 1, @"Only one item should be in database");
    STAssertFalse([self.dbManager addItem:@"Test Food" withType:1 withIngredients:nil withCost:10.00], @"Adding duplicate item should fail");
    STAssertEquals([self.dbManager numItemsInDatabase], 1, @"Only one item should be in database");
    STAssertTrue([self.dbManager addItem:@"Another test" withType:1 withIngredients:nil withCost:20.00], @"Adding second item should succeed");
    STAssertEquals([self.dbManager numItemsInDatabase], 2, @"Only two items should be in database");
    
    // retrieving
    STAssertTrue([self.dbManager itemID:@"Test Food"] != -1, @"Retrieving existing item should succeed");
    STAssertFalse([self.dbManager itemID:@"Not food"] != -1, @"Retrieving nonexistent item should fail");
    
    // dbManagereting
    STAssertTrue([self.dbManager removeItem:@"Test Food"], @"Removing existing item should succeed");
    STAssertFalse([self.dbManager removeItem:@"Not food"], @"Removing nonexistent item should fail");
    STAssertEquals([self.dbManager numItemsInDatabase], 1, @"Only one item should be in database");
    STAssertTrue([self.dbManager removeItem:@"Another test"], @"Removing existing item should succeed");
    STAssertEquals([self.dbManager numItemsInDatabase], 0, @"No item should be in database");

}

/*
- (void)testRecipe {
    // initial ingredients
    [self.dbManager addIngredient:@"Tomato" withCost:];
    // adding
    STAssertTrue([self.dbManager addItem:@"Test Recipe" withType:1 withIngredients:<#(NSArray *)#> withCost:<#(double)#>], <#description, ...#>)
}
 */

@end
