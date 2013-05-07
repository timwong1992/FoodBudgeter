//
//  DBManager.h
//  FoodBudgeter
//
//  Created by Student on 5/3/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "sqlite3.h"
#import "Item.h"
#import "RecipeItem.h"
#import "PurchasedItem.h"
#import "GroceryItem.h"

@class DBManager;

@protocol DBDelegate <NSObject>

@optional
- (void)databaseHasBeenUpdated;

@end

@interface DBManager : NSObject {
    NSString *databasePath;
    sqlite3 *itemDB;
}

@property (nonatomic, assign) id<DBDelegate> logDelegate;
@property (nonatomic, assign) id<DBDelegate> viewDelegate;

-(BOOL)createDatabase;

- (sqlite3*)itemDB;

/*
 Runs a query and returns its status.
 */
- (int) runQuery:(const char *)query
      onDatabase:(sqlite3 *)database
withErrorMessage:(char *)errMsg;

/*
 Given item data, adds it to the database. Returns false if the item is a duplicate or the database is not changed.
 */
- (BOOL)addItem:(NSString*)itemName
       withType:(int)itemType
withIngredients:(NSMutableArray*)ingredients
       withCost:(double)itemCost;

/*
 Given ingredient data, adds it to the database. Returns false if the ingredient is a duplicate or the database is not changed.
 */
- (BOOL)addIngredient:(NSString *)ingredientName
             withCost:(double)ingredientCost;

/*
 Returns the number of items in the database.
 */
- (int)numItemsInDatabase;

/*
 Returns an array of item names from the database.
 */
- (NSMutableArray*)itemsInDatabase;

/*
 Given item data, remove it from database. Returns false if the database is not changed.
 */
- (BOOL)removeItem:(NSString*)itemName;

/*
 Given ingredient data, remove it from the database. Returns false if the database is not changed.
 */
- (BOOL)removeIngredient:(NSString *)ingredientName;


/*
 Given a name, searches for the item in the database and returns its unique itemID.
 Returns -1 if the item is not found.
 */
- (int)itemID:(NSString *)itemName;

@end
