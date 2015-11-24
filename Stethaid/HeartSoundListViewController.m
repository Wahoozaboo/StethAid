//
//  HeartSoundListViewController.m
//  Stethaid
//
//  Created by Administrator on 4/9/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

#import "HeartSoundListViewController.h"
#import "HeartSoundItem.h"
#import "HeartSoundList.h"
#import "PlaybackViewController.h"

@interface HeartSoundListViewController ()


@end

@implementation HeartSoundListViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    
    //NSLog(@"Tableview called VIEWDIDLOAD");
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [[[HeartSoundList sharedList] allItems] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    //Set the text on the cell for the nth item
    NSArray *items = [[HeartSoundList sharedList] allItems];
    HeartSoundItem *item = items[indexPath.row];
    
    cell.textLabel.text = item.patientName;
    cell.detailTextLabel.text = item.subtitle;
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *items = [[HeartSoundList sharedList] allItems];
        HeartSoundItem *item = items[indexPath.row];
        [[HeartSoundList sharedList] removeItem:item];
        
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    NSLog(@"The current segue: %@", [segue destinationViewController]);
    
    NSLog(@"Preparing for segue");
    
    if ([[segue identifier] isEqualToString:@"showPlaybackVC"])
    {
        
        NSLog(@"Preparing for seque and postively IDed");
        PlaybackViewController *playbackVC = [segue destinationViewController];
        
        //if segue.identifier == "PickGame" {
          //  let gamePickerViewController = segue.destinationViewController as GamePickerViewController
          //  gamePickerViewController.selectedGame = game
        //}
        
        //Push it onto the top of the navigation controller's stack
        //[self.navigationController pushViewController:playbackVC animated:YES];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        
        // Pass the selected object to the new view controller.
        NSArray *items = [[HeartSoundList sharedList] allItems];
        HeartSoundItem *selectedItem = items[indexPath.row];
        
        //Give PlaybackVC a pointer to the item object in row
        playbackVC.HSitem = selectedItem;
    }
    }



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Called didSelectRowAtIndexPath -- HOORAY");
    //PlaybackViewController *playbackVC = [[PlaybackViewController alloc] init];
    
    PlaybackViewController *playbackVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SBplaybackVC"];
    
    //Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:playbackVC animated:YES];
    
    NSArray *items = [[HeartSoundList sharedList] allItems];
    HeartSoundItem *selectedItem = items[indexPath.row];
    
    //Give PlaybackVC a pointer to the item object in row
    playbackVC.HSitem = selectedItem;
}


- (void)selectedHeartSound:(id)sender
{
    
}

@end
