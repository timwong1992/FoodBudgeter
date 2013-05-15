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
#import "ItemManager.h"
#import "FoodTableViewController.h"
#import "AddItemCommand.h"
#import "RemoveItemCommand.h"

@interface LogFoodViewController : UIViewController <DBDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel, *costLabel, *portionLabel, *unitLabel, *status;
@property(nonatomic, strong) IBOutlet UITextField *nameField, *costField, *ingrdNameField, *itemNameField, *portionField, *unitField;
@property(nonatomic, strong) IBOutlet UIButton *exampleBtn, *ingredientBtn;

@property(nonatomic, strong) NSArray *ingredients;
@property(nonatomic, strong) ItemManager *itemManager;
@property(nonatomic, strong) AddItemCommand *addItemCommand;
@property(nonatomic, strong) RemoveItemCommand *removeItemCommand;

// temp reference to food table vc
@property(nonatomic, strong) FoodTableViewController *foodVC;

- (IBAction)addButtonClicked:(id)sender;
- (IBAction)segmentController:(id)sender;
- (IBAction)anAction;

/*
 Given item data, adds it to the database. Returns false if the item is a duplicate or the database is not changed.
 */
- (BOOL)addItem:(NSString*)itemName
       withType:(NSString*)itemType
withIngredients:(NSArray*)ingredients
       withCost:(double)itemCost;

//- (IBAction)showExample:(id)sender;
//- (void) hidePurchaseView;
@end
