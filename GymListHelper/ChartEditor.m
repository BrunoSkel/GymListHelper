//
//  ChartEditor.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/19/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "ChartEditor.h"
#import "ViewController.h"
#import "EditChartTableCell.h"
#import "AddItem.h"
#define PICKER_MIN 0
#define PICKER_MAX 60

@interface ChartEditor ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *SegmentControlOutlet;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIButton *AddSubRoutine;
@property (strong, nonatomic) IBOutlet UIButton *DeleteSubRoutine;
@property (strong, nonatomic) IBOutlet UITextField *RoutineNameField;
@property (strong, nonatomic) IBOutlet UIButton *AddExerciseLabel;
@property int TouchedIndex;
//Timer to flash the scroll indicator
@property NSTimer *timer;
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
   // [self.AddExerciseLabel setTitle:[NSString stringWithFormat:@"Add exercise to routine"] forState:UIControlStateNormal];
    
    //Namefield initial text=Subroutine saved name
        _RoutineNameField.text=[_SegmentControlOutlet titleForSegmentAtIndex:_SegmentControlOutlet.selectedSegmentIndex];
    
    [self UpdateWaitPicker];
    
}


//Character Limit on Sub-routine Names
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 10) ? NO : YES;
}

-(void)viewDidAppear:(BOOL)animated{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(indicator:) userInfo:nil repeats:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [_timer invalidate];
}

-(void)indicator:(BOOL)animated{
    [_tableView flashScrollIndicators];
}

- (void)loadInitialData {
    //Loads Chart data. Doesn't need the null check this time, as they will be filled by now
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    _allChartData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
    
    _ChartNamesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"waitTimesFile"];
    
    _WaitTimesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
}

- (void)SaveCharts{
    //SAVE CHARTS
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    [_allChartData writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
    
    [_ChartNamesArray writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"waitTimesFile"];
    
    [_WaitTimesArray writeToFile:filePath atomically:YES];
    
}

//When Pickerview Updates
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *newObject=[NSString stringWithFormat:@"%d",[_pickerView selectedRowInComponent:0]];
    
    [[_WaitTimesArray objectAtIndex:_ChosenWorkout] replaceObjectAtIndex:_SegmentControlOutlet.selectedSegmentIndex withObject:newObject];
    
    [self SaveCharts];
}


- (IBAction)moveCellUp:(UIButton *)sender {
    //UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSIndexPath *indexPath = [self getButtonIndexPath:sender];
    
    // If row is 0, btn shouldn't be available
    if(!(indexPath.row < 1)) {
        id aux = self.allChartData[self.ChosenWorkout][self.saveToChart][indexPath.row];
        [self.allChartData[self.ChosenWorkout][self.saveToChart] setObject:self.allChartData[self.ChosenWorkout][self.saveToChart][indexPath.row-1] atIndexedSubscript:indexPath.row];
        [self.allChartData[self.ChosenWorkout][self.saveToChart] setObject:aux atIndexedSubscript:(indexPath.row-1)];
    }
    
    [self SaveCharts];
    [_tableData removeAllObjects];
    _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:_saveToChart]];
    [self.tableView reloadData];
}

- (IBAction)moveCellDown:(UIButton *)sender {
    NSIndexPath *indexPath = [self getButtonIndexPath:sender];
    
    // If row is the last row, btn shouldn't be available
    if(indexPath.row < [[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:_saveToChart] count]-1) {
        NSLog(@"asd");
        id aux = self.allChartData[self.ChosenWorkout][self.saveToChart][indexPath.row];
        [self.allChartData[self.ChosenWorkout][self.saveToChart] setObject:self.allChartData[self.ChosenWorkout][self.saveToChart][indexPath.row+1] atIndexedSubscript:indexPath.row];
        [self.allChartData[self.ChosenWorkout][self.saveToChart] setObject:aux atIndexedSubscript:(indexPath.row+1)];
    }
    
    [self SaveCharts];
    [_tableData removeAllObjects];
    _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:_saveToChart]];
    [self.tableView reloadData];
}

//Deletes the exercise, when it's touched, according to the chosen segment
//When Touched, trigger the Edit window
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _TouchedIndex=indexPath.row;
    [self performSegueWithIdentifier:@"EditExercise" sender:self];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        default:
            sectionName = @"Exercise List: Touch to Edit";
            break;
    }
    return sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    
    int max=[[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:_saveToChart] count]-1;
    
   /* EditChartTableCell *thiscell = cell;
    
    if (indexPath.row==max){
        thiscell.DownButton.hidden=YES;
    }
    
    else if (indexPath.row==0){
        thiscell.UpButton.hidden=YES;
    }
    
    else{
        thiscell.DownButton.hidden=NO;
        thiscell.UpButton.hidden=NO;
    }*/
    
    return cell;
}

- (IBAction)OnSegmentPressed:(id)sender {
    [_tableData removeAllObjects];
    UISegmentedControl *s = (UISegmentedControl *)sender;
    //When the segment is touched, change tableData to the according correct new chart
    _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:s.selectedSegmentIndex]];
    _saveToChart=s.selectedSegmentIndex;
    
    [self.tableView reloadData];
    
    
    [self.AddExerciseLabel setTitle:[NSString stringWithFormat:@"Add Exercise to '%@'",[self.SegmentControlOutlet titleForSegmentAtIndex:self.SegmentControlOutlet.selectedSegmentIndex]] forState:UIControlStateNormal];
    
    if (s.selectedSegmentIndex>1) {
        [self.DeleteSubRoutine setTitle:[NSString stringWithFormat:@"Delete '%@'",[self.SegmentControlOutlet titleForSegmentAtIndex:self.SegmentControlOutlet.selectedSegmentIndex]] forState:UIControlStateNormal];
        
        self.DeleteSubRoutine.hidden=NO;
    } else
        self.DeleteSubRoutine.hidden=YES;
    
    self.RoutineNameField.text=[self.SegmentControlOutlet titleForSegmentAtIndex:self.SegmentControlOutlet.selectedSegmentIndex];
    
    //Set Pickerview to the correct WaitTime
    [self UpdateWaitPicker];
    
}

-(void) UpdateWaitPicker{
    NSString *thiscooldown=[[self.WaitTimesArray objectAtIndex:self.ChosenWorkout] objectAtIndex:self.SegmentControlOutlet.selectedSegmentIndex];
    [self.pickerView selectRow:[thiscooldown intValue] inComponent:0 animated:YES];
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
  [[_WaitTimesArray objectAtIndex:_ChosenWorkout] removeObjectAtIndex:_SegmentControlOutlet.selectedSegmentIndex];
    
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
    [[_WaitTimesArray objectAtIndex:_ChosenWorkout] addObject:@"30"];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"EditExercise"]){
        AddItem *controller = (AddItem *)segue.destinationViewController;
        controller.EditThisExercise=_TouchedIndex;
        controller.ChosenSubWorkout=_saveToChart;
        controller.ChosenWorkout=_ChosenWorkout;
        controller.sentArray=[NSMutableArray arrayWithArray:_allChartData];
        [controller editMode];
    }
    
}

-(NSIndexPath *) getButtonIndexPath:(UIButton *) button
{
    CGRect buttonFrame = [button convertRect:button.bounds toView:_tableView];
    return [_tableView indexPathForRowAtPoint:buttonFrame.origin];
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