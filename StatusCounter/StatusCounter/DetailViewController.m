//
//  DetailViewController.m
//  StatusCounter
//
//  Created by Greg Borenstein on 5/8/13.
//  Copyright (c) 2013 Greg Borenstein. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }

 [self reportTickForOption:1 onCountedId:1];
}

-(void) reportTickForOption:(int) countOptionId onCountedId:(int) countedId
{
    NSString *requestURL = [NSString stringWithFormat:@"http://statuscounter.herokuapp.com/counted/%d/options/%d/ticks", countedId, countOptionId];
    
    NSLog(@"requestURL: %@", requestURL);
    
    //NSString* paramsString = [NSString stringWithFormat:@"name=%@", tickName];
    //NSLog(@"paramsString: %@", paramsString);
    
    NSString* paramsString = @"";
    
    [self postToURL:requestURL withParams:paramsString];
}

-(void) postToURL:(NSString*) reqURL withParams:(NSString*) paramsString
{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURL]];

    NSMutableData *postData=[NSMutableData data];

    [postData appendData:[paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];

    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         NSLog(@"success?");
         //[self didLoadData:data];
     }];
}


- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
