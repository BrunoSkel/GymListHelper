//
//  RoutineClass.m
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 6/3/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "RoutineClass.h"
#import "SubRoutineClass.h"

@implementation RoutineClass

-(id)initWithDefaultSettings{
    
    //name
    self.routineName=@"New Workout";
    self.routineDescription=@"No Description";
    
    //categories
    self.routineCategories=[NSMutableArray arrayWithObjects:@"YES",@"NO",@"NO",@"NO",@"NO", nil];
    
    // subroutine
    self.subRoutinesArray=[NSMutableArray array];
    [self createSubRoutineWithName:@"A"];
    
    self.version=1;
    
    return self;
}

-(void)createSubRoutineWithName:(NSString*)subname{
    SubRoutineClass* newSub=[[SubRoutineClass alloc] initWithDefaultSettings];
    newSub.subRoutineName=subname;
    
    [self.subRoutinesArray addObject:newSub];
}

-(void)deleteSubRoutine:(int)index{
    [self.subRoutinesArray removeObjectAtIndex:index];
}

@end
