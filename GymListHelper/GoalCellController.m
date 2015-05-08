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

-(void)viewWillAppear:(BOOL)animated{
    self.detailLabel.text=@"None";
    int goalnumber=0;
    //Changing the Detail text according to goals chosen
    for (int i=0;i<[self.parent.ChartCategories count];i++){
        if ([self.parent.ChartCategories[i] isEqual:@"YES"]){
            goalnumber++;
        }
    }
    
    if (goalnumber>1)
        self.detailLabel.text=@"(Several)";
    
    else if (goalnumber!=0){
        if ([self.parent.ChartCategories[0] isEqual:@"YES"]){
            self.detailLabel.text=@"Hypertrophy";
        }
        if ([self.parent.ChartCategories[1] isEqual:@"YES"]){
            self.detailLabel.text=@"Definition";
        }
        if ([self.parent.ChartCategories[2] isEqual:@"YES"]){
            self.detailLabel.text=@"Tonification";
        }
        if ([self.parent.ChartCategories[3] isEqual:@"YES"]){
            self.detailLabel.text=@"Fat Loss";
        }
        if ([self.parent.ChartCategories[4] isEqual:@"YES"]){
            self.detailLabel.text=@"Strength";
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
