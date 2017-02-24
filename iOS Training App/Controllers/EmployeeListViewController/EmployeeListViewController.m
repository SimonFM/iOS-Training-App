//
//  EmployeeListViewController.m
//  iOS Training App
//
//  Created by Simon Markham on 17/02/2017.
//  Copyright © 2017 Simon Markham. All rights reserved.
//

#import "EmployeeListViewController.h"

@interface EmployeeListViewController ()

@property (strong, nonatomic) NSMutableArray *employees;

@end

@implementation EmployeeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _table.dataSource = self;
    _table.delegate = self;
    self.httpHandler = [HttpHandler new];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.table addSubview: self.refreshControl];

    [self styleNavBar];
    [self setupSpinner];
    [self setupNotificationCenter];

    
    // Fetching employees
    [self.httpHandler get:GET_ALL_EMPLOYEES_URL withNotifcation: ALL_EMPLOYEES_NOTIFICATION];
    
    // Make reusable table cell.
    UINib *cellNib = [UINib nibWithNibName:CELL_NAME bundle:nil];
    [self.table registerNib:cellNib forCellReuseIdentifier:CELL_NAME];
}

- (void) setupSpinner{
    dispatch_async (dispatch_get_main_queue(), ^{
        [self showSpinner];
    });
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

- (void)setupNotificationCenter {
    // Listening for http calls
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:ALL_EMPLOYEES_NOTIFICATION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:ALL_EMPLOYEES_NOTIFICATION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:REMOVE_EMPLOYEE_NOTIFICATION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:REMOVE_EMPLOYEE_NOTIFICATION_SUCCESS object:nil];
}

// Styles the navbar
- (void)styleNavBar {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    SEL createEmployee = @selector(pushCreateScreen:);
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: createEmployee];
    
    NSArray *actionButtonItems = @[addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    self.navigationItem.title = NAV_BAR_TITLE;
}

// Launches the add employee screen.
- (void) pushCreateScreen: (id) sender{
    EmployeeController *createEmployeeViewController = [[EmployeeController alloc] init];
    createEmployeeViewController.employee = nil;
    [self.navigationController pushViewController:createEmployeeViewController animated:YES];
}

// Launches the Employee screen to update the selected Employee.
- (void) pushEmployeeScreen: (Employee*) employee{
    EmployeeController *employeeViewController = [[EmployeeController alloc] init];
    employeeViewController.employee = employee;
    [self.navigationController pushViewController:employeeViewController animated:YES];
}

//
- (void)refreshTable {
    //TODO: refresh your data
    [self showSpinner];
    [self.httpHandler get:GET_ALL_EMPLOYEES_URL withNotifcation: ALL_EMPLOYEES_NOTIFICATION];
}


// Removes the cell from the table.
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Remove" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSInteger index = indexPath.row;
        Employee *employee = [self.employees objectAtIndex: index];
        if([employee.email length] > 0 ){
            NSMutableDictionary *employeeToRemove = [NSMutableDictionary new];
            NSString *employeeId = [NSString stringWithFormat:@"%ld", (long)employee.id];
            [employeeToRemove setValue: employeeId forKey: @"id"];
            // Send POST to remove user.
            [self.httpHandler post:REMOVE_EMPLOYEES_URL withParams:employeeToRemove andNotifcationName:REMOVE_EMPLOYEE_NOTIFICATION];
        }
    }];
    removeAction.backgroundColor = [UIColor redColor];
    
    return @[removeAction];
}

// Returns the number of employess in order to populate the table with employees.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger) section {
    return [self.employees count];
}

// Adds a new cell to the table.
- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath{
    Employee *employee = [self.employees objectAtIndex:indexPath.row];
    CustomTableViewCell *cell = [self makeCell: employee];
    return cell;
}

// Launches new Controller upon cell press.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath{
    Employee *employee = [self.employees objectAtIndex:indexPath.row];
    [self pushEmployeeScreen: employee];
}

// Activated when view is on top of stack.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.httpHandler get:GET_ALL_EMPLOYEES_URL withNotifcation:ALL_EMPLOYEES_NOTIFICATION];
}

