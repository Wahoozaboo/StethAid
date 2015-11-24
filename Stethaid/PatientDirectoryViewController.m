//
//  PatientDirectoryViewController.m
//  Stethaid
//
//  Created by Administrator on 11/12/15.
//  Copyright © 2015 Sheikh Zayed Institute. All rights reserved.
//

#import "PatientDirectoryViewController.h"

@interface PatientDirectoryViewController ()

//@property (strong) PatientInfoViewController *piVC;

@end

@implementation PatientDirectoryViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self) { UINavigationItem *navItem = self.navigationItem;
    
    // Create a new bar button item that will send // addNewItem: to BNRItemsViewController
    UIBarButtonItem *bbi = [[ UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@ selector( addNewItem:)];
    
    // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
    
    UIBarButtonItem *menu = [[ UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@ selector(segueToMenu:)];
    
        // Set this bar button item as the left item in the navigationItem
        navItem.leftBarButtonItem = menu;
        
        navItem.title = @"Patient Directory";
        
    }
    
    //PatientItem *Johnny = [[PatientDirectory sharedDirectory]  createPatientItem];
    
    //Take the date from picker, convert to string
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"dd-MM-YYYY"];
    //NSString *currDate = [dateFormatter stringFromDate:[[NSDate alloc] init]];
    //Johnny.dateOfCreation = currDate;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    
    //I suppose there will only be one section - a long list of patients, presented as MRNs
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [[[PatientDirectory sharedDirectory] allItems] count];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell_identifier";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    
    //Set the text on the cell for the nth item
    NSArray *items = [[PatientDirectory sharedDirectory] allItems];
    
    
    PatientItem *item = items[indexPath.row];
    NSLog(@"This is the item description: %@", items.description);
    
    cell.textLabel.text = item.mrn;
    cell.detailTextLabel.text = item.dateOfCreation;
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *items = [[PatientDirectory sharedDirectory] allItems];
        PatientItem *item = items[indexPath.row];
        [[PatientDirectory sharedDirectory] removeItem:item];
        
        //Remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    NSLog(@"The current segue: %@", [segue destinationViewController]);
    
    NSLog(@"Preparing for segue");
    
    if ([[segue identifier] isEqualToString:@"showPlaybackVC"])
    {
        
        NSLog(@"Preparing for seque and postively IDed");
        PatientInfoViewController *piVC = [segue destinationViewController];
        
        //if segue.identifier == "PickGame" {
        //  let gamePickerViewController = segue.destinationViewController as GamePickerViewController
        //  gamePickerViewController.selectedGame = game
        //}
        
        //Push it onto the top of the navigation controller's stack
        //[self.navigationController pushViewController:playbackVC animated:YES];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        
        // Pass the selected object to the new view controller.
        NSArray *items = [[PatientDirectory sharedDirectory] allItems];
        PatientItem *selectedItem = items[indexPath.row];
        
        //Give PlaybackVC a pointer to the item object in row
        piVC.item = selectedItem;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Called didSelectRowAtIndexPath -- HOORAY");
    //PlaybackViewController *playbackVC = [[PlaybackViewController alloc] init];
    
    
    PatientInfoViewController *piVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PIVC"];
    
    //Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:piVC animated:YES];
    
    NSArray *items = [[PatientDirectory sharedDirectory] allItems];
    PatientItem *selectedItem = items[indexPath.row];
    
    //Give PlaybackVC a pointer to the item object in row
    piVC.item = selectedItem;
    
    
}

-(IBAction)addNewItem:(id)sender
{
 
    NSLog(@"ADD NEW ITEM CALLED");
    
    //Create a new patient item to add to the directory
    //PatientItem *newPatient = [[ PatientDirectory sharedDirectory] createPatientItem];
    [[ PatientDirectory sharedDirectory] createPatientItem];
    
    //Figure out where that item is in the array
    //NSInteger lastRow = [[[PatientDirectory sharedDirectory] allItems] indexOfObject:newPatient];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //Insert this new row into the table
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

- (IBAction)segueToMenu:(id)sender

{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //WelcomeChoiceViewController *menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MENU"];
    
    //[self.navigationController presentViewController:menuVC animated:YES completion:nil];
}

@end
