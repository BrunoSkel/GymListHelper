//
//  ChartsMenu.m
//  GymListHelper
//
//  Created by Danilo S Marshall on 3/26/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import "ChartsMenu.h"
#import "ViewController.h"

@interface ChartsMenu () <UITableViewDelegate, UITableViewDataSource>
@property (strong) IBOutlet UITableView *tableView;
@property int TouchedIndex;
@end

@implementation ChartsMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    //Load charts
    [self LoadChartData];
    _tableData=[NSMutableArray arrayWithArray:_allChartData];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LoadChartData{
    
    //Load the saved charts. If there's nothing, fill the charts with the example data.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    _allChartData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
    
    _ChartNamesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"routineNamesFile"];
    
    _RoutineNamesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"waitTimesFile"];
    
    _WaitTimesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    if (_allChartData==NULL){
        
        NSLog(@"There is no Chart data. Filling up");
        _allChartData = [NSMutableArray array];
        //Adding a new chart
        [_allChartData addObject: [NSMutableArray array]];
        //Adding charts A/B/C to the new chart
        [[_allChartData objectAtIndex:0] addObject: [NSMutableArray array]];
        [[_allChartData objectAtIndex:0] addObject: [NSMutableArray array]];
        [[_allChartData objectAtIndex:0] addObject: [NSMutableArray array]];
        //Filling A
        [[[_allChartData objectAtIndex:0] objectAtIndex:0] addObject:@"Example A1 | 4x8"];
        [[[_allChartData objectAtIndex:0] objectAtIndex:0] addObject:@"Example A2 | 4x8"];
        [[[_allChartData objectAtIndex:0] objectAtIndex:0] addObject:@"Example A3 | 4x8"];
        [[[_allChartData objectAtIndex:0] objectAtIndex:0] addObject:@"Example A4 | 4x8"];
        //Filling B
        [[[_allChartData objectAtIndex:0] objectAtIndex:1] addObject:@"Example B1 | 4x10"];
        [[[_allChartData objectAtIndex:0] objectAtIndex:1] addObject:@"Example B2 | 4x10"];
        [[[_allChartData objectAtIndex:0] objectAtIndex:1] addObject:@"Example B3 | 4x10"];
        //Filling C
        [[[_allChartData objectAtIndex:0] objectAtIndex:2] addObject:@"Example C1 | 3x15"];
        [[[_allChartData objectAtIndex:0] objectAtIndex:2] addObject:@"Example C2 | 3x15"];
        
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
        [_allChartData writeToFile:filePath atomically:YES];
        
        
        //Adding new WaitTime array
        _WaitTimesArray = [NSMutableArray array];
        [_WaitTimesArray addObject: [NSMutableArray array]];
        //Adding example times to the new chart
        [[_WaitTimesArray objectAtIndex:0] addObject: @"30"];
        [[_WaitTimesArray objectAtIndex:0] addObject: @"20"];
        [[_WaitTimesArray objectAtIndex:0] addObject: @"10"];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"waitTimesFile"];
        [_WaitTimesArray writeToFile:filePath atomically:YES];
        
    }
    if (_ChartNamesArray==NULL){
        
        _RoutineNamesArray = [NSMutableArray array];
        [_RoutineNamesArray addObject: @"Example Workout"];
        
        _ChartNamesArray = [NSMutableArray array];
        //Adding a new chart
        [_ChartNamesArray addObject: [NSMutableArray array]];
        [[_ChartNamesArray objectAtIndex:0] addObject:@"A"];
        [[_ChartNamesArray objectAtIndex:0] addObject:@"B"];
        [[_ChartNamesArray objectAtIndex:0] addObject:@"C"];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
        [_ChartNamesArray writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"routineNamesFile"];
        [_RoutineNamesArray writeToFile:filePath atomically:YES];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //When the chart is touched, open the start screen, sending the chart ID to the next screen
    _TouchedIndex=indexPath.row;
    NSLog(@"Touched index: %d",indexPath.row);
    [self performSegueWithIdentifier: @ "GoToMain" sender: self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"GoToMain"]){
        ViewController *controller = (ViewController *)segue.destinationViewController;
        controller.ChosenWorkout=_TouchedIndex;
    }
}

#pragma mark Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [_RoutineNamesArray objectAtIndex:indexPath.row];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Required method for not losing data after changing viewcontrollers. Its supposed to be empty
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

@end
