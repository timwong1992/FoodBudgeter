//
//  Item.h
//  FoodBudgeter
//
//  Created by Tim Wong on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property(nonatomic, assign) NSInteger itemId;      // The identification
@property(nonatomic, strong) NSString *itemName;    // American Cheese
@property(nonatomic, readonly) NSDate *dateLogged;  // the date logged

- (id)initWithName:(NSString *)_itemName;
- (id)initWithID:(int)_itemId withName:(NSString*)_itemName;

/*
 Abstract method that creates a SQL query to add to the database and returns it.
 */
- (NSString *)createAddDBQuery;

- (NSString *)createAddSubtableQuery;

@end
