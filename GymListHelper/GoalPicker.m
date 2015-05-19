//
//  GoalPicker.m
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 5/7/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "GoalPicker.h"

@implementation GoalPicker

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ( [[self.parent.ChartCategories objectAtIndex:indexPath.row]  isEqual: @"YES"] ){
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.parent.ChartCategories replaceObjectAtIndex:indexPath.row withObject:@"YES"];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.parent.ChartCategories replaceObjectAtIndex:indexPath.row withObject:@"NO"];
    }
    
}

@end
