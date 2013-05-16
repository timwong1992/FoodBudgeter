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
#import "PurchasedItem.h"
@protocol ViewItemsProtocol < NSObject>
@required
- (void)updateItemInView:(id)item;

@end

@interface ItemManager : NSObject

@property (nonatomic,strong) DBManager *dbManager;
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) NSMutableArray *ingredients; //ingredients to be added into a recipe


/*
 Reads all items from the database and creates its object representation
 To be run at start.
 */
- (BOOL)buildItems;

/*
 Creates and adds a RecipeItem object to the array and writes this change to the database.
 */
- (BOOL)addRecipeItem:(NSString*)itemName
      withIngredients:(NSMutableArray*)ingredients;
/*
 Creates and adds a GroceryItem object to the array and writes this change to the database.
 */
- (BOOL)addGroceryItem:(NSString*)itemName
              withCost:(double)itemCost
        withUnitAmount:(double)unitAmount
          withUnitType:(NSString*)unitType;

/*
 Creates and adds a PurchaseItem object to the array and writes this change to the database.
 */
- (BOOL)addPurchaseItem:(NSString*)itemName
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

- (NSMutableArray*)retrieveGroceryItems;

@end
