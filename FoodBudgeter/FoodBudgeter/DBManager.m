//
//  DBManager.m
//  FoodBudgeter
//
//  Created by Student on 5/3/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

@synthesize logDelegate, viewDelegate;

- (sqlite3*)itemDB {
    return itemDB;
}

- (NSMutableArray *)buildItems {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        
        // prepare query
        sqlite3_stmt *statement;
        
        // run query
        sqlite3_prepare_v2(itemDB, "SELECT * FROM item", -1, &statement, NULL);
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[self numItemsInDatabase]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];        
        // for each found row, create the appropriate object based upon its type
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
            int itemId = sqlite3_column_int(statement, 0);
            NSString *itemName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
            Item *item;
            const char *itemType = (char*)sqlite3_column_text(statement, 2);
            NSDate *itemDate = [formatter dateFromString:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)]];
            NSString *type = [NSString stringWithUTF8String:itemType];
#warning recipe item creation incomplete
            // if type is recipe
            if ([type isEqualToString:@"Recipe"]) {
                item = [[RecipeItem alloc] initWithID:itemId withName:itemName withDate:itemDate];
            }
            // else if type is purchase
            else if ([type isEqualToString:@"Purchase"]) {
                item = [[PurchasedItem alloc] initWithID:itemId withName:itemName withDate:itemDate withCost:[self itemCost:itemId withType:type]];
            }
            // else if type is grocery
#warning grocery item creation incomplete
            else if ([type isEqualToString:@"Grocery"]) {
                //item = [[GroceryItem alloc] initWithID:itemId withName:itemName withDate:itemDate withCost:[self itemCost:itemId] unitAmount:0 unitType:0];
            }
            if (item != nil)
                [items addObject:item];
        }
        
        // database cleanup
        sqlite3_finalize(statement);
        sqlite3_close(itemDB);
        return items;
    }
    
    return nil;
}

- (BOOL)createDatabase {
    NSString *docsDir;
    NSArray *dirPaths;
    
    //get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex: 0];
    
    //build path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"items.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:databasePath] == NO) {
        [self runQuery:"CREATE TABLE IF NOT EXISTS item (itemID INTEGER PRIMARY KEY AUTOINCREMENT, itemName TEXT, itemType TEXT, date DATETIME)"
            onDatabase:itemDB
      withErrorMessage:"Item table creation failed!"];
        
        [self runQuery:"CREATE TABLE IF NOT EXISTS recipe (recipeID INTEGER PRIMARY KEY, FOREIGN KEY(recipeID) REFERENCES item(itemID))"
            onDatabase:itemDB
      withErrorMessage:"Recipe table creation failed!"];
        
        [self runQuery:"CREATE TABLE IF NOT EXISTS purchase (purchaseID INTEGER PRIMARY KEY, itemCost DOUBLE, FOREIGN KEY(purchaseID) REFERENCES item(itemID))"
            onDatabase:itemDB
      withErrorMessage:"Purchase table creation failed!"];
        
        [self runQuery:"CREATE TABLE IF NOT EXISTS grocery (groceryID INTEGER PRIMARY KEY, itemCost DOUBLE, unitAmount DOUBLE, unitType TEXT, FOREIGN KEY(groceryID) REFERENCES item(itemID))" onDatabase:itemDB withErrorMessage:"Grocery table creation failed!"];
        
        [self runQuery:"CREATE TABLE IF NOT EXISTS ingredient (ingredientID INTEGER PRIMARY KEY AUTOINCREMENT, ingredientName TEXT, ingredientCost DOUBLE)"
            onDatabase:itemDB
      withErrorMessage:"Ingredient table creation failed!"];
        
        [self runQuery:"CREATE TABLE IF NOT EXISTS recipe_ingredient (recipeID INTEGER, ingredientID INTEGER, ingredientServings DOUBLE, PRIMARY KEY(recipeID, ingredientID), FOREIGN KEY(recipeID) REFERENCES recipe(recipeID), FOREIGN KEY(ingredientID) REFERENCES ingredient(ingredientID))"
            onDatabase:itemDB
      withErrorMessage:"Recipe_Ingredient table creation failed!"];
        
        return true;
    }
    return false;
}

- (int)runQuery:(const char *)query onDatabase:(sqlite3 *)database withErrorMessage:(char *)errMsg {
    int status = -1;
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        status = sqlite3_exec(database, query, NULL, NULL, &errMsg);
        if (status != SQLITE_OK ) {
            NSLog(@"Error: %s", errMsg);
        }
        sqlite3_close(database);
    }
    return status;
}

#pragma mark add Item

