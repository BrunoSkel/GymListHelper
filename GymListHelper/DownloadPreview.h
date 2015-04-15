//
//  DownloadPreview.h
//  GymListHelper
//
//  Created by Rodrigo Dias Takase on 13/04/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DownloadPreview : UIViewController
    @property NSInteger currentLanguage;

    @property NSInteger currentCategory;
    @property NSString* currentCategoryName;

    @property NSArray* currentDownloadChart;

    @property (strong,nonatomic)  NSMutableArray *allChartData;
    @property (strong,nonatomic)  NSMutableArray *ChartNamesArray;
    @property (strong,nonatomic)  NSMutableArray *RoutineNamesArray;
    @property (strong,nonatomic)  NSMutableArray *WaitTimesArray;
    @property (strong,nonatomic)  NSMutableArray *ChartCategoriesArray;
    @property (strong,nonatomic)  NSMutableArray *tableData;
    @property (strong,nonatomic)  NSMutableArray *ByUserArray;

@end
