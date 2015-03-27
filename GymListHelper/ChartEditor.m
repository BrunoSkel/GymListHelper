//
//  ChartEditor.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/19/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import "ChartEditor.h"
#import "ViewController.h"

@interface ChartEditor ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *SegmentControlOutlet;
@end

@implementation ChartEditor

- (void)viewDidLoad {
    [super viewDidLoad];
    //Save to chart indicates the currently chosen chart. It's to know which chart to save. Starts at 0 because the first chart is the first that shows up
    _saveToChart=0;
    self.allChartData = [NSMutableArray array];
    
    [self loadInitialData];
    for (int i=2; i<[[_allChartData objectAtIndex:_ChosenWorkout] count];i++){
        [_SegmentControlOutlet insertSegmentWithTitle:@"C" atIndex:i animated:NO];
    }
    //When he opens the app, workout A from the first chart will show up.
    //First objectAtIndex = Chart. Second = A/B/C/D/E as 0/1/2/3/4/5
    _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:0]];
    [self.tableView reloadData];
}

- (void)loadInitialData {
    //Loads Chart data. Doesn't need the null check this time, as they will be filled by now
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    _allChartData = [NSMutableArray arrayWithContentsOfFile:filePath];
}

- (void)SaveCharts{
    //SAVE CHARTS
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    [_allChartData writeToFile:filePath atomically:YES];
}

//Deletes the exercise, when it's touched, according to the chosen segment
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableData removeAllObjects];
    //Remove object at the touched index, inside the chosen subworkout, inside a workout.
    
    [[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:_saveToChart] removeObjectAtIndex:indexPath.row];
    
    
        _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:_saveToChart]];
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
    //When the segment is touched, change tableData to the according correct new chart
    _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:s.selectedSegmentIndex]];
    _saveToChart=s.selectedSegmentIndex;
    [self.tableView reloadData];
}

//Required method for not losing data after changing viewcontrollers. Its supposed to be empty
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

@end