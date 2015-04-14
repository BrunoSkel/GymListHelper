//
//  ViewController.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/18/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//
// DanMarsh
// Rodrigo
// Bruno

#import "ViewController.h"
#import "DoExerciseScreen.h"
#import "EditChartTableCell.h"
#import "ChartEditor.h"
#import "ExerciseInfoScreen.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISegmentedControl *SegmentControlOutlet;
@property (strong) IBOutlet UITableView *tableView;
@property NSArray *pickerData;
@property NSMutableArray *ChartNamesArray;
@property NSString *selectedCooldown;
@property (strong, nonatomic) IBOutlet UILabel *ChartNameLabel;

@property NSString *retrievedSeries;
@property NSString *retrievedRep;
@property NSString *retrievedName;

@end

@implementation ViewController

#pragma mark OnLoad

- (void)viewDidLoad {
    
    //HOW TO SYNC STUFF: Init with a suite name (think of how PlayerPrefs work), add stuff with a "key input" (Just like the playerpref strings), and use the sync method
    
    //NSString* myString = [myTextField text];
    //self.myLabel.text = myString;
    
    
    //NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.sharingdata"];
    //[mySharedDefaults setObject:myString forKey:@"savedUserInput"];
    //[mySharedDefaults synchronize];
    
    //Real stuff begins here
    
    [super viewDidLoad];
    //Initialize Watch syncing.
    _SharedData = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.coffeetime.Watch"];
    
    //Table data is where the chart data is written to. It's the array that gets printed on the screen.
    
    _tableData= [[NSMutableArray alloc]init];
    //The chart data is loaded from a file.
    [self LoadChartsFromFile];
    
    //Check number of subroutines
    NSLog(@"%lud",(unsigned long)[self.allChartData[self.ChosenWorkout] count]);
    [self FillSegment];
    
    //When he opens the app, workout A from the first chart will show up.
    //First objectAtIndex = Chart. Second = A/B/C/D/E as 0/1/2/3/4/5
    //_ChosenWorkout=0;
    self.ChartNameLabel.text=[NSString stringWithFormat:@"%@",self.RoutineNamesArray[self.ChosenWorkout]];
    self.tableData=[NSMutableArray arrayWithArray:self.allChartData[self.ChosenWorkout][0]];
    
    //Reloads the table to show up properly on the screen
    [self.tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Test
    //[self MultiDimensionTest];
    //Now let's send the _tableData and resttime contents to the Watch
    [self SyncWithWatch];
    
}


//Testing the three dimension array
- (void)MultiDimensionTest{
    NSLog(@"Starting Test");
    NSMutableArray *strings = [NSMutableArray array];
    for(int i = 0; i < 2; i++)
    {
        [strings addObject: [NSMutableArray array]];
        [strings[i] addObject:[NSMutableArray array]];
        [strings[i] addObject:[NSMutableArray array]];
    }
    
    [strings[0][0] addObject:@"This is 0,0,0"];
    [strings[1][0] addObject:@"This is 1,0,0"];
    [strings[1][0] addObject:@"This is 1,0,1"];
    NSLog(@"Test: %@",strings[0][0][0]);
    NSLog(@"Test: %@",strings[1][0][0]);
    NSLog(@"Test: %@",strings[1][0][1]);
}

- (void)SyncWithWatch{
    //Adding tableData to PlayerPref currentChart
    [self.SharedData setObject:self.tableData forKey:@"currentChart"];
    //Adding Wait Time (string: converted on Watch) to PlayerPref currentWaitTime
    [self.SharedData setObject:self.WaitTimesArray[self.ChosenWorkout][self.SegmentControlOutlet.selectedSegmentIndex] forKey:@"currentWaitTime"];
    [self.SharedData synchronize];
}

- (void)LoadChartsFromFile{
    
    //Load the saved charts. If there's nothing, fill the charts with the example data.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    _allChartData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
    
    _ChartNamesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"routineNamesFile"];
    
    _RoutineNamesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"waitTimesFile"];
    
    _WaitTimesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"infoDataFile"];
    
    self.allInfoData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
}

#pragma mark Delegate Methods

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
    

    //Name Decompose
    EditChartTableCell* theRow = cell;
    [self retrieveInformation:indexPath.row];
    //
    [theRow.ExName setText:self.retrievedName];
    [theRow.SeriesRepsLabel setText:[NSString stringWithFormat:@"Series: %@ | Reps: %@",self.retrievedSeries,self.retrievedRep]];
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


