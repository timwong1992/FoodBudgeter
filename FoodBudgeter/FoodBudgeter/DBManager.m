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

- (BOOL)buildItems {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[self numItemsInDatabase]];
        NSString *itemName;
        int itemId;
        
        // prepare query
        sqlite3_stmt *statement;
        
        // run query
        sqlite3_prepare(itemDB, "SELECT * FROM item", -1, &statement, NULL);
        
        // if it finds a row, clean up and return the ID for that row
        while(sqlite3_step(statement) == SQLITE_ROW) {
            itemId = sqlite3_column_int(statement, 0);
            itemName = [NSString stringWithUTF8String:sqlite3_column_text16(statement, 1)];
            const char *itemType = sqlite3_column_text16(statement, 2);
            // if type is recipe
            if (strcmp(itemType, "recipe")) {
                RecipeItem *recipeItem = [[RecipeItem alloc] initWithID:itemId withName:itemName];
                [items addObject:recipeItem];
            }
            // else if type is purchase
            else if (strcmp(itemType, "purchase")) {
                PurchasedItem *purchasedItem = [[PurchasedItem alloc] initWithID:itemId withName:itemName withCost:0];
            }
            // else if type is grocery
            else if (strcmp(itemType, "grocery")) {
                
            }
            Item *item = [[Item alloc] initWithID:itemId withName:itemName];
            
        }
        
        // database cleanup
        sqlite3_finalize(statement);
        sqlite3_close(itemDB);
        return true;
    }
    
    return false;
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
        [self runQuery:"CREATE TABLE IF NOT EXISTS item (itemID INTEGER PRIMARY KEY AUTOINCREMENT, itemName TEXT, itemType TEXT)"
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
        // for retrievals
        if (status == SQLITE_ROW) {
            NSLog(@"Found!");
        }
        sqlite3_close(database);
    }
    return status;
}

#pragma mark add Item

- (BOOL)addItem:(NSString *)itemName withType:(int)itemType withIngredients:(NSMutableArray *)ingredients withCost:(double)itemCost {
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
            // if itemtype is not 0 then it must be 1
            else {
                insertQuery = [NSString stringWithFormat:@"INSERT INTO purchase (purchaseID, itemCost) VALUES (%d, \"%.2f\")", [self itemID:itemName], itemCost];
                if ([self runQuery:[insertQuery UTF8String] onDatabase:itemDB withErrorMessage:"Purchase insert failed!"] != SQLITE_OK) {
                    return false;
                }
            }
            return true;
        }
        return false;
    }
    NSLog(@"Item was found");
    return false;
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

- (double)itemCost:(int)itemID {
    double cost = 0;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        // prepare query
        sqlite3_stmt *statement;
        NSString *query;
        
        // get item type from database
        NSString *itemType = [self itemType:itemID];
        
        if ([itemType isEqualToString:@"purchase"]) {
            query = [NSString stringWithFormat:@"SELECT itemCost FROM recipe_ingredients WHERE recipeID = \"%d\"", itemID];
        }
        else if ([itemType isEqualToString:@"recipe"]) {
            
        }
        else if ([itemType isEqualToString:@"grocery"]) {
            
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
