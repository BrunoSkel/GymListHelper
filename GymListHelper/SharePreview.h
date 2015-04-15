//
//  SharePreview.h
//  GymListHelper
//
//  Created by Rodrigo Dias Takase on 09/04/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharePreview : UIViewController
@property int ShareThisRoutine;
@property NSMutableArray* RoutineNamesArray;
@property NSMutableArray* allChartData;
@property NSMutableArray* ChartNamesArray;
@property NSMutableArray* WaitTimesArray;
@property NSMutableArray* ChartCategoriesArray;

@property NSMutableArray* ByUserArray;

@end
