//
//  AddItemSave.m
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 5/10/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "AddItemSave.h"
#import "AddItem.h"

@implementation AddItemSave
-(void)viewDidLoad{
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (![segue.identifier isEqual:@"OnSave"])
        return;
    NSLog(@"Save");
    AddItem* controller=(AddItem*)self.parentViewController;
    [controller Save];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

@end
