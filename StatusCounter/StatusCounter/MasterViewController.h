//
//  MasterViewController.h
//  StatusCounter
//
//  Created by Greg Borenstein on 5/8/13.
//  Copyright (c) 2013 Greg Borenstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