// Makes a cell for the table.
- (CustomTableViewCell *)makeCell: (Employee*) employee {
    NSString *fullName = [NSString stringWithFormat:@"%1@ %2@", employee.firstname, employee.surname];
    CustomTableViewCell *cell = (CustomTableViewCell *)[_table dequeueReusableCellWithIdentifier:CELL_NAME];
    
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CELL_NAME owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell.nameLabel setText: fullName];
    [cell.jobLabel setText: employee.jobTitle];
    cell.employeeId = employee.id;
    return cell;
}

// Handles the notification sent from the HttpHandler
- (void)receiveNotification: (NSNotification *) notification{
    
    if ([[notification name] isEqualToString:ALL_EMPLOYEES_NOTIFICATION_SUCCESS]) {
        NSDictionary *employeeList = (NSDictionary *) notification.object;
        NSArray *list = [employeeList valueForKey: @"data"];
        self.employees = [self jsonToEmployee: list];
        [self reloadTable];
    } else if([[notification name] isEqualToString: ALL_EMPLOYEES_NOTIFICATION_ERROR]){
        // show pop up dialog.
        [self showErrorMessage: @"Oops" withMessage: @"Couldn't fetch employees"];
    } else if([[notification name] isEqualToString: REMOVE_EMPLOYEE_NOTIFICATION_SUCCESS]){
        //fetch the employee from the list
        NSDictionary *jsonResponse = (NSDictionary *) notification.object;
        NSString *message = [jsonResponse valueForKey:@"msg"];
        NSArray *array = [message componentsSeparatedByString:@" "];
        NSString *email = array[2];
        if([self isValidEmail: email]){
            [self removeEmployee: email];
            [self reloadTable];
        } else {
            [self showErrorMessage: @"Oops" withMessage: @"Unable to remove employee"];
        }
    } else if([[notification name] isEqualToString: REMOVE_EMPLOYEE_NOTIFICATION_ERROR]){
        [self showErrorMessage: @"Oops" withMessage: @"Unable to remove employee"];
    }
}

//Converts an NSArry to NSMutualArray for the json applied.
- (NSMutableArray *) jsonToEmployee: (NSArray*) json{
    NSError *error = nil;
    NSMutableArray *employees = [NSMutableArray new];
    if (json) {
        for(NSDictionary *item in json) {
            Employee *employee = [[Employee alloc] initWithDictionary: item];
            NSLog(@"Item: %@", item);
            [employees addObject:employee];
        }
    } else {
        NSLog(@"Error parsing JSON: %@", error);
    }
    return employees;
}

-(void) showErrorMessage: (NSString*) title withMessage: (NSString*) message{
    [self hideSpinner];
    dispatch_async (dispatch_get_main_queue(), ^{
        [self hideSpinner];
    });
    [self showErrorAlert: title withMessage: message];
}

// remove from employees array
- (void) removeEmployee: (NSString*) email {
    NSInteger index = [self findEmployee:email];
    if(index > -1){
        [self.employees removeObjectAtIndex: index];
    } else {
        [self showErrorAlert: @"Oops" withMessage: @"Unable to remove employee"];
    }
}

// Search for employee with the desired email.
- (NSInteger)findEmployee: (NSString *) email {
    for(int i = 0; i < [self.employees count]; i++){
        Employee *employee = self.employees[i];
        if([email isEqualToString: employee.email]){
            return i;
        }
    }
    return -1;
}

// checks to see if the email is valid in the string.
- (BOOL) isValidEmail: (NSString *) candidate {
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEX];
    return [emailTest evaluateWithObject:candidate];
}

// reloads the data in the table.
- (void) reloadTable {
    dispatch_async (dispatch_get_main_queue(), ^{
        [self showSpinner];
        [self.table reloadData];
        [self.refreshControl endRefreshing];
        [self hideSpinner];
    });
}

- (void) showErrorAlert: (NSString*) title withMessage:(NSString*) message{
    UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle: title message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okayButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [errorAlert addAction:okayButton];
    [self presentViewController:errorAlert animated:YES completion:nil];
}


// Resizes the cells size.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

@end
