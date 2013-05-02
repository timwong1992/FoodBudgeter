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
    UISegmentedControl *segmentedControl;
    UILabel *label;
    sqlite3 *itemDB;
    NSString *databasePath;
}

@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) IBOutlet UITextField *nameField;
@property(nonatomic, strong) IBOutlet UITextField *costField;
@property(nonatomic, strong) NSString *selectedType;
@property(nonatomic, strong) NSArray *ingredients;

- (BOOL)addItem;
- (BOOL)executeStatement:(sqlite3*)database
           withStatement:(const char*) statement
        withErrorMessage:(char*) errMsg;


@end
