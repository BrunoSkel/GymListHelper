//
//  GoalCellController.m
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 5/7/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "GoalCellController.h"
#import "GoalPicker.h"
@implementation GoalCellController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    GoalPicker* controller=(GoalPicker *)segue.destinationViewController;
    controller.parent=self.parent;
}

@end
