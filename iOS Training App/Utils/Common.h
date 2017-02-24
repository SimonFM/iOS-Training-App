//
//  Common.h
//  iOS Training App
//
//  Created by Simon Markham on 23/02/2017.
//  Copyright © 2017 Simon Markham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

extern NSString *const CREATE_EMPLOYEE_URL;
extern NSString *const UPDATE_EMPLOYEE_URL;

extern NSString *const CREATE_EMPLOYEE_NOTIFICATION;
extern NSString *const CREATE_EMPLOYEE_NOTIFICATION_SUCCESS;
extern NSString *const CREATE_EMPLOYEE_NOTIFICATION_ERROR;

extern NSString *const UPDATE_EMPLOYEE_NOTIFICATION;
extern NSString *const UPDATE_EMPLOYEE_NOTIFICATION_SUCCESS;
extern NSString *const UPDATE_EMPLOYEE_NOTIFICATION_ERROR;

extern NSString *const SAVE;
extern NSString *const UPDATE;

extern NSString *const EMPTY_FORM_MESSAGE;
extern NSString *const DUPLICATE_MESSAGE;
extern NSString *const ERROR_CODE;
extern NSString *const SUCCESS_CODE;

extern NSString *const GET_ALL_EMPLOYEES_URL;
extern NSString *const REMOVE_EMPLOYEES_URL;

extern NSString *const ALL_EMPLOYEES_NOTIFICATION;
extern NSString *const ALL_EMPLOYEES_NOTIFICATION_ERROR;
extern NSString *const ALL_EMPLOYEES_NOTIFICATION_SUCCESS;

extern NSString *const REMOVE_EMPLOYEE_NOTIFICATION;
extern NSString *const REMOVE_EMPLOYEE_NOTIFICATION_ERROR;
extern NSString *const REMOVE_EMPLOYEE_NOTIFICATION_SUCCESS;

extern NSString *const CELL_NAME;
extern NSString *const NAV_BAR_TITLE;

extern NSString *const EMAIL_REGEX;

@end
