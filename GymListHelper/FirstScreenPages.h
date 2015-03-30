//
//  FirstScreenPages.h
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/30/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstScreenPages : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

@end