- (BOOL)addItem:(Item*)item {
    if ([self itemID:item.itemName] != -1) {
        NSLog(@"item was found in db");
        return false;
    }
    NSString *insertQuery;
    //create add query
    insertQuery = [item createAddDBQuery];
    NSLog(@"first query: %@", insertQuery);
    
    if ([self runQuery:[insertQuery UTF8String] onDatabase:itemDB withErrorMessage:"Insert into item failed!"] != SQLITE_OK) {
        return false;
    }
    
    // add item data to other tables, depending on item type
    /*
     if ([itemType isEqualToString:@"Recipe"]) {
     insertQuery = [NSString stringWithFormat:@"INSERT INTO recipe (recipeID) VALUES (\"%d\")", [self itemID:itemName]];
     [self runQuery:[insertQuery UTF8String] onDatabase:itemDB withErrorMessage:"Recipe insert failed!"];
     
     int recipeID = [self itemID:itemName];
     // for each ingredient in item data
     for (int i = 0; i < [self numIngredientsInRecipe:recipeID]; i++) {
     if ([self ingredientID:itemName] != -1)
     insertQuery = [NSString stringWithFormat:@"INSERT INTO recipe_ingredient (recipeID, ingredientID) VALUES (\"%d\", \"%d\")", recipeID, [self ingredientID:itemName]];
     [self runQuery:[insertQuery UTF8String] onDatabase:itemDB withErrorMessage:"Join table insert failed!"];
     }
     // check ingredient table for the ingredient
     // if not found, add ingredient into table
     // add join table entry by getting id's from recipe and ingredient tables
     
     //insertQuery = [NSString stringWithFormat:@""];
     }
     */
    // if not recipe, must be purchase
    //   else {
    
    NSLog(@"Purchase being added to purchase table");
    // set item ID of item object based on what id DB assigned
    item.itemId = [self itemID:item.itemName];
    
    // run subquery based on item type
    insertQuery = [item createAddSubtableQuery];
    
    if ([self runQuery:[insertQuery UTF8String] onDatabase:itemDB withErrorMessage:"Purchase insert failed!"] != SQLITE_OK) {
        return false;
    }
    return true;
}

- (BOOL)addIngredient:(NSString *)ingredientName
             withCost:(double)ingredientCost {
    if ([self ingredientID:ingredientName] != -1) {
        NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO ingredient (ingredientName, ingredientCost) VALUES (\"%@\", \"%.2f\")", ingredientName, ingredientCost];
        if ([self runQuery:[insertQuery UTF8String] onDatabase:itemDB withErrorMessage:"Ingredient insert failed!"] == SQLITE_OK) {
            return true;
        }
    }
    return false;
}

#pragma mark -

#pragma mark retrieving item data

- (int)numItemsInDatabase {
    int count = 0;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        // prepare query
        sqlite3_stmt *statement;
        
        // run query
        sqlite3_prepare(itemDB, "SELECT COUNT(*) FROM item", -1, &statement, NULL);
        
        // if it finds a row, clean up and return the ID for that row
        if(sqlite3_step(statement) == SQLITE_ROW) {
            count = sqlite3_column_int(statement, 0);
        }
        
        // database cleanup
        sqlite3_finalize(statement);
        sqlite3_close(itemDB);
    }
    return count;
}

/*
- (NSMutableArray*)itemsInDatabase {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        NSMutableArray *items = [[NSMutableArray alloc]init];
        
        // prepare query
        sqlite3_stmt *statement;
        
        // run query
        sqlite3_prepare(itemDB, "SELECT itemName FROM item", -1, &statement, NULL);
        
        // if it finds a row, clean up and return the ID f
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *result = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 0)];
            [items addObject:result];
        }
        
        // database cleanup
        sqlite3_finalize(statement);
        sqlite3_close(itemDB);
        return items;
    }
    return nil;
}
 */

- (int)itemID:(NSString *)itemName {
    int result = -1;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        // prepare query
        sqlite3_stmt *statement;
        NSString *query = [NSString stringWithFormat:@"SELECT itemID FROM item WHERE itemName = \"%@\"", itemName];
        
        // run query
        sqlite3_prepare(itemDB, [query UTF8String], -1, &statement, NULL);
        
        // if it finds a row, clean up and return the ID for that row
        if(sqlite3_step(statement) == SQLITE_ROW) {
            result = sqlite3_column_int(statement, 0);
        }
        
        // database cleanup
        sqlite3_finalize(statement);
        sqlite3_close(itemDB);
    }
    return result;
    
}

