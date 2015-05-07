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
@property NSString *retrievedSeries;
@property NSString *retrievedRep;
@property NSString *retrievedName;
@property NSString* language;
@property NSString* addexerciseto;
@property NSString* deletestring;
@property NSString* addsubworkout;
@property NSString* exerciselist;
//Timer to flash the scroll indicator
@property NSTimer *timer;
@end

@implementation ChartEditor

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _language = [[NSLocale preferredLanguages] objectAtIndex:0];
        _addexerciseto=@"Add Exercise to";
        _deletestring=@"Delete";
        _addsubworkout=@"Add sub-routines";
        _exerciselist=@"Exercise List: Touch to Edit";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Save to chart indicates the currently chosen chart. It's to know which chart to save. Starts at 0 because the first chart is the first that shows up
    self.saveToChart=0;
    self.allChartData = [NSMutableArray array];
    
    // Old viewonappear
    
    if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
        _addexerciseto=@"Adicionar Exercicio em";
        _deletestring=@"Deletar";
        _addsubworkout=@"Adicionar sub-treino";
        _exerciselist=@"Ficha: Toque para Editar";
    }
    
    [self loadInitialData];
    [self FillSegment];
    //When he opens the app, workout A from the first chart will show up.
    //First objectAtIndex = Chart. Second = A/B/C/D/E as 0/1/2/3/4/5
    self.tableData=[NSMutableArray arrayWithArray:[[self.allChartData objectAtIndex:self.ChosenWorkout] objectAtIndex:0]];
    [self.tableView reloadData];
    
    //Delete only shows up if it's C onwards. Cant have less than 2 segments.
    self.DeleteSubRoutine.hidden=YES;
    [self.AddExerciseLabel setTitle:[NSString stringWithFormat:@"%@ '%@'",self.addexerciseto,[self.SegmentControlOutlet titleForSegmentAtIndex:self.SegmentControlOutlet.selectedSegmentIndex]] forState:UIControlStateNormal];
    // [self.AddExerciseLabel setTitle:[NSString stringWithFormat:@"Add exercise to routine"] forState:UIControlStateNormal];
    
    //Namefield initial text=Subroutine saved name
    self.RoutineNameField.text=[self.SegmentControlOutlet titleForSegmentAtIndex:self.SegmentControlOutlet.selectedSegmentIndex];
    self.RoutineNameField.delegate=self;
    
    [self UpdateWaitPicker];
    
    //
    
}

-(void)viewWillAppear:(BOOL)animated{
    
        [super viewWillAppear:animated];
    
    NSLog(@"Showing Chart Editor");
    
}

//Flash scroll indicator

-(void)viewDidAppear:(BOOL)animated{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(indicator:) userInfo:nil repeats:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [_timer invalidate];
}

//Make the keyboard dissapear after editing textfields======================
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
//================================================================


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
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"infoDataFile"];
    
    self.allInfoData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"picDataFile"];
    
    self.allPicData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
}

- (void)SaveCharts{
    //SAVE CHARTS
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    [self.allChartData writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
    
    [self.ChartNamesArray writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"waitTimesFile"];
    
    [self.WaitTimesArray writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"infoDataFile"];
    
    [self.allInfoData writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"picDataFile"];
    
    [self.allPicData writeToFile:filePath atomically:YES];
    
}

//When Pickerview Updates
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *newObject=[NSString stringWithFormat:@"%ld",(long)[self.pickerView selectedRowInComponent:0]];
    
    [[self.WaitTimesArray objectAtIndex:self.ChosenWorkout] replaceObjectAtIndex:self.SegmentControlOutlet.selectedSegmentIndex withObject:newObject];
    
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
    [self.tableData removeAllObjects];
    self.tableData=[NSMutableArray arrayWithArray:self.allChartData[self.ChosenWorkout][self.saveToChart]];
    [self.tableView reloadData];
}

