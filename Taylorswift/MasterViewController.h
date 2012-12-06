//
//  MasterViewController.h
//  Taylorswift
//
//  Created by Ryo Suzuki on 11/30/12.
//  Copyright (c) 2012 Ryo Suzuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController
{
    NSURLConnection *connection;
    NSMutableData *data;
    
    NSMutableArray *array;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
