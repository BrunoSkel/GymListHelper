    //
//  AddItem.h
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/19/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartEditor.h"

@interface AddItem: UIViewController

@property NSString *newitem;
-(void)editMode;
@property int EditThisExercise;
@property int ChosenSubWorkout;
@property int ChosenWorkout;
@property NSMutableArray *sentArray;

@end