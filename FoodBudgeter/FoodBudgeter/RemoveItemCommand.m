//
//  AddItemCommand.m
//  FoodBudgeter
//
//  Created by Tim Wong on 5/6/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "RemoveItemCommand.h"

@implementation RemoveItemCommand

- (void)execute:(Item*)item {
    [[super itemManager] removeItem:item];
}

@end
