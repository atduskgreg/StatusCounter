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

-(IBAction)cancelNewCounted:(UIStoryboardSegue *)segue {

    NSLog(@"segue");
}


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
           
}

-(void) optionButtonClicked:(UIButton*) sender
{
    NSLog(@"button clicked: %@",sender.titleLabel.text);
    
    SCCounted* counted = self.detailItem;
    NSLog(@"titleLabel text: %@", sender.titleLabel.text);
    NSInteger optionId = [[counted.optionsWithNames objectForKey:sender.titleLabel.text] integerValue];
    NSLog(@"selected optionId: %d", optionId);

    
    [self reportTickForOption:optionId onCountedId:counted.countedId];
}

-(void) reportTickForOption:(int) countOptionId onCountedId:(int) countedId
{
    NSString *requestURL = [NSString stringWithFormat:@"http://statuscounter.herokuapp.com/counted/%d/options/%d/ticks", countedId, countOptionId];
    
    NSLog(@"requestURL: %@", requestURL);
    
    NSString* paramsString = @"";
    
    [SCCounted postToURLAsync:requestURL withParams:paramsString];
}


- (void)configureView
{
    // Update the user interface for the detail item.

    //if (self.detailItem) {
    
    // retrieve the counted from the detailItem
    SCCounted* counted = self.detailItem;

    int currButton = 0;
    
    for(id key in counted.optionsWithNames){
        NSLog(@"key=%@ value=%@", key, [counted.optionsWithNames objectForKey:key]);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [button addTarget:self
                   action:@selector(optionButtonClicked:)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:key forState:UIControlStateNormal];
        
        int yPad = 10;
        int xPad = 10;
        
        int mysteryMissingHeight = 60;
        
        float buttonWidth = self.view.frame.size.width - xPad * 2;
        float buttonHeight = (self.view.frame.size.height - mysteryMissingHeight - ((counted.optionsWithNames.count-1) * yPad))/(float)counted.optionsWithNames.count;
        
        float buttonTop =  yPad*(currButton+1) + buttonHeight*currButton;
        
        
         button.frame = CGRectMake(xPad, buttonTop, buttonWidth, buttonHeight);
        
        [self.view addSubview:button];
        
        currButton++;
    }
    //}

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
