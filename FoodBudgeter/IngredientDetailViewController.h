//
//  IngredientDetailViewController.h
//  FoodBudgeter
//
//  Created by Student on 5/14/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemManager.h"

@interface IngredientDetailViewController : UIViewController

@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *unitTypeLabel;
@property(nonatomic, strong) IBOutlet UITextField *portionField;
@property(nonatomic, strong) GroceryItem *grocery;
@property(nonatomic, strong) ItemManager *itemManager;

// Sets the name label and unit type label of the view
-(void) setView:(NSString*)_name unitType:(NSString*)_unitType;
-(IBAction)submitSelected:(id)sender;
@end
