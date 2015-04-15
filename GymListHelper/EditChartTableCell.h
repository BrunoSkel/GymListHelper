//
//  EditChartTableCell.h
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 4/1/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditChartTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *UpButton;
@property (strong, nonatomic) IBOutlet UIButton *DownButton;
@property (strong, nonatomic) IBOutlet UILabel *ExName;
@property (strong, nonatomic) IBOutlet UILabel *SeriesRepsLabel;

@end
