//
//  Employee.m
//  iOS Training App
//
//  Created by Simon Markham on 17/02/2017.
//  Copyright © 2017 Simon Markham. All rights reserved.
//

#import "Employee.h"

@implementation Employee
@synthesize id, firstname, surname, email, jobTitle;

- (void)dealloc {
    self.id = -1;
    self.firstname = nil;
    self.surname = nil;
    self.email = nil;
    self.jobTitle = nil;
}
@end

