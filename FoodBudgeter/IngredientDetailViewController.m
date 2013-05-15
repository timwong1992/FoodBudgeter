//
//  IngredientDetailViewController.m
//  FoodBudgeter
//
//  Created by Student on 5/14/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "IngredientDetailViewController.h"

@interface IngredientDetailViewController ()

@end

@implementation IngredientDetailViewController

@synthesize nameLabel, portionField, unitTypeLabel;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setView:(NSString*)_name unitType:(NSString*)_unitType
{
    nameLabel.text = _name;
    unitTypeLabel.text = _unitType;
}

@end
