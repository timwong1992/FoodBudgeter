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

- (void)testAddition {
    STAssertTrue([self.logVC addItem:@"Test Food" withType:1 withIngredients:nil withCost:10.00], @"Adding item should succeed");
    STAssertFalse([self.logVC addItem:@"Test Food" withType:1 withIngredients:nil withCost:10.00], @"Adding duplicate item should fail");
}

- (void)testRetrieval {
    STAssertEquals([self.logVC getItemID:@"Test Food"], 1, @"Indexes should be the same (1)");
    STAssertTrue([self.logVC isItemInDatabase:@"Test Food"], @"Retrieving item should succeed");
    STAssertFalse([self.logVC isItemInDatabase:@"Not food"], @"Retrieving item should fail");
}

- (void)testRemoval {
    STAssertTrue([self.logVC removeItem:@"Test Food"], @"Removing item should succeed");
    STAssertFalse([self.logVC removeItem:@"dummy food"], @"Removing item should fail");
    //STAssertEquals([self.logVC ])
}

@end
