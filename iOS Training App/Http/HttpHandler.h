//
//  HttpHandler.h
//  iOS Training App
//
//  Created by Simon Markham on 21/02/2017.
//  Copyright © 2017 Simon Markham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHandler : NSObject

// Sends a GET to the URL
- (void)get:(NSString *)urlToGet withNotifcation:(NSString*) notificationName;

// Sends a POST with parameters to the URL
- (void)post:(NSString *)urlAsString withParams:(NSDictionary *)parameters andNotifcationName:(NSString*)notificationName;

// Broadcasts the associated notification.
- (void)sendNotification: (NSDictionary*) json : (NSString*) notificationName;

@end
