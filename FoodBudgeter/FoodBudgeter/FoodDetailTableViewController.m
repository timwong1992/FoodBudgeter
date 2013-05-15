//
//  FoodDetailTableViewController.m
//  FoodBudgeter
//
//  Created by Student on 5/2/13.
//  Copyright (c) 2013 Tim Wong, Akia Vongdara. All rights reserved.
//

#import "FoodDetailTableViewController.h"
#import "GroceryItem.h"
#import "RecipeItem.h"

#define ITEM_TYPE 0
#define ITEM_COST 1
#define ITEM_DATE 2
#define OTHER_DATA 3
#define GROCERY_UNIT_AMOUNT 4

@implementation FoodDetailTableViewController

@synthesize item;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [item numOfProperties];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == OTHER_DATA)
        return 2;
    return 1;
}

// This delegate method is called once for each section
- ( NSString  *)tableView:( UITableView  *)tableView titleForHeaderInSection:( NSInteger )section{
    
    NSString  *title;
    switch  (section ) {
        case   ITEM_TYPE :
        {
            title = @"Type";
        }
            break ;
            
        case   ITEM_COST :
        {
            title = @"Cost";
        }
            break ;
        case ITEM_DATE:
        {
            title = @"Date Logged";
        }
        case OTHER_DATA:
        {
            if ([[item itemType] isEqualToString:@"Grocery"]) {
                title = @"Unit Amount and Type (servings)";
            }
            //cell.textLabel.textAlignment = UITextAlignmentCenter;
            //cell.textLabel.text = [NSString stringWithFormat:@"%@",[(GroceryItem*)item unitType]];
            
        }
            break;
    }  // end switch
    return  title;
    
}  // end titleForHeaderInSection

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    switch  (indexPath.section ) {
        case   ITEM_TYPE :
        {
            cell.textLabel.text = [item itemType];
        }
            break ;
            
        case   ITEM_COST :
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%.2f",[item itemCost]];
        }
            break ;
        case ITEM_DATE:
        {
            cell.textLabel.text = [[item dateLogged]description];
        }
        case OTHER_DATA:
        {
            if ([[item itemType] isEqualToString:@"Grocery"]) {
                cell.textLabel.text = [NSString stringWithFormat:@"%.2f",[(GroceryItem*)item unitAmount]];
            }
            else if ([[item itemType] isEqualToString:@"Recipe"]) {
                cell.textLabel.text = @"Ingredients";
            }
            //cell.textLabel.textAlignment = UITextAlignmentCenter;
            //cell.textLabel.text = [NSString stringWithFormat:@"%@",[(GroceryItem*)item unitType]];
            
        }
            break;
    }  // end switch
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     if (
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
