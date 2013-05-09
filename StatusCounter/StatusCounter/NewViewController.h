//
//  NewViewController.h
//  StatusCounter
//
//  Created by Greg Borenstein on 5/8/13.
//  Copyright (c) 2013 Greg Borenstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCounted.h"
#import "MasterViewController.h"


@interface NewViewController : UIViewController{
}

@property (strong, nonatomic) SCCounted* counted;
@property (weak, nonatomic) IBOutlet UIButton* createButton;
@property (weak, nonatomic) IBOutlet UIButton* cancelButton;

@property (weak, nonatomic) IBOutlet UITextField* optionNameField;
@property (weak, nonatomic) IBOutlet UITextField* countedNameField;
@property (weak, nonatomic) IBOutlet UILabel* optionListField;

@property NSMutableArray* countOptions;

-(IBAction) addOption:(id)sender;

-(void)dismissKeyboard;

-(IBAction) createButtonPressed:(id)sender;
-(IBAction) cancelButtonPressed:(id)sender;

@end
