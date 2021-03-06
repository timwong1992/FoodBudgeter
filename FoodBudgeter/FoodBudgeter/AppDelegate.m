//
//  AppDelegate.m
//  FoodBudgeter
//
//  Created by Student on 4/30/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "AppDelegate.h"
#import "DBManager.h"
#import "FoodTableViewController.h"
#import "FoodDetailTableViewController.h"
#import "LogFoodViewController.h"
#import "QueryCommand.h"
#import "BudgetControllerViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    DBManager *dbManager = [[DBManager alloc] init];
    ItemManager *itemManager = [[ItemManager alloc] init];
    itemManager.dbManager = dbManager;
    [dbManager createDatabase];
    [itemManager buildItems];
    
    FoodTableViewController *foodTableVC = [[FoodTableViewController alloc] initWithNibName:@"FoodTableViewController" bundle:nil];
    foodTableVC.itemManager = itemManager;
    foodTableVC.title = @"Items";
    foodTableVC.items = itemManager.items;
    
    LogFoodViewController *logFoodVC = [[LogFoodViewController alloc] initWithNibName:@"LogFoodViewController" bundle:nil];
    logFoodVC.delegate = foodTableVC;
    logFoodVC.itemManager = itemManager;
    
    BudgetControllerViewController *budgetVC = [[BudgetControllerViewController alloc] initWithNibName:@"BudgetControllerViewController" bundle:nil];
    budgetVC.itemManager = itemManager;
    budgetVC.title = @"Budget";
    
    RemoveItemCommand *removeItemCommand = [[RemoveItemCommand alloc] init];
    removeItemCommand.itemManager = itemManager;
    
    foodTableVC.removeItemCommand = removeItemCommand;
    
    UINavigationController *foodNav = [[UINavigationController alloc] initWithRootViewController:foodTableVC];
    UINavigationController *logFoodNav = [[UINavigationController alloc] initWithRootViewController:logFoodVC];
    [foodNav.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [logFoodNav.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [logFoodNav setNavigationBarHidden:YES];
    //logFoodVC.delegate = foodTableVC;
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[foodNav, logFoodNav, budgetVC];
   
    UITabBarItem *listItem = [[UITabBarItem alloc] initWithTitle:@"Items" image:[UIImage imageNamed:@"eye.png"] tag:0];
    UITabBarItem *logItem = [[UITabBarItem alloc] initWithTitle:@"Log Item" image:[UIImage imageNamed:@"AddRecipe.png"] tag:1];
    foodNav.tabBarItem = listItem;
    logFoodVC.tabBarItem = logItem;
    
    self.window.rootViewController = self.tabBarController;
        
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
