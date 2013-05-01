//
// addPurchaseViewController.h
// addPurchase
//
// Created by Tim Wong on 5/1/13.
// Copyright (c) Tim Wong, Akia Vongdara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface addPurchaseViewController: UIViewController {
	sqlite3 *itemDB;
}

@property (nonatomic, strong) IBOutlet UITextField *itemName;
@property (nonatomic, strong) IBOutlet UITextField *itemCost;
@property (nonatomic, strong) IBOutlet UILabel *dbStatus;

- (IBAction)addItem:(id)sender;