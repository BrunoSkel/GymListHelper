//
//  GoalCellController.h
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 5/7/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewChartDescriptionEditor.h"
@interface GoalCellController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property NewChartDescriptionEditor* parent;
@end
