//
//  Common.m
//  iOS Training App
//
//  Created by Simon Markham on 23/02/2017.
//  Copyright © 2017 Simon Markham. All rights reserved.
//

#import "Common.h"

@implementation Common

NSString *const CREATE_EMPLOYEE_URL = @"http://192.168.183.127:8080/employee/create";
NSString *const UPDATE_EMPLOYEE_URL = @"http://192.168.183.127:8080/employee/update";

NSString *const CREATE_EMPLOYEE_NOTIFICATION = @"CREATE_EMPLOYEE_NOTIFICATION";
NSString *const CREATE_EMPLOYEE_NOTIFICATION_SUCCESS = @"CREATE_EMPLOYEE_NOTIFICATION_200";
NSString *const CREATE_EMPLOYEE_NOTIFICATION_ERROR = @"CREATE_EMPLOYEE_NOTIFICATION_500";

NSString *const UPDATE_EMPLOYEE_NOTIFICATION = @"UPDATE_EMPLOYEE_NOTIFICATION";
NSString *const UPDATE_EMPLOYEE_NOTIFICATION_SUCCESS = @"UPDATE_EMPLOYEE_NOTIFICATION_200";
NSString *const UPDATE_EMPLOYEE_NOTIFICATION_ERROR = @"UPDATE_EMPLOYEE_NOTIFICATION_500";

NSString *const SAVE = @"Save";
NSString *const UPDATE = @"Update";

NSString *const EMPTY_FORM_MESSAGE = @"It looks like your form is empty!";
NSString *const DUPLICATE_MESSAGE = @"Nothing new to update!";
NSString *const ERROR_CODE = @"500";
NSString *const SUCCESS_CODE = @"200";

NSString *const GET_ALL_EMPLOYEES_URL = @"http://192.168.183.127:8080/employee/index";
NSString *const REMOVE_EMPLOYEES_URL = @"http://192.168.183.127:8080/employee/remove";

NSString *const ALL_EMPLOYEES_NOTIFICATION = @"GET_ALL_EMPLOYEES_NOTIFICATION";
NSString *const ALL_EMPLOYEES_NOTIFICATION_ERROR = @"GET_ALL_EMPLOYEES_NOTIFICATION_500";
NSString *const ALL_EMPLOYEES_NOTIFICATION_SUCCESS = @"GET_ALL_EMPLOYEES_NOTIFICATION_200";

NSString *const REMOVE_EMPLOYEE_NOTIFICATION = @"REMOVE_EMPLOYEE_NOTIFICATION";
NSString *const REMOVE_EMPLOYEE_NOTIFICATION_ERROR = @"REMOVE_EMPLOYEE_NOTIFICATION_500";
NSString *const REMOVE_EMPLOYEE_NOTIFICATION_SUCCESS = @"REMOVE_EMPLOYEE_NOTIFICATION_200";

NSString *const CELL_NAME = @"CustomTableViewCell";
NSString *const NAV_BAR_TITLE = @"Employee List";

NSString *const EMAIL_REGEX = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

@end