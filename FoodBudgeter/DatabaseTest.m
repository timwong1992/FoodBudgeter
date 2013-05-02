//
//  DatabaseTest.m
//  FoodBudgeter
//
//  Created by Student on 5/2/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "DatabaseTest.h"

@implementation DatabaseTest

@synthesize logVC;

- (id)init {
    self = [super init];
    if (self) {
        logVC = [[LogFoodViewController alloc] initWithNibName:@"LogFoodViewController" bundle:nil];
    }
    return self;
}
- (void)testDatabaseAddition {
    [self.logVC addItem];
}

@end
