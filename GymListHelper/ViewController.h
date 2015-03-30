//
//  ViewController.h
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/18/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic)  NSMutableArray *tableData;
@property (strong,nonatomic)  NSMutableArray *allChartData;
@property (strong,nonatomic)  NSMutableArray *RoutineNamesArray;
@property (strong,nonatomic)  NSMutableArray *WaitTimesArray;
@property (strong, nonatomic) IBOutlet UIPickerView *PickerView;
@property NSUserDefaults *SharedData;
@property int ChosenWorkout;

-(void)Unwinded;

@end

