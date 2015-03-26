//
//  ChartEditor.h
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/19/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartEditor : UIViewController <UITableViewDelegate, UITableViewDataSource, NSObject>

@property NSString *itemName;
//@property BOOL completed;
@property (readonly) NSDate *creationDate;
  @property (strong,nonatomic)  NSMutableArray *tableData;
@property (strong,nonatomic)  NSMutableArray *allChartData;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property int saveToChart;
@end
