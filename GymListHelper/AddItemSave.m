//
//  AddItemSave.m
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 5/10/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "AddItemSave.h"
#import "AddItem.h"

@interface AddItemSave () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableViewCell *saveButCell;
@end

@implementation AddItemSave
-(void)viewDidLoad{
    
    //DidSelectRow gets broken inside the scrollView for some reason. Doing selection manually
    [super viewDidLoad];
}

-(void)Tap:(UITapGestureRecognizer*)recognizer{
    NSLog(@"Save");
    AddItem* controller=(AddItem*)self.parentViewController;
    [controller Save];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell==_saveButCell){
        UITapGestureRecognizer *TapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
    TapRecognizer.numberOfTapsRequired = 1;
    TapRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:TapRecognizer];
    }
    
    return cell;
}

@end
