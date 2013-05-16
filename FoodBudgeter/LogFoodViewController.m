//
//  LogFoodViewController.m
//  FoodBudgeter
//
//  Created by Akia Vongdara on 5/1/13.
//  Copyright (c) 2013 Akia Vongdara. All rights reserved.
//

#import "LogFoodViewController.h"
#import "IngredientsTableViewController.h"

#define RECIPE 0
#define PURCHASE 1
#define GROCERY 2

@implementation LogFoodViewController

@synthesize segmentedControl, nameField, costField, portionLabel, unitLabel, ingredients, nameLabel, foodVC, ingrdNameField, itemNameField, portionField, unitField, exampleBtn, status,
ingredientBtn, costLabel, itemManager;

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
    if( segmentedControl.selectedSegmentIndex == RECIPE ) {
        [ingredientBtn setHidden: NO];
        [costLabel setHidden: YES];
        [costField setHidden: YES];
        [portionField setHidden:YES];
        [portionLabel setHidden:YES];
        [unitField setHidden:YES];
        [unitLabel setHidden:YES];
    }
    // If Purchased
    else if( segmentedControl.selectedSegmentIndex == PURCHASE ) {
        [ingredientBtn setHidden: YES];
        [costLabel setHidden: NO];
        [costField setHidden: NO];
        [portionField setHidden:YES];
        [portionLabel setHidden:YES];
        [unitField setHidden:YES];
        [unitLabel setHidden:YES];
        
    }
    // If Grocery
    else if ( segmentedControl.selectedSegmentIndex == GROCERY ) {
        [ingredientBtn setHidden: YES];
        [costLabel setHidden: NO];
        [costField setHidden: NO];
        [portionField setHidden:NO];
        [portionLabel setHidden:NO];
        [unitField setHidden:NO];
        [unitLabel setHidden:NO];
        
    }
}

#pragma mark add Item

- (BOOL)addPurchaseItem:(NSString *)itemName withCost:(double)itemCost {
    return [itemManager addPurchaseItem:itemName withCost:itemCost];
}

- (BOOL)addRecipeItem:(NSString *)itemName withIngredients:(NSMutableArray *)itemIngredients {
    return [itemManager addRecipeItem:itemName withIngredients:itemIngredients];
}

- (BOOL)addGroceryItem:(NSString *)itemName withCost:(double)itemCost withUnitAmount:(double)unitAmount withUnitType:(NSString *)unitType {
    return [itemManager addGroceryItem:itemName withCost:itemCost withUnitAmount:unitAmount withUnitType:unitType];
}

#pragma mark -


- (IBAction)addButtonClicked:(id)sender {
    BOOL result;
    switch ([segmentedControl selectedSegmentIndex]) {
        case RECIPE:
        {
            result = [self addRecipeItem:itemNameField.text withIngredients:ingredients];
        }
            break;
        case PURCHASE:
        {
            result = [self addPurchaseItem:itemNameField.text withCost:[costField.text doubleValue]];
        }
            break;
        case GROCERY:
        {
            result = [self addGroceryItem:itemNameField.text withCost:[costField.text doubleValue] withUnitAmount:[portionField.text doubleValue] withUnitType:unitField.text];
        }
            
    }
    if (result) {
        [self refreshTable];
        status.text = @"Successfully added!";
    }
    else {
        status.text = @"Error adding item!";
    }
}

- (void) refreshTable {
    [foodVC reloadItems];
}

- (IBAction)anAction {
    IngredientsTableViewController *ingrdTableViewController = [[IngredientsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ingrdTableViewController.title = @"Ingredients";
    [self.navigationController pushViewController:ingrdTableViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // If on the add recipe item screen, create the appropriate view
    
    if( segmentedControl.selectedSegmentIndex == RECIPE ) {
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
    /*
     label = [[UILabel alloc] init];
     label.frame = CGRectMake(10, 10, 300, 40);
     [self.view addSubview:label];
     
     NSArray *itemArray = [NSArray arrayWithObjects: @"One", @"Two", @"Three", nil];
     UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
     segmentedControl.frame = CGRectContainsPoint(<#CGRect rect#>, <#CGPoint point#>)
     */
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:YES];
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