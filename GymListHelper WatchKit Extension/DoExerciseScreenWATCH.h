//
//  DoExerciseScreen.h
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/18/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface DoExerciseScreenWATCH : WKInterfaceController

@property (strong,nonatomic)  NSMutableArray *exercisedata;

@property (strong,nonatomic) NSString* chartname;

@property int cooldownAmount;

@end