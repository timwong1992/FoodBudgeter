//
//  PurchasedItem.h
//  FoodBudgeter
//
//  Created by Student on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchasedItem : NSObject

@property(nonatomic, assign) double itemCost;       // Cost of the item, $2.30
@property(nonatomic, assign) NSInteger itemId;      // The identification
@property(nonatomic, strong) NSString *itemName;    // American Cheese

@end
