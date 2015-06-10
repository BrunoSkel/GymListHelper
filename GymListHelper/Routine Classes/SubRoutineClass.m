//
//  RoutineChartClass.m
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 6/3/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "SubRoutineClass.h"

@implementation SubRoutineClass

-(id)initWithDefaultSettings{
    self.subRoutineName=@"A";
    self.waitTime=@"30";
    self.exerciseList=[NSMutableArray array];
    return self;
}

@end