- (IBAction)moveCellDown:(UIButton *)sender {
    NSIndexPath *indexPath = [self getButtonIndexPath:sender];
    
    // If row is the last row, btn shouldn't be available
    if(indexPath.row < [[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:_saveToChart] count]-1) {
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
    _TouchedIndex=(int)indexPath.row;
    [self performSegueWithIdentifier:@"EditExercise" sender:self];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        default:
            sectionName = self.exerciselist;
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
    
    EditChartTableCell* theRow = cell;
    //Name Decompose
    [self retrieveInformation:indexPath.row];
    //
    [theRow.ExName setText:self.retrievedName];
    [theRow.SeriesRepsLabel setText:[NSString stringWithFormat:@"Series: %@ | Reps: %@",self.retrievedSeries,self.retrievedRep]];
    
   // cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    
    /*
    int max=[[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:_saveToChart] count]-1;
    
    EditChartTableCell *thiscell = cell;
    
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

-(void)retrieveInformation:(int) i{
    
    //String is recieved as NAME | seriesXrep. Separate those to edit the exercise properly
    
    NSString *fullinfo=[self.tableData objectAtIndex:i];
    
    NSArray *CurrentExerciseData = [[NSArray alloc] init];
    CurrentExerciseData=[fullinfo componentsSeparatedByString:@"|"];
    
    //stringbyTrimming = Remove spaces from start and the end
    
    self.retrievedName=[[CurrentExerciseData objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];;
    
    NSArray *RepCountInformation = [[NSArray alloc] init];
    
    RepCountInformation=[[CurrentExerciseData objectAtIndex:1]componentsSeparatedByString:@"x"];
    
    self.retrievedSeries=[[RepCountInformation objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    self.retrievedRep=[[RepCountInformation objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}

- (IBAction)OnSegmentPressed:(id)sender {
    [_tableData removeAllObjects];
    UISegmentedControl *s = (UISegmentedControl *)sender;
    //When the segment is touched, change tableData to the according correct new chart
    _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:s.selectedSegmentIndex]];
    _saveToChart=(int)s.selectedSegmentIndex;
    
    [self.tableView reloadData];
    
    
    [self.AddExerciseLabel setTitle:[NSString stringWithFormat:@"%@ '%@'",self.addexerciseto,[self.SegmentControlOutlet titleForSegmentAtIndex:self.SegmentControlOutlet.selectedSegmentIndex]] forState:UIControlStateNormal];
    
    if (s.selectedSegmentIndex>0) {
        [self.DeleteSubRoutine setTitle:[NSString stringWithFormat:@"%@ '%@'",self.deletestring,[self.SegmentControlOutlet titleForSegmentAtIndex:self.SegmentControlOutlet.selectedSegmentIndex]] forState:UIControlStateNormal];
        
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
    
    //Update Names
    
    [self.DeleteSubRoutine setTitle:[NSString stringWithFormat:@"%@ '%@'",self.deletestring,[self.SegmentControlOutlet titleForSegmentAtIndex:self.SegmentControlOutlet.selectedSegmentIndex]] forState:UIControlStateNormal];
    
    [self.AddExerciseLabel setTitle:[NSString stringWithFormat:@"%@ '%@'",self.addexerciseto,[self.SegmentControlOutlet titleForSegmentAtIndex:self.SegmentControlOutlet.selectedSegmentIndex]] forState:UIControlStateNormal];
    
    [self SaveCharts];
    
}

- (IBAction)DeleteSubRoutine:(id)sender {
    //Delete chart and name array objects
  [[_allChartData objectAtIndex:_ChosenWorkout] removeObjectAtIndex:_SegmentControlOutlet.selectedSegmentIndex];
  [[_allInfoData objectAtIndex:_ChosenWorkout] removeObjectAtIndex:_SegmentControlOutlet.selectedSegmentIndex];
  [[_allPicData objectAtIndex:_ChosenWorkout] removeObjectAtIndex:_SegmentControlOutlet.selectedSegmentIndex];
  [[_ChartNamesArray objectAtIndex:_ChosenWorkout] removeObjectAtIndex:_SegmentControlOutlet.selectedSegmentIndex];
  [[_WaitTimesArray objectAtIndex:_ChosenWorkout] removeObjectAtIndex:_SegmentControlOutlet.selectedSegmentIndex];
    
    [_SegmentControlOutlet removeSegmentAtIndex:_SegmentControlOutlet.selectedSegmentIndex animated:YES];
    
    _SegmentControlOutlet.selectedSegmentIndex=0;
    
    if (_SegmentControlOutlet.selectedSegmentIndex==0)
        _DeleteSubRoutine.hidden=YES;
    else
        _DeleteSubRoutine.hidden=NO;
    
    if ([_SegmentControlOutlet numberOfSegments]<5){
        _AddSubRoutine.hidden=NO;
    }
    
    //Update table data to the first segment
    
    _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:_SegmentControlOutlet.selectedSegmentIndex]];
    _saveToChart=(int)_SegmentControlOutlet.selectedSegmentIndex;
    [self.tableView reloadData];
    
    [self SaveCharts];
}

- (IBAction)AddSubRoutine:(id)sender {
    
    [[_allChartData objectAtIndex:_ChosenWorkout] addObject: [NSMutableArray array]];
    [[_allInfoData objectAtIndex:_ChosenWorkout] addObject: [NSMutableArray array]];
    [[_allPicData objectAtIndex:_ChosenWorkout] addObject: [NSMutableArray array]];
    [[_ChartNamesArray objectAtIndex:_ChosenWorkout] addObject:@"B"];
    [[_WaitTimesArray objectAtIndex:_ChosenWorkout] addObject:@"30"];
    [_SegmentControlOutlet insertSegmentWithTitle:@"B" atIndex:[_SegmentControlOutlet numberOfSegments] animated:YES];
    
    [self SaveCharts];
    
    //Prevent user from having more than 5 subrouts
    
    if ([_SegmentControlOutlet numberOfSegments]>=5){
        _AddSubRoutine.hidden=YES;
    }
    
}

-(void)FillSegment{
    
    while (self.SegmentControlOutlet.numberOfSegments>1){
        [self.SegmentControlOutlet removeSegmentAtIndex:self.SegmentControlOutlet.numberOfSegments-1 animated:NO];
    }
    
    for (int i=1; i<[[_allChartData objectAtIndex:_ChosenWorkout] count];i++){
        [_SegmentControlOutlet insertSegmentWithTitle:@"C" atIndex:i animated:NO];
    }
    
    for (int i=0;i<_SegmentControlOutlet.numberOfSegments;i++){
        [_SegmentControlOutlet setTitle:[[_ChartNamesArray objectAtIndex:_ChosenWorkout] objectAtIndex:i] forSegmentAtIndex:i];
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"EditExercise"]){
        
        UINavigationController *navController = [segue destinationViewController];
        AddItem *controller = (AddItem *)([navController viewControllers][0]);
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