- (int)ingredientID:(NSString *)ingredientName {
    int result = -1;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        // prepare query
        sqlite3_stmt *statement;
        NSString *query = [NSString stringWithFormat:@"SELECT ingredientID FROM ingredients WHERE ingredientName = \"%@\"", ingredientName];
        
        // run query
        sqlite3_prepare(itemDB, [query UTF8String], -1, &statement, NULL);
        
        // if it finds a row, clean up and return the ID for that row
        if(sqlite3_step(statement) == SQLITE_ROW) {
            result = sqlite3_column_int(statement, 0);
        }
        
        // database cleanup
        sqlite3_finalize(statement);
        sqlite3_close(itemDB);
    }
    return result;
}

- (int)numIngredientsInRecipe:(int)itemID {
    int result = 0;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        // prepare query
        sqlite3_stmt *statement;
        NSString *query = [NSString stringWithFormat:@"SELECT ingredientID FROM recipe_ingredients WHERE recipeID = \"%d\"", itemID];
        
        // run query
        sqlite3_prepare(itemDB, [query UTF8String], -1, &statement, NULL);
        
        // increment result for each entry
        while (sqlite3_step(statement) == SQLITE_ROW) {
            result++;
        }
        
        // database cleanup
        sqlite3_finalize(statement);
        sqlite3_close(itemDB);
    }
    return result;
}

- (NSString *)itemType:(int)itemID {
    NSString *type;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        // prepare query
        sqlite3_stmt *statement;
        
        NSString *query = [NSString stringWithFormat:@"SELECT itemType FROM items WHERE itemID = \"%d\"", itemID];
        
        // run query
        sqlite3_prepare(itemDB, [query UTF8String], -1, &statement, NULL);
        
        // increment result for each entry
        if (sqlite3_step(statement) == SQLITE_ROW) {
            type = [NSString stringWithUTF8String:sqlite3_column_text16(statement, 0)];
        }
        
        // database cleanup
        sqlite3_finalize(statement);
        sqlite3_close(itemDB);
    }
    return type;
}

- (double)itemCost:(int)itemID withType:(NSString*)itemType{
    double cost = 0;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        // prepare query
        sqlite3_stmt *statement;
        NSString *query;
        
        if ([itemType isEqualToString:@"Recipe"]) {
            query = [NSString stringWithFormat:@"SELECT itemCost FROM recipe_ingredients WHERE recipeID = \"%d\"", itemID];
        }
        else if ([itemType isEqualToString:@"Purchase"]) {
            query = [NSString stringWithFormat:@"SELECT itemCost FROM purchase WHERE purchaseID = \"%d\"", itemID];
        }
        else if ([itemType isEqualToString:@"Grocery"]) {
            query = [NSString stringWithFormat:@"SELECT itemCost FROM grocery WHERE groceryID = \"%d\"", itemID];
        }
        
        // run query
        sqlite3_prepare(itemDB, [query UTF8String], -1, &statement, NULL);
        
        // increment result for each entry
        if (sqlite3_step(statement) == SQLITE_ROW) {
            cost = sqlite3_column_double(statement, 0);
        }
        
        // database cleanup
        sqlite3_finalize(statement);
        sqlite3_close(itemDB);
    }
    return cost;
    
}

#pragma mark -

#pragma mark removing items

- (BOOL)removeItem:(NSString *)itemName {
    // get item ID in order to find it in other tables
    int itemID = [self itemID:itemName];
    if (itemID != -1) {
        // delete the item
        NSString *query = [NSString stringWithFormat:@"DELETE FROM item WHERE item.itemName = \"%@\"", itemName];
        
        if ([self runQuery:[query UTF8String] onDatabase:itemDB withErrorMessage:"Deleting from Item table failed"] != SQLITE_OK) {
            return false;
        }
#warning only works for purchase at the moment, must add in support for recipe
        NSLog(@"Deleting from item table success");
        
        query = [NSString stringWithFormat:@"DELETE FROM purchase WHERE purchaseID = %d", itemID];
        if ([self runQuery:[query UTF8String] onDatabase:itemDB withErrorMessage:"Deleting from Purchase table failed"] == SQLITE_OK) {
            NSLog(@"Deleting from purchase table success");
            return true;
        }
        
    }
    // item does not exist, so do nothing
    return false;
}

- (BOOL)removeIngredient:(NSString *)ingredientName {
    // get ingredient ID to check if it exists
    int ingredientID = [self ingredientID:ingredientName];
    if (ingredientID != -1) {
        // delete the ingredient
        NSString *query = [NSString stringWithFormat:@"DELETE FROM ingredients WHERE ingredientName = \"%@\"", ingredientName];
        
        if ([self runQuery:[query UTF8String] onDatabase:itemDB withErrorMessage:"Deleting from Item table failed"] != SQLITE_OK) {
            return false;
        }
    }
    // item does not exist, so do nothing
    return false;
}

@end
