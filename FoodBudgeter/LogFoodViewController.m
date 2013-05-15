//
//  LogFoodViewController.m
//  FoodBudgeter
//
//  Created by Akia Vongdara on 5/1/13.
//  Copyright (c) 2013 Akia Vongdara. All rights reserved.
//

#import "LogFoodViewController.h"

@implementation LogFoodViewController

@synthesize segmentedControl, nameField, costField, ingredients, dbManager, nameLabel, foodVC, addItemCommand, ingrdNameField, itemNameField, portionField, unitField, exampleBtn, status,
    ingredientBtn, costLabel;

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

- (IBAction)segmentController:(id)sender {
    // If Recipe
    if( segmentedControl.selectedSegmentIndex == 0 ) {
        [ingredientBtn setHidden: NO];
        [costLabel setHidden: YES];
        [costField setHidden: YES];
    }
    // If Purchased
    else if( segmentedControl.selectedSegmentIndex == 1 ) {
        [ingredientBtn setHidden: YES];
        [costLabel setHidden: NO];
        [costField setHidden: NO];
    
    }
    NSLog(@"Label is %@", [segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]]);
}

#pragma mark add Item

- (BOOL)addItem:(NSString *)itemName withType:(NSString*)itemType withIngredients:(NSMutableArray *)_ingredients withCost:(double)itemCost {
    if ([addItemCommand execute:itemName withType:itemType withIngredients:_ingredients withCost:itemCost]) {
        [self refreshTable];
        status.text = @"Successfully added!";
        return true;
    }
    status.text = @"Error adding item!";
    return false;
}

#pragma mark -


- (IBAction)addButtonClicked:(id)sender {
    [self addItem:nameField.text withType:[segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]] withIngredients:ingredients withCost:[costField.text doubleValue]];
    [self refreshTable];
}

- (void) refreshTable {
    //foodVC.items = [dbManager itemsInDatabase];
    [foodVC.tableView reloadData];
}

- (IBAction)anAction {
    NSLog(@"HI!");
    nameField.hidden = true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // If on the add cooked item screen, create the appropriate view
    if( segmentedControl.selectedSegmentIndex == 0 ) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action: @selector(anAction)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"Show View"
                forState:UIControlStateNormal];
        // CGRectMake( x, y, length, height )
        button.frame = CGRectMake(120, 210.0, 160.0, 40.0);
        //[self.view addSubview:button];
        
        [exampleBtn setHidden: NO];
        [ingredientBtn setHidden: NO];
        [costLabel setHidden: YES];
        [costField setHidden: YES];
        
    }
    // If on the add bought item screen, create the appropriate view
    else if( segmentedControl.selectedSegmentIndex == 1 ) {
        
    }
    /*
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 10, 300, 40);
    [self.view addSubview:label];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"One", @"Two", @"Three", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectContainsPoint(<#CGRect rect#>, <#CGPoint point#>)
                          */
    
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
