//
//  ViewControllerStartTable.m
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 5/11/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "ViewControllerStartTable.h"
#import "ViewController.h"

@implementation ViewControllerStartTable
-(void)viewDidLoad{
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if (indexPath.section==1){
    ViewController* controller=(ViewController*)self.parentViewController;
    [controller performSegueWithIdentifier:@"goToExercise" sender:nil];
    }
}

@end
