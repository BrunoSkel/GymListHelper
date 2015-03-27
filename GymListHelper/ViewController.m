//
//  ViewController.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/18/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//
// DanMarsh
// Rodrigo
// Bruno

#import "ViewController.h"
#import "DoExerciseScreen.h"
#import "ChartEditor.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISegmentedControl *SegmentControlOutlet;
@property (strong) IBOutlet UITableView *tableView;
@property NSArray *pickerData;
@property NSMutableArray *ChartNamesArray;
@property NSString *selectedCooldown;
@property (strong, nonatomic) IBOutlet UILabel *ChartNameLabel;

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
    NSLog(@"%d",[[_allChartData objectAtIndex:_ChosenWorkout] count]);
    for (int i=2; i<[[_allChartData objectAtIndex:_ChosenWorkout] count];i++){
        [_SegmentControlOutlet insertSegmentWithTitle:@"C" atIndex:i animated:NO];
    }
    //When he opens the app, workout A from the first chart will show up.
    //First objectAtIndex = Chart. Second = A/B/C/D/E as 0/1/2/3/4/5
    //_ChosenWorkout=0;
    _ChartNameLabel.text=[NSString stringWithFormat:@"%@",[_ChartNamesArray objectAtIndex:_ChosenWorkout]];
    _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:0]];
    //Reloads the table to show up properly on the screen
    [self.tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
    //Pickerview default stuff
    self.PickerView.dataSource = self;
    self.PickerView.delegate = self;
    //Test
    //[self MultiDimensionTest];
    //Now let's send the _tableData contents to the Watch
    [self SyncWithWatch];
    
}


//Testing the three dimension array
- (void)MultiDimensionTest{
    NSLog(@"Starting Test");
    NSMutableArray *strings = [NSMutableArray array];
    for(int i = 0; i < 2; i++)
    {
        [strings addObject: [NSMutableArray array]];
        [[strings objectAtIndex:i] addObject:[NSMutableArray array]];
        [[strings objectAtIndex:i] addObject:[NSMutableArray array]];
    }
    
    [[[strings objectAtIndex:0] objectAtIndex:0] addObject:@"This is 0,0,0"];
    [[[strings objectAtIndex:1] objectAtIndex:0] addObject:@"This is 1,0,0"];
    [[[strings objectAtIndex:1] objectAtIndex:0] addObject:@"This is 1,0,1"];
    NSLog(@"Test: %@",[[[strings objectAtIndex:0] objectAtIndex:0] objectAtIndex:0]);
    NSLog(@"Test: %@",[[[strings objectAtIndex:1] objectAtIndex:0] objectAtIndex:0]);
    NSLog(@"Test: %@",[[[strings objectAtIndex:1] objectAtIndex:0] objectAtIndex:1]);
}

- (void)SyncWithWatch{
    //Adding tableData to PlayerPref currentChart
    [_SharedData setObject:_tableData forKey:@"currentChart"];
    [_SharedData synchronize];
}

- (void)LoadChartsFromFile{
    
    //Load the saved charts. If there's nothing, fill the charts with the example data.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    _allChartData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
    
    _ChartNamesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
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
    
    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    return cell;
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
    
    [_tableData removeAllObjects];
    UISegmentedControl *s = (UISegmentedControl *)sender;
    _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:s.selectedSegmentIndex]];
    [self.tableView reloadData];
    
    //And then, I sync the tableData with the Watch
    [self SyncWithWatch];
}

#pragma mark OnSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goToExercise"]){
        DoExerciseScreen *controller = (DoExerciseScreen *)segue.destinationViewController;
        controller.exercisedata=_tableData;
        controller.chartname=[NSString stringWithFormat:@"%@ Chart",[_SegmentControlOutlet titleForSegmentAtIndex:_SegmentControlOutlet.selectedSegmentIndex]];
        //Converting cooldown string to int
        //   _selectedCooldown = [self pickerView:_PickerView titleForRow:[_PickerView selectedRowInComponent:0] forComponent:0];
        //controller.cooldownAmount=[_selectedCooldown intValue];
        controller.cooldownAmount=2;
    }
    
    if([segue.identifier isEqualToString:@"EditRoutine"]){
        ChartEditor *controller = (ChartEditor *)segue.destinationViewController;
        controller.ChosenWorkout=_ChosenWorkout;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//When it unwinds
-(void)Unwinded{
    [self LoadChartsFromFile];
    _tableData=[NSMutableArray arrayWithArray:[[_allChartData objectAtIndex:_ChosenWorkout] objectAtIndex:[_SegmentControlOutlet selectedSegmentIndex]]];
    [self.tableView reloadData];
}

//Required method for not losing data after changing viewcontrollers. Its supposed to be empty
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    NSLog(@"Called");
    [self Unwinded];
}

@end
