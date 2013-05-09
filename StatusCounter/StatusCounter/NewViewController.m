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
    
   
    
    NSString *requestURL = @"http://statuscounter.herokuapp.com/counted";
    NSMutableString* paramsString = [NSMutableString stringWithFormat:@"name=%@", _countedNameField.text];
    
    
    
    NSNumber* i = [NSNumber numberWithInt:0];
    for(NSString* opt in _countOptions){
        
        [paramsString appendString:[NSMutableString stringWithFormat:@"&count_options[%@]=%@",i,opt]];
        
        //[_counted.optionsWithNames setObject:i forKey:opt];
        
        i = [NSNumber numberWithInt:([i intValue] + 1)];
    }
    
    NSLog(@"paramsString: %@", paramsString);
    
    NSData* jsonResponse = [SCCounted postToURL:requestURL withParams:paramsString];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonResponse encoding:NSUTF8StringEncoding];

    
    NSLog(@"jsonResponse: %@", jsonString);
    
    NSError* e = nil;
    NSDictionary* countedJson = [NSJSONSerialization JSONObjectWithData:jsonResponse options:NSJSONReadingAllowFragments error:&e];
    
    _counted.optionsWithNames = [[NSMutableDictionary alloc] init];
    
    for(NSDictionary* countOption in [countedJson objectForKey:@"count_options"]){
        [_counted.optionsWithNames setObject:[countOption objectForKey:@"id"] forKey:[countOption objectForKey:@"name"]];
    }
    
    
    _counted.countedId = [[countedJson objectForKey:@"id"] integerValue];
    
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
