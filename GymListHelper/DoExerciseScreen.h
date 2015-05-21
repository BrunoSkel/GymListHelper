//
//  DoExerciseScreen.h
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/18/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoExerciseScreen : UIViewController

@property (strong,nonatomic)  NSMutableArray *exercisedata;
@property (strong,nonatomic)  NSMutableArray *infodata;
@property (strong,nonatomic)  NSMutableArray *weightdata;
@property (strong,nonatomic)  NSMutableArray *picdata;

@property (strong,nonatomic) NSString* chartname;

@property int cooldownAmount;

@end