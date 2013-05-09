//
//  SCCounted.h
//  StatusCounter
//
//  Created by Greg Borenstein on 5/8/13.
//  Copyright (c) 2013 Greg Borenstein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCounted : NSObject

@property int countedId;
@property NSString* name;
@property NSMutableDictionary* optionsWithNames;
@property bool created;

@end
