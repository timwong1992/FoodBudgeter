//
//  LogFoodViewController.h
//  FoodBudgeter
//
//  Created by Akia Vongdara on 5/1/13.
//  Copyright (c) 2013 Akia Vongdara. All rights reserved.
//


@protocol AddItemProtocol <NSObject>

- (void)update;

@end

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "sqlite3.h"
#import "DBManager.h"
#import "ItemManager.h"
#import "FoodTableViewController.h"
#import "RemoveItemCommand.h"

@interface LogFoodViewController : UIViewController <UIGestureRecognizerDelegate>

@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel, *costLabel, *portionLabel, *unitLabel, *status;
@property(nonatomic, strong) IBOutlet UITextField *nameField, *costField, *ingrdNameField, *portionField, *unitField;
@property(nonatomic, strong) IBOutlet UIButton *exampleBtn, *ingredientBtn;

@property(nonatomic, strong) NSArray *ingredients;
@property(nonatomic, strong) ItemManager *itemManager;
@property(nonatomic, strong) RemoveItemCommand *removeItemCommand;

// temp reference to food table vc
//@property(nonatomic, strong) FoodTableViewController *foodVC;
@property(nonatomic, strong) id<AddItemProtocol> delegate;

- (IBAction)addButtonClicked:(id)sender;
- (IBAction)segmentController:(id)sender;
- (IBAction)anAction;

/*
 Creates and adds a RecipeItem object
 */
- (BOOL)addRecipeItem:(NSString*)itemName
      withIngredients:(NSMutableArray*)ingredients;
/*
 Creates and adds a GroceryItem object
 */
- (BOOL)addGroceryItem:(NSString*)itemName
              withCost:(double)itemCost
        withUnitAmount:(double)unitAmount
          withUnitType:(NSString*)unitType;

/*
 Creates and adds a PurchaseItem object
 */
- (BOOL)addPurchaseItem:(NSString*)itemName
               withCost:(double)itemCost;

//- (IBAction)showExample:(id)sender;
//- (void) hidePurchaseView;
@end
