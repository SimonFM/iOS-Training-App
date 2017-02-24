//
//  EmployeeController.m
//  iOS Training App
//
//  Created by Simon Markham on 23/02/2017.
//  Copyright © 2017 Simon Markham. All rights reserved.
//

#import "EmployeeController.h"

@implementation EmployeeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNotifications];
    self.httpHandler = [HttpHandler new];
    if(self.employee != nil){
        [self fillInTextFields];
        [self styleNavBar: YES];
       // [self.emailTextField setHidden: YES];
       // [self.emailLabel setHidden: YES];
    } else {
        [self styleNavBar: NO];
    }
    [self hideSpinner];
}

// sets up notifications for view
- (void)setupNotifications{
    // Listening for http calls
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name: CREATE_EMPLOYEE_NOTIFICATION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name: CREATE_EMPLOYEE_NOTIFICATION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name: UPDATE_EMPLOYEE_NOTIFICATION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name: UPDATE_EMPLOYEE_NOTIFICATION_ERROR object:nil];
}

- (void) showSpinner {
    [self.spinner setHidden: NO];
    [self.loadingScreen setHidden: NO];
    [self.spinner startAnimating];
    self.view.userInteractionEnabled = NO;
}

- (void) hideSpinner {
    [self.spinner setHidden: YES];
    [self.loadingScreen setHidden: YES];
    [self.spinner stopAnimating];
    self.view.userInteractionEnabled = YES;
}

