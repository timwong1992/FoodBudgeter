//
//  LogFoodViewController.h
//  FoodBudgeter
//
//  Created by Akia Vongdara on 5/1/13.
//  Copyright (c) 2013 Akia Vongdara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "sqlite3.h"
#import "DBManager.h"

@interface LogFoodViewController : UIViewController <DBDelegate>

@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) IBOutlet UITextField *nameField;
@property(nonatomic, strong) IBOutlet UITextField *costField;
@property(nonatomic, strong) NSArray *ingredients;
@property(nonatomic, strong) DBManager *dbManager;

- (IBAction)addButtonClicked:(id)sender;
- (IBAction)segmentChanged:(id)sender;

/*
 Given item data, adds it to the database. Returns false if the item is a duplicate or the database is not changed.
 */
- (BOOL)addItem:(NSString*)itemName
       withType:(int)itemType
withIngredients:(NSArray*)ingredients
       withCost:(double)itemCost;

/*
 Given item data, remove it from database. Returns false if the database is not changed.
 */
- (BOOL)removeItem:(NSString*)itemName;

/*
 Given a name, searches for the item in the database and returns its unique itemID.
 Returns -1 if the item is not found.
 */
- (int)itemID:(NSString *)itemName;

/*
 Returns the number of items in the database.
 */
- (int)numItemsInDatabase;




@end
