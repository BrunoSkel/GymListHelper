//
//  ChartsMenu.h
//  GymListHelper
//
//  Created by Danilo S Marshall on 3/26/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartsMenu : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic)  NSMutableArray *allChartData;

@end
