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

@synthesize nameLabel, portionField, unitTypeLabel, grocery, itemManager;

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
    nameLabel.text = grocery.itemName;
    unitTypeLabel.text = grocery.unitType;
    
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

- (IBAction)submitSelected:(id)sender {
    Ingredient *ingredient = [[Ingredient alloc] initWithIgrdName:grocery.itemName withType:grocery.unitType withPortion:[[portionField text]doubleValue]];
    [itemManager.ingredients addObject:ingredient];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
