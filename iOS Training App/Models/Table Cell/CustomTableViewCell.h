//
//  CustomTableViewCell.h
//  iOS Training App
//
//  Created by Simon Markham on 20/02/2017.
//  Copyright © 2017 Simon Markham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *jobLabel;
@property (nonatomic) NSInteger employeeId;

@end
