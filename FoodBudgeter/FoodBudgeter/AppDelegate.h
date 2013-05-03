//
//  AppDelegate.h
//  FoodBudgeter
//
//  Created by Student on 4/30/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
