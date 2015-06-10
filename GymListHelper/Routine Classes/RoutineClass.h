//
//  RoutineClass.h
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 6/3/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoutineClass : NSObject
@property NSString *routineName;
@property NSString *routineDescription;
@property NSMutableArray *routineCategories;
@property NSMutableArray *subRoutinesArray;
@property int version;
@property NSString *routineOwner;
@property NSString *routineUniqueID; //For updates
-(id)initWithDefaultSettings;
-(void)createSubRoutineWithName:(NSString*)subname;
-(void)deleteSubRoutine:(int)index;
@end
