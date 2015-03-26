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

#define PICKER_MIN 1
#define PICKER_MAX 60

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISegmentedControl *SegmentControlOutlet;
@property (strong) IBOutlet UITableView *tableView;
@property NSArray *pickerData;
@property NSString *selectedCooldown;
@property int ChosenWorkout;

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
    //When he opens the app, workout A from the first chart will show up.
    //First objectAtIndex = Chart. Second = A/B/C/D/E as 0/1/2/3/4/5
    _ChosenWorkout=0;
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
    
    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    return cell;
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (PICKER_MAX-PICKER_MIN+1);
}

 //The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d", (row+PICKER_MIN)];
    //[_PickerView selectedRowInComponent:0];
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
           _selectedCooldown = [self pickerView:_PickerView titleForRow:[_PickerView selectedRowInComponent:0] forComponent:0];
        controller.cooldownAmount=[_selectedCooldown intValue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
