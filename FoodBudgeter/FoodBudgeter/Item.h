//
//  Item.h
//  FoodBudgeter
//
//  Created by Tim Wong on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ItemProtocol <NSObject>
@required
/*
 Abstract method that creates a SQL query to add to the database and returns it.
 */
- (NSString *)createAddDBQuery;

- (NSString *)createAddSubtableQuery;

@end

@interface Item : NSObject <ItemProtocol>

@property(nonatomic, assign) NSInteger itemId;      // The identification
@property(nonatomic, strong) NSString *itemName;    // American Cheese
@property(nonatomic, strong) NSDate *dateLogged;  // the date logged, in string format

- (id)initWithName:(NSString *)_itemName;
- (id)initWithID:(int)_itemId withName:(NSString*)_itemName;
- (id)initWithID:(int)_itemId withName:(NSString *)_itemName withDate:(NSDate*)date;
/*
 Number of properties the item has. Used to determine how many sections the detail table view has
 */
- (int)numOfProperties;
- (NSString*)itemType;
- (double)itemCost;

@end
