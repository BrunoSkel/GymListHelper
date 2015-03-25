//
//  ViewController.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/18/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import "ViewController.h"
#import "DoExerciseScreen.h"

#define PICKER_MIN 1
#define PICKER_MAX 60

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISegmentedControl *SegmentControlOutlet;
@property (strong) IBOutlet UITableView *tableView;
@property NSArray *pickerData;
@property NSString *selectedCooldown;

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
    //When he opens the app, chartA is the first to show up, so we add the _chartA data to the _tableData.
    _tableData=[NSMutableArray arrayWithArray:_chartA];
    //Reloads the table to show up properly on the screen
    [self.tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
    //Pickerview default stuff
    self.PickerView.dataSource = self;
    self.PickerView.delegate = self;
    
    //Now let's send the _tableData contents to the Watch
    [self SyncWithWatch];
    
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
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartA"];
    
    _chartA = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    NSString *filePathB = [documentsDirectory stringByAppendingPathComponent:@"chartB"];
    
    _chartB = [NSMutableArray arrayWithContentsOfFile:filePathB];
    
    NSString *filePathC = [documentsDirectory stringByAppendingPathComponent:@"chartC"];
    
    _chartC = [NSMutableArray arrayWithContentsOfFile:filePathC];
    
    if (_chartA==NULL){
        NSLog(@"Chart A is Null");
    _chartA = [[NSMutableArray alloc]init];
    [_chartA addObject:@"Example A1 | 4x8"];
    [_chartA addObject:@"Example A2 | 4x8"];
    [_chartA addObject:@"Example A3 | 4x8"];
    [_chartA addObject:@"Example A4 | 4x8"];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartA"];
        
        [_chartA writeToFile:filePath atomically:YES];
    }
    
    if (_chartB==NULL){
        NSLog(@"Chart B is Null");
        _chartB = [[NSMutableArray alloc]init];
        [_chartB addObject:@"Example B1 | 3x15"];
        [_chartB addObject:@"Example B2 | 3x15"];
        [_chartB addObject:@"Example B3 | 3x15"];
        NSString *filePath2 = [documentsDirectory stringByAppendingPathComponent:@"chartB"];
        
        [_chartB writeToFile:filePath2 atomically:YES];
    }
     NSLog(@"%@",_chartB);
    
    if (_chartC==NULL){
        NSLog(@"Chart C is Null");
        _chartC = [[NSMutableArray alloc]init];
        [_chartC addObject:@"Example C1 | 4x10"];
        [_chartC addObject:@"Example C2 | 4x10"];
        NSString *filePath3 = [documentsDirectory stringByAppendingPathComponent:@"chartC"];
        
        [_chartC writeToFile:filePath3 atomically:YES];
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
    switch (s.selectedSegmentIndex) {
        case 0:
            _tableData=[NSMutableArray arrayWithArray:_chartA];
            break;
        case 1:
            _tableData=[NSMutableArray arrayWithArray:_chartB];
            break;
        case 2:
            _tableData=[NSMutableArray arrayWithArray:_chartC];
            break;
    }
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
