//
//  HttpHandler.m
//  iOS Training App
//
//  Created by Simon Markham on 21/02/2017.
//  Copyright © 2017 Simon Markham. All rights reserved.
//

#import "HttpHandler.h"

@implementation HttpHandler

//
-(void)get:(NSString *) urlToGet withNotifcation:(NSString*) notificationName{
    NSURL *url = [NSURL URLWithString: urlToGet];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *get = [session dataTaskWithURL: url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"GET - %@", json);
        if(json){
           NSString * notification = [NSString stringWithFormat: @"%1@_%2@", notificationName, [json valueForKey: @"status"]];
           [self sendNotification: json: notification];
        }
     }];
    [ get resume];
}

//
- (void) post:(NSString *) urlAsString withParams:(NSDictionary *)parameters andNotifcationName:(NSString *)notificationName{
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    NSError *error = nil;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody: postdata];
    
    NSURLSessionDataTask *post = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(json){
            NSString * status = [json valueForKey: @"status"];
            NSLog(@"POST - %@", response);
            NSString * notification = [NSString stringWithFormat: @"%1@_%2@", notificationName, status];
            [self sendNotification: json: notification];
       }
    }];
    [post resume];
}

//
- (void)sendNotification: (NSDictionary*) json : (NSString*) notificationName {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object: json];
}

@end
