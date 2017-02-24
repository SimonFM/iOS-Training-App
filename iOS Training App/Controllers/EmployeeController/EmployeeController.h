//
//  EmployeeController.h
//  iOS Training App
//
//  Created by Simon Markham on 23/02/2017.
//  Copyright © 2017 Simon Markham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpHandler.h"
#import "Employee.h"
#import "Common.h"

@interface EmployeeController : UIViewController

@property (strong, nonatomic) HttpHandler *httpHandler;
@property (strong, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (strong, nonatomic) IBOutlet UITextField *surnameTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobTitleTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) Employee *employee;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIView *loadingScreen;

- (void)viewDidLoad;

// sets up notifications for view
- (void)setupNotifications;

// shows the spinner
- (void)showSpinner;

// hides the spinner
- (void)hideSpinner;

// Styles the navbar
- (void)styleNavBar: (BOOL) isCreateView;

// Fill in the textfields.
- (void)fillInTextFields ;

// save the employee
- (void) saveEmployee: (id) sender;

// Updates the desired Employee
- (void) updateEmployee: (id) sender;


// Handles the notification sent from the HttpHandler
- (void)receiveNotification: (NSNotification *) notification;

//
- (UIAlertController*) makeConfirmationAlert: (NSString*) message;

//
- (UIAlertController*) makeErrorAlert;

//
- (UIAlertController*) makeAlert: (NSString*) title withMessage:(NSString*) message;

//
- (UIAlertAction*) makeNonFunctionalOkayButton;

//
- (UIAlertAction*) makeFunctionalOkayButton ;
@end
