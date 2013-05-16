//
//  BudgetControllerViewController.m
//  FoodBudgeter
//
//  Created by Student on 5/15/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "BudgetControllerViewController.h"

@interface BudgetControllerViewController ()

@end

@implementation BudgetControllerViewController

@synthesize textView, itemManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    textView.text = [NSString stringWithFormat:@"You have spent %.2f dollars.", [itemManager totalAmountSpent]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
