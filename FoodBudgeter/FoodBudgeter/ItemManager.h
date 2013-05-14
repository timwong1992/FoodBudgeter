//
//  ItemManager.h
//  FoodBudgeter
//
//  Created by Student on 5/7/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import "Item.h"
@protocol ViewItemsProtocol <NSObject>
@required
- (void)updateItemInView:(id)item;

@end

@interface ItemManager : NSObject <ViewItemsProtocol>

@property (nonatomic,strong) DBManager *dbManager;
@property (nonatomic,strong) NSMutableArray *items;

+ (id)createItemManager;

/*
 Reads all items from the database and creates its object representation
 To be run at start.
 */
- (BOOL)buildItems;

/*
 Creates and adds an Item object to the array and writes this change to the database.
 */
- (BOOL)addItem:(NSString*)itemName
       withType:(NSString*)itemType
withIngredients:(NSMutableArray*)ingredients
       withCost:(double)itemCost;

/*
 Retrieves an item from the array by its name.
 */
- (Item*)getItemByName:(NSString*)itemName;

/*
 Given an item, remove the item from the array and from the database.
 */
- (BOOL)removeItem:(Item *)item;

- (BOOL)removeItemByName:(NSString *)name;

- (int)numOfItems;

@end
