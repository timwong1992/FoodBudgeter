//
//  DatabaseTest.m
//  DatabaseTest
//
//  Created by Student on 5/2/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "DatabaseTest.h"

@implementation DatabaseTest

@synthesize logVC;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    logVC = [[LogFoodViewController alloc] initWithNibName:@"LogFoodViewController" bundle:nil];

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    logVC = nil;
}

- (void)testDatabase {
    // adding
    STAssertTrue([self.logVC addItem:@"Test Food" withType:1 withIngredients:nil withCost:10.00], @"Adding item should succeed");
    STAssertEquals([self.logVC numItemsInDatabase], 1, @"Only one item should be in database");
    STAssertFalse([self.logVC addItem:@"Test Food" withType:1 withIngredients:nil withCost:10.00], @"Adding duplicate item should fail");
    STAssertEquals([self.logVC numItemsInDatabase], 1, @"Only one item should be in database");
    STAssertTrue([self.logVC addItem:@"Another test" withType:1 withIngredients:nil withCost:20.00], @"Adding second item should succeed");
    STAssertEquals([self.logVC numItemsInDatabase], 2, @"Only two items should be in database");
    
    // retrieving
    STAssertTrue([self.logVC itemID:@"Test Food"] != -1, @"Retrieving existing item should succeed");
    STAssertFalse([self.logVC itemID:@"Not food"] != -1, @"Retrieving nonexistent item should fail");
    
    // deleting
    STAssertTrue([self.logVC removeItem:@"Test Food"], @"Removing existing item should succeed");
    STAssertFalse([self.logVC removeItem:@"Not food"], @"Removing nonexistent item should fail");
    STAssertEquals([self.logVC numItemsInDatabase], 1, @"Only one item should be in database");
    STAssertTrue([self.logVC removeItem:@"Another test"], @"Removing existing item should succeed");
    STAssertEquals([self.logVC numItemsInDatabase], 0, @"No item should be in database");

}

@end
