//
//  EmployeeListViewController.h
//  iOS Training App
//
//  Created by Simon Markham on 17/02/2017.
//  Copyright © 2017 Simon Markham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpHandler.h"
#import "Employee.h"
#import "CustomTableViewCell.h"
#import "EmployeeController.h"

@interface EmployeeListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *loadingScreen;
@property (strong, nonatomic) HttpHandler *httpHandler;
@property (strong, nonatomic) UIRefreshControl *refreshControl;



- (void)viewDidLoad;

// Sets up the Spinner
- (void)setupSpinner;

// Sets up the notification listeners.
- (void)setupNotificationCenter;

// Styles the navbar
- (void)styleNavBar;

// Launches the add employee screen.
- (void) pushCreateScreen: (id) sender;

// Launches the Employee screen to update the selected Employee.
- (void) pushEmployeeScreen: (Employee*) employee;

// Removes the cell from the table.
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;

// Returns the number of employess in order to populate the table with employees.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger) section;

// Adds a new cell to the table.
- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath;

// Launches new Controller upon cell press.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath;

// Activated when view is on top of stack.
- (void)viewWillAppear:(BOOL)animated;

// Makes a cell for the table.
- (CustomTableViewCell *)makeCell: (Employee*) employee;

//Converts an NSArry to NSMutualArray for the json applied.
- (NSMutableArray *) jsonToEmployee: (NSArray*) json;

// Handles the notification sent from the HttpHandler
- (void)receiveNotification: (NSNotification *) notification;

// remove from employees array
- (void) removeEmployee: (NSString*) email;

// Search for employee with the desired email.
- (NSInteger)findEmployee: (NSString *) email ;

// checks to see if the email is valid in the string.
- (BOOL) isValidEmail: (NSString *) candidate;
// reloads the data in the table.
- (void) reloadTable;

- (void) showErrorAlert: (NSString*) title withMessage:(NSString*) message;

// Resizes the cells size.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
