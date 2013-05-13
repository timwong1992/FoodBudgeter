//
//  Ingredient.m
//  FoodBudgeter
//
//  Created by Student on 5/4/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "Ingredient.h"

@implementation Ingredient

@synthesize ingredientName, unitType, portion;

- (id)initWithIgrdName:(NSString*)_ingrdName withType:(NSString*)_unitType withPortion:(double)_portion {
    self = [super init];
    if (self) {
        self.ingredientName = _ingrdName;
        self.unitType = _unitType;
        self.portion = _portion;
    }
    return self;
}

@end
