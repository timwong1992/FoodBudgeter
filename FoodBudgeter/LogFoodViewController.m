//
//  LogFoodViewController.m
//  FoodBudgeter
//
//  Created by Akia Vongdara on 5/1/13.
//  Copyright (c) 2013 Akia Vongdara. All rights reserved.
//

#import "LogFoodViewController.h"

@implementation LogFoodViewController

@synthesize segmentedControl, nameField, costField, ingredients, dbManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        tap.delegate = self;
        [self.view addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark add Item

- (BOOL)addItem:(NSString *)itemName withType:(int)itemType withIngredients:(NSArray *)_ingredients withCost:(double)itemCost {
    return [dbManager addItem:itemName withType:itemType withIngredients:_ingredients withCost:itemCost];
}

#pragma mark -


- (IBAction)addButtonClicked:(id)sender {
    [self addItem:nameField.text withType:segmentedControl.selectedSegmentIndex withIngredients:ingredients withCost:[costField.text doubleValue]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"View loaded");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewTapped {
    [nameField resignFirstResponder];
    [costField resignFirstResponder];
}

@end
