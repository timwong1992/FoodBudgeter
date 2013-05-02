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

- (BOOL)addItem {
    return true;
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
            [self executeStatement:itemDB withStatement:sql_stmt withErrorMessage:errMsg];
            
            sql_stmt = "CREATE TABLE IF NOT EXISTS recipe (recipeID INTEGER PRIMARY KEY, FOREIGN KEY(recipeID) REFERENCES item(itemID))";
            [self executeStatement:itemDB withStatement:sql_stmt withErrorMessage:errMsg];
            
            sql_stmt = "CREATE TABLE IF NOT EXISTS purchase (purchaseID INTEGER PRIMARY KEY, itemCost TEXT, FOREIGN KEY(purchaseID) REFERENCES item(itemID))";
            [self executeStatement:itemDB withStatement:sql_stmt withErrorMessage:errMsg];
            
            sql_stmt = "CREATE TABLE IF NOT EXISTS ingredient (ingredientID INTEGER PRIMARY KEY, ingredientName TEXT, ingredientCost DOUBLE)";
            [self executeStatement:itemDB withStatement:sql_stmt withErrorMessage:errMsg];
            
            sql_stmt = "CREATE TABLE IF NOT EXISTS recipe_ingredient (recipeID INTEGER, ingredientID INTEGER, ingredientServings DOUBLE, PRIMARY KEY(recipeID, ingredientID), FOREIGN KEY(recipeID) REFERENCES recipe(recipeID), FOREIGN KEY(ingredientID) REFERENCES ingredient(ingredientID))";
            [self executeStatement:itemDB withStatement:sql_stmt withErrorMessage:errMsg];
            
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
}

- (BOOL) executeStatement:(sqlite3 *)database withStatement:(const char *)statement withErrorMessage:(char*)errMsg {
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
