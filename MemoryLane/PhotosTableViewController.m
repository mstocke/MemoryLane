//
//  PhotoTableViewController.m
//  MemoryLane
//
//  Created by tstone10 on 7/26/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "PhotoDetailViewController.h"
#import "User.h"
#import "Photo.h"
@import FirebaseDatabase;
@import Firebase;
@import FirebaseStorage;

@interface PhotosTableViewController ()

@end

@implementation PhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createPhotosArray];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createPhotosArray {
    _photos = [[NSMutableArray alloc] init];
    
    FIRDatabaseReference *photosRef = [[[FIRDatabase database]reference]child:@"photos"];
    [photosRef
     observeEventType:FIRDataEventTypeChildAdded
     withBlock:^(FIRDataSnapshot *snapshot) {
         NSDictionary *photosDict = snapshot.value;
         if ([photosDict[@"userID"] isEqualToString:[[User getInstance]userID]]) {
             NSURL *url = [NSURL URLWithString:photosDict[@"profilePhotoDownloadURL"]];
             NSData *data = [NSData dataWithContentsOfURL:url];
             
             Photo *photo = [[Photo alloc] initWithImagePath:[UIImage imageWithData:data] andName:@"" andDesc:@"" andLat:photosDict[@"latitude"] andLong:photosDict[@"longitude"] andDate:photosDict[@"photoDate"] andFavorite:FALSE];
             [_photos addObject:photo];
             
             NSLog(@"photoObject = %@", photo);
             [self.tableView reloadData];
         }
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_photos count];
    //return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    Photo *currentPhoto = [_photos objectAtIndex:indexPath.row];
    cell.textLabel.text = currentPhoto.date;
    cell.imageView.image = currentPhoto.imgPath;
    
    //cell.textLabel.text = @"test";
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    PhotoDetailViewController *vc = [segue destinationViewController];
    NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
    vc.photo = [_photos objectAtIndex:selectedRowIndex.row];
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
