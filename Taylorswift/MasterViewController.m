//
//  MasterViewController.m
//  Taylorswift
//
//  Created by Ryo Suzuki on 11/30/12.
//  Copyright (c) 2012 Ryo Suzuki. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    array = [[NSMutableArray alloc] init];
    
    NSString *apiURL = @"https://itunes.apple.com/lookup?id=159260351&entity=song";
    NSURL *url = [NSURL URLWithString: apiURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}


/// サーバからレスポンスが送られてきたときのデリゲート
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    data = [[NSMutableData alloc] initWithData:0];
}

/// サーバからデータが送られてきたときのデリゲート
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data;
{
	[data appendData:_data];
}

/// データのロードか完了した時のデリゲート
- (void)connectionDidFinishLoading:(NSURLConnection *)_connection;
{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *resultDict = [[NSDictionary alloc] initWithDictionary:[jsonString JSONValue]];
    
    [array addObjectsFromArray:[resultDict valueForKey:@"results"]];
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (array.count != 0) {
        NSDictionary *resultDict = [[NSDictionary alloc] initWithDictionary:[array objectAtIndex:indexPath.row]];
        NSString *artistName = [resultDict valueForKey:@"artistName"];
        NSString *trackID = [resultDict valueForKey:@"trackId"]; // trackID
        NSString *trackName = [resultDict valueForKey:@"trackName"];
        NSString *collectionName = [resultDict valueForKey:@"collectionName"];
        NSString *releaseDate = [resultDict valueForKey:@"releaseDate"];
        NSArray *array = [releaseDate componentsSeparatedByString:@"-"];
        NSString *releaseYear = [array objectAtIndex:0];
        
        NSURL *artworkUrl = [NSURL URLWithString:[resultDict valueForKey:@"artworkUrl100"]];
        NSData *artworkData = [NSData dataWithContentsOfURL:artworkUrl];
        UIImage *albumArtImage = [UIImage imageWithData:artworkData];
        cell.textLabel.text = trackName;
        cell.imageView.image = albumArtImage;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    NSDictionary *resultDict = [[NSDictionary alloc] initWithDictionary:[array objectAtIndex:indexPath.row]];
    NSString *trackId = [resultDict valueForKey:@"trackId"];
    self.detailViewController.trackId = trackId;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
