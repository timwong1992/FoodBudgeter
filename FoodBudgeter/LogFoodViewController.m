//
//  LogFoodViewController.m
//  FoodBudgeter
//
//  Created by Akia Vongdara on 5/1/13.
//  Copyright (c) 2013 Akia Vongdara. All rights reserved.
//

#import "LogFoodViewController.h"

@interface LogFoodViewController ()

@end

@implementation LogFoodViewController

@synthesize segmentedControl, nameField, costField, ingredients;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createDatabase];
    }
    return self;
}

- (BOOL) createDatabase {
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
        if (sqlite3_open([databasePath UTF8String], &itemDB) == SQLITE_OK) {
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS item (itemID INTEGER PRIMARY KEY AUTOINCREMENT, itemName TEXT, itemType TEXT)";
            [self runQuery:sql_stmt onDatabase:itemDB withErrorMessage:"Table creation failed!"];
            
            sql_stmt = "CREATE TABLE IF NOT EXISTS recipe (recipeID INTEGER PRIMARY KEY, FOREIGN KEY(recipeID) REFERENCES item(itemID))";
            [self runQuery:sql_stmt onDatabase:itemDB withErrorMessage:"Table creation failed!"];
            
            sql_stmt = "CREATE TABLE IF NOT EXISTS purchase (purchaseID INTEGER PRIMARY KEY, itemCost TEXT, FOREIGN KEY(purchaseID) REFERENCES item(itemID))";
            [self runQuery:sql_stmt onDatabase:itemDB withErrorMessage:"Table creation failed!"];
            
            sql_stmt = "CREATE TABLE IF NOT EXISTS ingredient (ingredientID INTEGER PRIMARY KEY, ingredientName TEXT, ingredientCost DOUBLE)";
            [self runQuery:sql_stmt onDatabase:itemDB withErrorMessage:"Table creation failed!"];
            
            sql_stmt = "CREATE TABLE IF NOT EXISTS recipe_ingredient (recipeID INTEGER, ingredientID INTEGER, ingredientServings DOUBLE, PRIMARY KEY(recipeID, ingredientID), FOREIGN KEY(recipeID) REFERENCES recipe(recipeID), FOREIGN KEY(ingredientID) REFERENCES ingredient(ingredientID))";
            [self runQuery:sql_stmt onDatabase:itemDB withErrorMessage:"Table creation failed!"];
            sqlite3_close(itemDB);
            return true;
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
    return false;
}

- (int)numItemsInDatabase {
    int count = -1;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        const char *sql_stmt = "SELECT COUNT(*) FROM item";
        [self runQuery:"SELECT COUNT(*) FROM item" onDatabase:itemDB withErrorMessage:"Getting count failed!"];
    }
    return count;
}

#pragma mark add Item

- (BOOL)addItem:(NSString *)itemName withType:(int)itemType withIngredients:(NSArray *)ingredients withCost:(double)itemCost {
    if (![self isItemInDatabase:itemName]) {
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
            // reset view fields
            nameField.text = @"";
            costField.text = @"";
            sqlite3_close(itemDB);
            return true;
        }
        return false;
    }
    NSLog(@"Item was found");
    return false;
}

#pragma mark -
- (BOOL)isItemInDatabase:(NSString *)itemName {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        sqlite3_stmt *statement = NULL;
        NSString *retrievalQuery = [NSString stringWithFormat:@"SELECT itemName FROM item WHERE item.itemName = \"%@\"", itemName];
        const char *retrieve_stmt = [retrievalQuery UTF8String];
        sqlite3_prepare(itemDB, retrieve_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_ROW) {
            sqlite3_finalize(statement);
            sqlite3_close(itemDB);
            return true;
        }
        sqlite3_finalize(statement);
        sqlite3_close(itemDB);
    }
    return false;
}

- (int)itemID:(NSString *)itemName {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        // prepare query
        sqlite3_stmt *statement;
        NSString *query = [NSString stringWithFormat:@"SELECT itemID FROM item WHERE itemName = \"%@\"", itemName];
        
        // run query
        sqlite3_prepare(itemDB, [query UTF8String], -1, &statement, NULL);
        
        // if it finds a row, clean up and return the ID for that row
        if(sqlite3_step(statement) == SQLITE_ROW) {
            int result = sqlite3_column_int(statement, 0);
            sqlite3_finalize(statement);
            sqlite3_close(itemDB);
            return result;
        }
        sqlite3_finalize(statement);
        sqlite3_close(itemDB);
    }
    return -1;
    
}

- (BOOL)removeItem:(NSString *)itemName {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        // get item ID in order to find it in other tables
        int itemID = [self itemID:itemName];
        // delete the item
        NSString *query = [NSString stringWithFormat:@"DELETE FROM item WHERE item.itemName = \"%@\"", itemName];
        if ([self runQuery:[query UTF8String] onDatabase:itemDB withErrorMessage:"Deleting from Item table failed"] == SQLITE_OK) {
#warning only works for purchase at the moment, must add in support for recipe
            NSLog(@"Deleting from item table success");
            query = [NSString stringWithFormat:@"DELETE FROM purchase WHERE purchaseID = %d", itemID];
            if ([self runQuery:[query UTF8String] onDatabase:itemDB withErrorMessage:"Deleting from Purchase table failed"] == SQLITE_OK) {
                NSLog(@"Deleting from purchase table success");
                return true;
            }
        }
    }
    return false;
}

- (IBAction)addButtonClicked:(id)sender {
    [self addItem:nameField.text withType:segmentedControl.selectedSegmentIndex withIngredients:ingredients withCost:[costField.text doubleValue]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"View loaded");
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
