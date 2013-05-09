//
//  NewViewController.m
//  StatusCounter
//
//  Created by Greg Borenstein on 5/8/13.
//  Copyright (c) 2013 Greg Borenstein. All rights reserved.
//

#import "NewViewController.h"

@interface NewViewController (){
    NSMutableArray *_objects;

}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;

@end

@implementation NewViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Initialization code here.
//    }
//    
//    return self;
//}

#pragma mark - Managing the detail item



- (void)setDetailItem:(id)newDetailItem
{
    
    if (_objects != newDetailItem) {
        _objects = newDetailItem;
    
        _counted = [[SCCounted alloc] init];

        _countOptions = [[NSMutableArray alloc] init];
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
   
}

- (void)configureView
{
}

-(IBAction) addOption:(id)sender{
    [_countOptions addObject:_optionNameField.text];
    NSString* result = [_countOptions componentsJoinedByString:@", "];
    [_optionListField setText:result];
    [_optionNameField setText:@""];
    
    if([_countedNameField.text length] > 0){
        _createButton.hidden = NO;
    }
}


-(void) createButtonPressed:(id)sender
{
    _counted.name = _countedNameField.text;
    
    _counted.optionsWithNames = [[NSMutableDictionary alloc] init];
    
    NSNumber* i = [NSNumber numberWithInt:1];
    for(NSString* opt in _countOptions){
        [_counted.optionsWithNames setObject:i forKey:opt];
        
        i = [NSNumber numberWithInt:([i intValue] + 1)];
    }
    
    
    [_objects addObject:_counted];


    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void) cancelButtonPressed:(id)sender
{
   [self dismissViewControllerAnimated:TRUE completion:nil];
    
}

-(void)dismissKeyboard
{
    [_optionNameField resignFirstResponder];
    [_countedNameField resignFirstResponder];
    
    if([_countedNameField.text length] > 0 && [_countOptions count] > 0){
    
        _createButton.hidden = NO;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _createButton.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
