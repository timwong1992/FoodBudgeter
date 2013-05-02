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
        NSString *docsDir;
        NSArray *dirPaths;
        
        //get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex: 0];
        
        //build path to the datbase file
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"items.db"]];
        NSFileManager *filemgr = [NSFileManager defaultManager];
        if ([filemgr fileExistsAtPath:databasePath] == NO) {
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
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
                
            } else {
                NSLog(@"Failed to open/create database");
            }
        }
    }
    return self;
}

#pragma mark add Item

- (void)retrieveItemData {
    NSString *itemName = nameField.text;
    int itemType = segmentedControl.selectedSegmentIndex;
    double itemCost = [costField.text doubleValue];
    [self addItem:itemName withType:itemType withIngredients:nil withCost:itemCost];
}

- (BOOL)addItem:(NSString *)itemName withType:(int)itemType withIngredients:(NSArray *)ingredients withCost:(double)itemCost {
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
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
        
        const char *insert_stmt = [insertQuery UTF8String];
        [self runQuery:insert_stmt onDatabase:itemDB withErrorMessage:"Insert failed!"];
        
        // add item data to other tables, depending on item type
        if (itemType == 0) {
            insertQuery = [NSString stringWithFormat:@"INSERT INTO item (itemName, itemType) VALUES (\"%@\", \"%@\")", itemName, @"recipe"];
            insert_stmt = [insertQuery UTF8String];
            [self runQuery:insert_stmt onDatabase:itemDB withErrorMessage:"Insert failed!"];
            
            // for each ingredient in item data
            // check ingredient table for the ingredient
            // if not found, add ingredient into table
            // add join table entry by getting id's from recipe and ingredient tables
            
            //insertQuery = [NSString stringWithFormat:@""];
        }
        // if itemtype is not 0 then it must be 1
        else {
            if(![self isItemInDatabase:itemName]) {
                NSLog(@"Object is new");
                insertQuery = [NSString stringWithFormat:@"INSERT INTO purchase (itemCost) VALUES (\"%.2f\")", itemCost];
                insert_stmt = [insertQuery UTF8String];
                [self runQuery:insert_stmt onDatabase:itemDB withErrorMessage:"Insert failed!"];
            }else {
                NSLog(@"Object was found");
                sqlite3_close(itemDB);
                return false;
            }
        }
        
        // reset view fields
        nameField.text = @"";
        costField.text = @"";
        
        sqlite3_close(itemDB);
        
        return true;
    }
    
    return false;
}

#pragma mark -
- (BOOL)isItemInDatabase:(NSString *)itemName {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement = NULL;
    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        NSString *retrievalQuery = [NSString stringWithFormat:@"SELECT item.itemName FROM item JOIN purchase ON item.itemID = purchase.purchaseID WHERE item.itemName = \"%@\"", itemName];
        const char *retrieve_stmt = [retrievalQuery UTF8String];
        if ([self runQuery:retrieve_stmt onDatabase:itemDB withErrorMessage:"Retrieval failed!"] == SQLITE_OK) {
            sqlite3_prepare(itemDB, retrieve_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_ROW)
                sqlite3_finalize(statement);
            sqlite3_close(itemDB);
            return true;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(itemDB);
    return false;
}

- (BOOL)getItem:(NSString *)itemName {
    /*
    sqlite3_prepare_v2(itemDB, query_stmt, -1, &statement, NULL);
    while( sqlite3_step(statement) == SQLITE_ROW) {
        NSString *addressField = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
        
        NSString *phoneField = [[NSString alloc] initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 1)];
        //code to do something with extracted data here
    }
    sqlite3_finalize(statement);
     */

}

- (BOOL)removeItem:(NSString *)itemName {
    sqlite3_stmt  *statement;
    // get item ID in order to find it in other tables
    
    // delete the item
    NSString *query = [NSString stringWithFormat:@"DELETE FROM item WHERE item.itemName = \"%@\"", itemName];
    if ([self runQuery:[query UTF8String] onDatabase:itemDB withErrorMessage:"Insert failed!"]) {
        
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
    int status = sqlite3_exec(database, query, NULL, NULL, &errMsg);
    if (status != SQLITE_OK ) {
        NSLog(@"%s", errMsg);
    }
    // for retrievals
    if (status == SQLITE_ROW) {
        NSLog(@"Found!");
    }
    return status;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