//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //
    //_selectedCooldown = [self pickerView:_PickerView titleForRow:[_PickerView selectedRowInComponent:0] forComponent:0];
    
    //NSLog(@"%@",_selectedCooldown);
    
//}

#pragma mark Buttons

- (IBAction)OnStartPressed:(id)sender {
}

- (IBAction)OnSegmentPressed:(id)sender {
    //When he changes from A-B-C, I need to reload the tableData according to the correct chart
    
    [self.tableData removeAllObjects];
    UISegmentedControl *s = (UISegmentedControl *)sender;
    self.tableData=[NSMutableArray arrayWithArray:self.allChartData[self.ChosenWorkout][s.selectedSegmentIndex]];
    [self.tableView reloadData];
    
    //And then, I sync the tableData with the Watch
    [self SyncWithWatch];
}

#pragma mark OnSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goToExercise"]){
        DoExerciseScreen *controller = (DoExerciseScreen *)segue.destinationViewController;
        controller.exercisedata=self.tableData;
        controller.chartname=[NSString stringWithFormat:@"%@ Chart",[self.SegmentControlOutlet titleForSegmentAtIndex:self.SegmentControlOutlet.selectedSegmentIndex]];
        //Converting cooldown string to int
        self.selectedCooldown = self.WaitTimesArray[self.ChosenWorkout][self.SegmentControlOutlet.selectedSegmentIndex];
        controller.cooldownAmount=[self.selectedCooldown intValue];
        //controller.cooldownAmount=2;
    }
    
    if([segue.identifier isEqualToString:@"EditRoutine"]){
        ChartEditor *controller = (ChartEditor *)segue.destinationViewController;
        controller.ChosenWorkout=self.ChosenWorkout;
    }
    
        
    if([segue.identifier isEqualToString:@"ExerciseInfo"]){
            ExerciseInfoScreen *controller = (ExerciseInfoScreen *)segue.destinationViewController;
        
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        
        
        controller.fullname=_allChartData[_ChosenWorkout][_SegmentControlOutlet.selectedSegmentIndex][indexPath.row];
        
        controller.infodata=_allInfoData[_ChosenWorkout][_SegmentControlOutlet.selectedSegmentIndex][indexPath.row];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)FillSegment{
    //Starts with 2 segments. Searches chartData to see if there are more, and add them
    for (int i=2; i<[self.allChartData[self.ChosenWorkout] count];i++){
        [self.SegmentControlOutlet insertSegmentWithTitle:@"New" atIndex:i animated:NO];
    }
    
    //Apply subroutine names to segmented control
    
    [self UpdateSegmentNames];
}

-(void)UpdateSegmentNames{
    for (int i=0;i<_SegmentControlOutlet.numberOfSegments;i++){
        [self.SegmentControlOutlet setTitle:self.ChartNamesArray[self.ChosenWorkout][i] forSegmentAtIndex:i];
    }
}

//When it unwinds
-(void)Unwinded{
    [self LoadChartsFromFile];
    //[self UpdateSegmentNames];
    //Reset Segment Outlet, as there are new subroutines, or deleted ones
    if (self.SegmentControlOutlet.numberOfSegments!=[self.allChartData[self.ChosenWorkout] count]){
        while (self.SegmentControlOutlet.numberOfSegments>2){
            [self.SegmentControlOutlet removeSegmentAtIndex:self.SegmentControlOutlet.numberOfSegments-1 animated:NO];
        }
        NSLog(@"NumberOfSegments: %ld | Count: %ld",(unsigned long)self.SegmentControlOutlet.numberOfSegments,(unsigned long)[self.allChartData[self.ChosenWorkout] count]);
        [self FillSegment];
    }
    [self UpdateSegmentNames];
    self.SegmentControlOutlet.selectedSegmentIndex=0;
    self.tableData=[NSMutableArray arrayWithArray:self.allChartData[self.ChosenWorkout][[self.SegmentControlOutlet selectedSegmentIndex]]];
    [self.tableView reloadData];
}

//Required method for not losing data after changing viewcontrollers. Its supposed to be empty
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    NSLog(@"Called");
    [self Unwinded];
}

@end
