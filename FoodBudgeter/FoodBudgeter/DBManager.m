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

- (BOOL)createDatabase {
    NSString *docsDir;
    NSArray *dirPaths;
    
    //get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex: 0];
    
    //build path to the datbase file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"items.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:databasePath] == NO) {
        NSLog(@"Database being created");
        //if (sqlite3_open([databasePath UTF8String], &itemDB) == SQLITE_OK) {
        [self runQuery:"CREATE TABLE IF NOT EXISTS item (itemID INTEGER PRIMARY KEY AUTOINCREMENT, itemName TEXT, itemType TEXT)"
            onDatabase:itemDB
      withErrorMessage:"Table creation failed!"];
        
        [self runQuery:"CREATE TABLE IF NOT EXISTS recipe (recipeID INTEGER PRIMARY KEY, FOREIGN KEY(recipeID) REFERENCES item(itemID))"
            onDatabase:itemDB
      withErrorMessage:"Table creation failed!"];
        
        [self runQuery:"CREATE TABLE IF NOT EXISTS purchase (purchaseID INTEGER PRIMARY KEY, itemCost TEXT, FOREIGN KEY(purchaseID) REFERENCES item(itemID))"
            onDatabase:itemDB
      withErrorMessage:"Table creation failed!"];
        
        [self runQuery:"CREATE TABLE IF NOT EXISTS ingredient (ingredientID INTEGER PRIMARY KEY, ingredientName TEXT, ingredientCost DOUBLE)"
            onDatabase:itemDB
      withErrorMessage:"Table creation failed!"];
        
        [self runQuery:"CREATE TABLE IF NOT EXISTS recipe_ingredient (recipeID INTEGER, ingredientID INTEGER, ingredientServings DOUBLE, PRIMARY KEY(recipeID, ingredientID), FOREIGN KEY(recipeID) REFERENCES recipe(recipeID), FOREIGN KEY(ingredientID) REFERENCES ingredient(ingredientID))"
            onDatabase:itemDB
      withErrorMessage:"Table creation failed!"];
        
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
        // for retrievals
        if (status == SQLITE_ROW) {
            NSLog(@"Found!");
        }
        sqlite3_close(database);
    }
    return status;
}

#pragma mark add Item

- (BOOL)addItem:(NSString *)itemName withType:(int)itemType withIngredients:(NSArray *)ingredients withCost:(double)itemCost {
    if ([self itemID:itemName] == -1) {
        NSString *insertQuery;
        
        // check what type of item and write appropriate query
        if (itemType == 0) {
            insertQuery = [NSString stringWithFormat:@"INSERT INTO item (itemName, itemType) VALUES (\"%@\", \"%@\")", itemName, @"recipe"];
        }
        else if (itemType == 1) {
            insertQuery = [NSString stringWithFormat:@"INSERT INTO item (itemName, itemType) VALUES (\"%@\", \"%@\")", itemName, @"purchase"];
        }
        else {
            NSLog(@"Item type not valid");
            return false;
        }
        
        if ([self runQuery:[insertQuery UTF8String] onDatabase:itemDB withErrorMessage:"Insert into item failed!"] == SQLITE_OK) {
            NSLog(@"Insert into item success");
            // add item data to other tables, depending on item type
            if (itemType == 0) {
                insertQuery = [NSString stringWithFormat:@"INSERT INTO item (itemName, itemType) VALUES (\"%@\", \"%@\")", itemName, @"recipe"];
                [self runQuery:[insertQuery UTF8String] onDatabase:itemDB withErrorMessage:"Recipe insert failed!"];
                
                // for each ingredient in item data
                // check ingredient table for the ingredient
                // if not found, add ingredient into table
                // add join table entry by getting id's from recipe and ingredient tables
                
                //insertQuery = [NSString stringWithFormat:@""];
            }
            // if itemtype is not 0 then it must be 1
            else {
                insertQuery = [NSString stringWithFormat:@"INSERT INTO purchase (purchaseID, itemCost) VALUES (%d, \"%.2f\")", [self itemID:itemName], itemCost];
                if ([self runQuery:[insertQuery UTF8String] onDatabase:itemDB withErrorMessage:"Purchase insert failed!"] != SQLITE_OK) {
                    return false;
                }
            }
            
            NSLog(@"Insert success");
            sqlite3_close(itemDB);
            return true;
        }
        return false;
    }
    NSLog(@"Item was found");
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

@end
