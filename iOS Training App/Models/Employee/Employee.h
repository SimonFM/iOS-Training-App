//
//  Employee.h
//  iOS Training App
//
//  Created by Simon Markham on 17/02/2017.
//  Copyright © 2017 Simon Markham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface Employee : Jastor

@property (nonatomic) NSInteger id;
@property (strong, nonatomic) NSString * firstname;
@property (strong, nonatomic) NSString * surname;
@property (strong, nonatomic) NSString * email;
@property (strong, nonatomic) NSString * jobTitle;


- (void)dealloc;
@end
