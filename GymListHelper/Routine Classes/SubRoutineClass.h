//
//  RoutineChartClass.h
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 6/3/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubRoutineClass : NSObject
@property NSString *subRoutineName;
@property NSMutableArray *exerciseList;
@property NSString *waitTime;
-(id)initWithDefaultSettings;
@end
