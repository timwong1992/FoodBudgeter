//
//  LogFoodViewController.h
//  FoodBudgeter
//
//  Created by Akia Vongdara on 5/1/13.
//  Copyright (c) 2013 Akia Vongdara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface LogFoodViewController : UIViewController {
    sqlite3 *itemDB;
    NSString *databasePath;
}


@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) IBOutlet UITextField *nameField;
@property(nonatomic, strong) IBOutlet UITextField *costField;
@property(nonatomic, strong) NSString *selectedType;
@property(nonatomic, strong) NSArray *ingredients;

- (IBAction)addButtonClicked:(id)sender;
- (IBAction)segmentChanged:(id)sender;

/*
 Retrieves item data from the text fields.
 */
- (void)retrieveItemData;

/*
 Given item data, adds it to the database.
 */
- (BOOL)addItem:(NSString*)itemName
       withType:(int)itemType
withIngredients:(NSArray*)ingredients
       withCost:(double)itemCost;

/*
 Encapsulated table creation function that runs the create table statement
 */
- (BOOL)createTable:(sqlite3*)database
           query:(const char*) statement
        withErrorMessage:(char*) errMsg;


@end
