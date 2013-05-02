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

@synthesize segmentedControl, selectedType, nameField, costField, ingredients;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];

    if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
        NSString *insertQuery;
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
        sqlite3_prepare(itemDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to add item");
            return false;
        }

        return true;
    }
    
    return false;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"View loaded");
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
            char *errMsg = NULL;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS item (itemID INTEGER PRIMARY KEY AUTOINCREMENT, itemName TEXT, itemType TEXT)";
            [self createTable:itemDB query:sql_stmt withErrorMessage:errMsg];
            
            sql_stmt = "CREATE TABLE IF NOT EXISTS recipe (recipeID INTEGER PRIMARY KEY, FOREIGN KEY(recipeID) REFERENCES item(itemID))";
            [self createTable:itemDB query:sql_stmt withErrorMessage:errMsg];
            
            sql_stmt = "CREATE TABLE IF NOT EXISTS purchase (purchaseID INTEGER PRIMARY KEY, itemCost TEXT, FOREIGN KEY(purchaseID) REFERENCES item(itemID))";
            [self createTable:itemDB query:sql_stmt withErrorMessage:errMsg];
            
            sql_stmt = "CREATE TABLE IF NOT EXISTS ingredient (ingredientID INTEGER PRIMARY KEY, ingredientName TEXT, ingredientCost DOUBLE)";
            [self createTable:itemDB query:sql_stmt withErrorMessage:errMsg];
            
            sql_stmt = "CREATE TABLE IF NOT EXISTS recipe_ingredient (recipeID INTEGER, ingredientID INTEGER, ingredientServings DOUBLE, PRIMARY KEY(recipeID, ingredientID), FOREIGN KEY(recipeID) REFERENCES recipe(recipeID), FOREIGN KEY(ingredientID) REFERENCES ingredient(ingredientID))";
            [self createTable:itemDB query:sql_stmt withErrorMessage:errMsg];
            
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
}

- (BOOL) createTable:(sqlite3 *)database query:(const char *)statement withErrorMessage:(char*)errMsg {
    if (sqlite3_exec(database, statement, NULL, NULL, &errMsg) != SQLITE_OK ) {
        NSLog(@"Failed to create table");
        return false;
    }
    return true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
