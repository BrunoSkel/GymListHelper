//
//  ChartEditor.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/19/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import "ChartEditor.h"

@interface ChartEditor ()
@end

@implementation ChartEditor

- (void)viewDidLoad {
    [super viewDidLoad];
    _saveToChart=0;
    self.chartA = [[NSMutableArray alloc]init];
    [self loadInitialData];
    _tableData=[NSMutableArray arrayWithArray:_chartA];
    [self.tableView reloadData];
}

- (void)loadInitialData {
    //Loads Chart data. Doesn't need the null check this time, as they will be filled by now
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartA"];
    
    _chartA = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    NSString *filePathB = [documentsDirectory stringByAppendingPathComponent:@"chartB"];
    
    _chartB = [NSMutableArray arrayWithContentsOfFile:filePathB];
    
    NSString *filePathC = [documentsDirectory stringByAppendingPathComponent:@"chartC"];
    
    _chartC = [NSMutableArray arrayWithContentsOfFile:filePathC];
}

- (void)SaveCharts{
    //SAVE CHART A
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartA"];
    
    [_chartA writeToFile:filePath atomically:YES];
    
    //SAVE CHART B
    NSString *filePathB = [documentsDirectory stringByAppendingPathComponent:@"chartB"];
    
    [_chartB writeToFile:filePathB atomically:YES];
    
    //SAVE CHART C
    NSString *filePathC = [documentsDirectory stringByAppendingPathComponent:@"chartC"];
    
    [_chartC writeToFile:filePathC atomically:YES];
    //SAVE CHART END
}

//Deletes the exercise, when it's touched, according to the chosen segment
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableData removeAllObjects];
    if (_saveToChart==0){
    [self.chartA removeObjectAtIndex:indexPath.row];
            _tableData=[NSMutableArray arrayWithArray:_chartA];
    }
    else if (_saveToChart==1){
    [self.chartB removeObjectAtIndex:indexPath.row];
        _tableData=[NSMutableArray arrayWithArray:_chartB];
    }
    else if (_saveToChart==2){
    [self.chartC removeObjectAtIndex:indexPath.row];
        _tableData=[NSMutableArray arrayWithArray:_chartC];
    }
    [self SaveCharts];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)OnSegmentPressed:(id)sender {
    [_tableData removeAllObjects];
    UISegmentedControl *s = (UISegmentedControl *)sender;
    switch (s.selectedSegmentIndex) {
        case 0:
            _tableData=[NSMutableArray arrayWithArray:_chartA];
            _saveToChart=0;
            break;
        case 1:
            _tableData=[NSMutableArray arrayWithArray:_chartB];
            _saveToChart=1;
            break;
        case 2:
            _tableData=[NSMutableArray arrayWithArray:_chartC];
            _saveToChart=2;
            break;
    }
    [self.tableView reloadData];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

@end