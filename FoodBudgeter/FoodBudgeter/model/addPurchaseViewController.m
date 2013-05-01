//
// addPurchaseViewController.m
// addPurchase
//
// Created by Tim Wong on 5/1/13.
// Copyright (c) Tim Wong, Akia Vongdara. All rights reserved.
//

#import "addPurchaseViewController.h"

@implementation addPurchaseViewController

@synthesize itemName, itemCost

// refactor?
- (void)addItem:(id)sender {
	sqlite3_stmt *statement;
	constg char *dbpath = [databasePath UTF8String];

	if (sqlite3_open(dbpath, &itemDB) == SQLITE_OK) {
		NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO Items (itemName, itemType) VALUES (\"%@\", \"%@\")", itemName.text, @"purchase"];
		const char *insert_stmt = [insertQuery UTF8String];
		sqlite3_prepare(itemDB, insert_stmt, -1, &statement, NULL);
		if (sqlite3_step(statement) != SQLITE_DONE) {
			status.text = @"Failed to add item.";
			#warning may be syntax error
			return;
		} 
		*insertQuery = [NSString stringWithFormat:@"INSERT INTO PurchasedItem (itemCost) VALUES (\"%d\")", [itemCost.text doubleValue]];

		status.text = @"Item added!";
		itemName.text = @"";
		itemCost.text = @"";
		
		sqlite3_finalize(statement);
		sqlite3_close(contactDB);
	}
}