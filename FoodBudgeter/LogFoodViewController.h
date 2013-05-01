//
//  LogFoodViewController.h
//  FoodBudgeter
//
//  Created by Akia Vongdara on 5/1/13.
//  Copyright (c) 2013 Akia Vongdara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogFoodViewController : UIViewController {
    UISegmentedControl *segmentedControl;
    UILabel *label;
}

@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) IBOutlet UILabel *label;
@end
