//
//  SCCounted.m
//  StatusCounter
//
//  Created by Greg Borenstein on 5/8/13.
//  Copyright (c) 2013 Greg Borenstein. All rights reserved.
//

#import "SCCounted.h"

@implementation SCCounted

+(void) postToURLAsync:(NSString*) reqURL withParams:(NSString*) paramsString
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURL]];
    
    NSMutableData *postData=[NSMutableData data];
    
    [postData appendData:[paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    
    
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:
                                ^(NSURLResponse *response, NSData *data, NSError *error)
                                {
                                    NSLog(@"success?");
                                }];
}

+(NSData*) postToURL:(NSString*) reqURL withParams:(NSString*) paramsString
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURL]];
    
    NSMutableData *postData=[NSMutableData data];
    
    [postData appendData:[paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    
    
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&response
                                                          error:&error];
        return data;
}

@end