// Styles the navbar
- (void)styleNavBar: (BOOL) isUpdateView{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIBarButtonItem *actionButton;
    SEL action;
    if(isUpdateView){
        action = @selector(updateEmployee:);
        actionButton = [[UIBarButtonItem alloc] initWithTitle: UPDATE style:UIBarButtonItemStylePlain target:self action: action];
        self.navigationItem.title = @"Update Employee";
    } else{
        action = @selector(saveEmployee:);
        actionButton = [[UIBarButtonItem alloc] initWithTitle: SAVE style:UIBarButtonItemStylePlain target:self action: action];
        self.navigationItem.title = @"Save Employee";
    }
    NSArray *actionButtonItems = @[actionButton];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

// Fill in the textfields.
- (void)fillInTextFields {
    [self.firstnameTextField setText: self.employee.firstname];
    [self.surnameTextField setText: self.employee.surname];
    [self.jobTitleTextField setText: self.employee.jobTitle];
    [self.emailTextField setText: self.employee.email];
}

// save the employee
- (void) saveEmployee: (id) sender{
    NSString *firstname = [self.firstnameTextField text];
    NSString *surname = [self.surnameTextField text];
    NSString *email = [self.emailTextField text];
    NSString *jobTitle = [self.jobTitleTextField text];
    BOOL detailsAreNonNull = firstname.length != 0 && surname.length != 0 && email.length != 0 && jobTitle.length != 0;
    
    if(detailsAreNonNull){
        NSMutableDictionary *employeeToSave = [NSMutableDictionary new];
        [employeeToSave setValue: firstname forKey: @"firstname"];
        [employeeToSave setValue: surname forKey: @"surname"];
        [employeeToSave setValue: email forKey: @"email"];
        [employeeToSave setValue: jobTitle forKey: @"jobTitle"];
        // stop spinner and move back to previous screen.
        dispatch_async (dispatch_get_main_queue(), ^{
            [self showSpinner];
        });
        [self.httpHandler post: CREATE_EMPLOYEE_URL withParams: employeeToSave andNotifcationName: CREATE_EMPLOYEE_NOTIFICATION];
    } else {
        UIAlertController * errorAlert = [self makeAlert:@"Oops!" withMessage: @"It looks like your form is incomplete!"];
        UIAlertAction* okayButton = [self makeNonFunctionalOkayButton];
        [errorAlert addAction:okayButton];
        [self presentViewController:errorAlert animated:YES completion:nil];
    }
}

// Updates the desired Employee
- (void) updateEmployee: (id) sender{
    NSString *firstname = [self.firstnameTextField text];
    NSString *surname = [self.surnameTextField text];
    NSString *jobTitle = [self.jobTitleTextField text];
    NSString *email = [self.emailTextField text];
    BOOL detailsAreNonNull = firstname.length != 0 || surname.length != 0 || jobTitle.length != 0;
    BOOL detailsAreDuplicate = [firstname isEqualToString: self.employee.firstname] && [surname isEqualToString: self.employee.surname] && [jobTitle isEqualToString: self.employee.jobTitle] && [email isEqualToString: self.employee.email];
    
    if(detailsAreNonNull && !detailsAreDuplicate){
        NSMutableDictionary *employeeToSave = [NSMutableDictionary new];
        if(firstname.length != 0){
            [employeeToSave setValue: firstname forKey: @"firstname"];
        }
        if(surname.length != 0){
            [employeeToSave setValue: surname forKey: @"surname"];
        }
        if(jobTitle != 0){
            [employeeToSave setValue: jobTitle forKey: @"jobTitle"];
        }
        if(email != 0){
            [employeeToSave setValue: email forKey: @"email"];
        }
        NSString *employeeId = [NSString stringWithFormat:@"%ld", (long)self.employee.id];
        [employeeToSave setValue:employeeId forKey: @"id"];
        // stop spinner and move back to previous screen.
        dispatch_async (dispatch_get_main_queue(), ^{
            [self showSpinner];
        });
        [self.httpHandler post: UPDATE_EMPLOYEE_URL withParams: employeeToSave andNotifcationName: UPDATE_EMPLOYEE_NOTIFICATION];
    } else {
        NSString *message = @"Something went wrong!";
        if(detailsAreDuplicate){
            message = DUPLICATE_MESSAGE;
        }
        
        if(detailsAreNonNull == NO){
            message = EMPTY_FORM_MESSAGE;
        }
        UIAlertController * error = [self makeAlert: @"Oops" withMessage: message];
        UIAlertAction* okayButton = [self makeNonFunctionalOkayButton];
        [error addAction:okayButton];
        [self presentViewController:error animated:YES completion:nil];
    }
}


// Handles the notification sent from the HttpHandler
- (void)receiveNotification: (NSNotification *) notification{
    UIAlertController * errorAlert = [self makeErrorAlert];
    
    if ([[notification name] isEqualToString:CREATE_EMPLOYEE_NOTIFICATION_SUCCESS]) {
        // stop spinner and move back to previous screen.
        dispatch_async (dispatch_get_main_queue(), ^{
            [self hideSpinner];
            UIAlertController * confirmationAlert = [self makeConfirmationAlert: @"Successfully made an employee!"];
            [self presentViewController:confirmationAlert animated:YES completion:nil];
        });
    } else if ([[notification name] isEqualToString:CREATE_EMPLOYEE_NOTIFICATION_ERROR]) {
        // stop spinner and display error.
        dispatch_async (dispatch_get_main_queue(), ^{
            [self hideSpinner];
            [self presentViewController:errorAlert animated:YES completion:nil];
        });
    } else if ([[notification name] isEqualToString: UPDATE_EMPLOYEE_NOTIFICATION_SUCCESS]) {
        // stop spinner and move back to previous screen.
        dispatch_async (dispatch_get_main_queue(), ^{
            UIAlertController * confirmationAlert = [self makeConfirmationAlert: @"Successfully updated an employee!"];
            [self presentViewController:confirmationAlert animated:YES completion:nil];
            [self hideSpinner];
            
        });
    } else if ([[notification name] isEqualToString: UPDATE_EMPLOYEE_NOTIFICATION_ERROR]) {
        // stop spinner and move back to previous screen.
        dispatch_async (dispatch_get_main_queue(), ^{
            [self hideSpinner];
        });
    }
}

//
- (UIAlertController*) makeConfirmationAlert: (NSString*) message{
    UIAlertController * confirmation = [self makeAlert: @"Success!" withMessage:message];
    UIAlertAction* okayButton = [self makeFunctionalOkayButton];
    [confirmation addAction:okayButton];
    return confirmation;
}

//
- (UIAlertController*) makeErrorAlert{
    UIAlertController * errorAlert = [self makeAlert: @"Oops!" withMessage: @"Looks like something went wrong.."];
    UIAlertAction* okayButton = [self makeNonFunctionalOkayButton];
    [errorAlert addAction:okayButton];
    return errorAlert;
}

//
- (UIAlertController*) makeAlert: (NSString*) title withMessage:(NSString*) message{
    return [UIAlertController alertControllerWithTitle: title message:message preferredStyle:UIAlertControllerStyleAlert];
}

//
- (UIAlertAction*) makeNonFunctionalOkayButton {
    return [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
}

//
- (UIAlertAction*) makeFunctionalOkayButton {
    return [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}


@end
