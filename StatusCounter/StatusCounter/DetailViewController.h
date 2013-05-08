//
//  DetailViewController.h
//  StatusCounter
//
//  Created by Greg Borenstein on 5/8/13.
//  Copyright (c) 2013 Greg Borenstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>{
}
-(void) postToURL:(NSString*) reqURL withParams:(NSString*) paramsString;
-(void) reportTickForOption:(int) countOptionId onCountedId:(int) countedId;

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
