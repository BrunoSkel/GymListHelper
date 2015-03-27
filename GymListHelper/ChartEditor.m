//
//  ChartEditor.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/19/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import "ChartEditor.h"
#import "ViewController.h"
#define PICKER_MIN 0
#define PICKER_MAX 60

@interface ChartEditor ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *SegmentControlOutlet;
@property (strong, nonatomic) IBOutlet UIButton *AddSubRoutine;
@property (strong, nonatomic) IBOutlet UIButton *DeleteSubRoutine;
@property (strong, nonatomic) IBOutlet UITextField *RoutineNameField;
@property (strong, nonatomic) IBOutlet UIButton *AddExerciseLabel;
@end

@implementation ChartEditor

- (void)viewDidLoad {
    [super viewDidLoad];
    //Save to chart indicates the currently chosen chart. It's to know which chart to save. Starts at 0 because the first chart is the first that shows up
    _saveToChart=0;
    self.allChartData = [NSMutableArray array];
    
    [self loadInitialData];
    [self FillSegment];
    //When he opens the app, workout A from the first chart will show up.
    //First objectAtIndex = Chart. Second = A/B/C/D/E as 0/1/2/3/4/5
    _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:0]];
    [self.tableView reloadData];
    
    //Delete only shows up if it's C onwards. Cant have less than 2 segments.
    _DeleteSubRoutine.hidden=YES;
    [_AddExerciseLabel setTitle:[NSString stringWithFormat:@"Add Exercise to '%@'",[_SegmentControlOutlet titleForSegmentAtIndex:_SegmentControlOutlet.selectedSegmentIndex]] forState:UIControlStateNormal];
    
    //Namefield initial text=Subroutine saved name
        _RoutineNameField.text=[_SegmentControlOutlet titleForSegmentAtIndex:_SegmentControlOutlet.selectedSegmentIndex];
    
}

- (void)loadInitialData {
    //Loads Chart data. Doesn't need the null check this time, as they will be filled by now
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    _allChartData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
    
    _ChartNamesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
}

- (void)SaveCharts{
    //SAVE CHARTS
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    [_allChartData writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
    
    [_ChartNamesArray writeToFile:filePath atomically:YES];
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
    
    //
    
    [_DeleteSubRoutine setTitle:[NSString stringWithFormat:@"Delete '%@'",[_SegmentControlOutlet titleForSegmentAtIndex:_SegmentControlOutlet.selectedSegmentIndex]] forState:UIControlStateNormal];
    
        [_AddExerciseLabel setTitle:[NSString stringWithFormat:@"Add Exercise to '%@'",[_SegmentControlOutlet titleForSegmentAtIndex:_SegmentControlOutlet.selectedSegmentIndex]] forState:UIControlStateNormal];
    
    if (s.selectedSegmentIndex>1)
        _DeleteSubRoutine.hidden=NO;
    else
        _DeleteSubRoutine.hidden=YES;
    
    _RoutineNameField.text=[_SegmentControlOutlet titleForSegmentAtIndex:_SegmentControlOutlet.selectedSegmentIndex];
    
}


//When he types a new name
- (IBAction)textFieldChange:(id)sender {
    [_SegmentControlOutlet setTitle:_RoutineNameField.text forSegmentAtIndex:_SegmentControlOutlet.selectedSegmentIndex];
    
    [[_ChartNamesArray objectAtIndex:_ChosenWorkout]replaceObjectAtIndex:_SegmentControlOutlet.selectedSegmentIndex withObject:_RoutineNameField.text];
    
    [self SaveCharts];
    
}

- (IBAction)DeleteSubRoutine:(id)sender {
    //Delete chart and name array objects
  [[_allChartData objectAtIndex:_ChosenWorkout] removeObjectAtIndex:_SegmentControlOutlet.selectedSegmentIndex];
  [[_ChartNamesArray objectAtIndex:_ChosenWorkout] removeObjectAtIndex:_SegmentControlOutlet.selectedSegmentIndex];
    
    [_SegmentControlOutlet removeSegmentAtIndex:_SegmentControlOutlet.selectedSegmentIndex animated:YES];
    
    _SegmentControlOutlet.selectedSegmentIndex=0;
    
    if (_SegmentControlOutlet.selectedSegmentIndex>1)
        _DeleteSubRoutine.hidden=NO;
    else
        _DeleteSubRoutine.hidden=YES;
    
    //Update table data to the first segment
    
    _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:_SegmentControlOutlet.selectedSegmentIndex]];
    _saveToChart=_SegmentControlOutlet.selectedSegmentIndex;
    [self.tableView reloadData];
    
    [self SaveCharts];
}

- (IBAction)AddSubRoutine:(id)sender {
    [[_allChartData objectAtIndex:_ChosenWorkout] addObject: [NSMutableArray array]];
    [[_ChartNamesArray objectAtIndex:_ChosenWorkout] addObject:@"New"];
    
    [_SegmentControlOutlet insertSegmentWithTitle:@"New" atIndex:[_SegmentControlOutlet numberOfSegments] animated:YES];
    
    [self SaveCharts];
}

-(void)FillSegment{
    for (int i=2; i<[[_allChartData objectAtIndex:_ChosenWorkout] count];i++){
        [_SegmentControlOutlet insertSegmentWithTitle:@"C" atIndex:i animated:NO];
    }
    
    for (int i=0;i<_SegmentControlOutlet.numberOfSegments;i++){
        [_SegmentControlOutlet setTitle:[[_ChartNamesArray objectAtIndex:_ChosenWorkout] objectAtIndex:i] forSegmentAtIndex:i];
    }
    
    
}

//Required method for not losing data after changing viewcontrollers. Its supposed to be empty
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

//PickerStuff

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (PICKER_MAX-PICKER_MIN+1);
}

//The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d", (row+PICKER_MIN)];
    //[_PickerView selectedRowInComponent:0];
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


@end