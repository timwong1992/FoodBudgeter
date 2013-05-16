//
//  BudgetControllerViewController.h
//  FoodBudgeter
//
//  Created by Student on 5/15/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemManager.h"

@interface BudgetControllerViewController : UIViewController

@property(nonatomic, strong)ItemManager *itemManager;
@property(nonatomic, strong)IBOutlet UITextView *textView;

@end
