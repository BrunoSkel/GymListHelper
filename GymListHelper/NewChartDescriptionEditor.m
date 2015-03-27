//
//  NewChartDescriptionEditor.m
//  GymListHelper
//
//  Created by Danilo S Marshall on 3/26/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import "NewChartDescriptionEditor.h"
#import "ChartsMenu.h"

#define PICKER_MIN 1
#define PICKER_MAX 60

@interface NewChartDescriptionEditor ()
@property (strong, nonatomic) IBOutlet UITextField *ChartNameNew;
@property (strong, nonatomic) IBOutlet UITextField *ChartObjective;

@end

@implementation NewChartDescriptionEditor

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Pickerview default stuff
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (self.ChartNameNew.text.length > 0) {
        ChartsMenu *controller = (ChartsMenu *)segue.destinationViewController;
        
        //SAVE CHART
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath;
        
        //Add new workout, and a subworkout A and B since segmented control doesnt allow only one segment
        [controller.allChartData addObject: [NSMutableArray array]];
        NSInteger newposition=[controller.allChartData count]-1;
        NSLog(@"New position = %d",newposition);
        [[controller.allChartData objectAtIndex:newposition] addObject: [NSMutableArray array]];
        [[controller.allChartData objectAtIndex:newposition] addObject: [NSMutableArray array]];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
        [controller.allChartData writeToFile:filePath atomically:YES];
        
        [controller.ChartNamesArray addObject: self.ChartNameNew.text];
        filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
        [controller.ChartNamesArray writeToFile:filePath atomically:YES];
        
        //SAVE CHART END
        
        //Update Data
        [controller.tableData removeAllObjects];
        controller.tableData=[NSMutableArray arrayWithArray:controller.allChartData];
        
    }
}

//Picker stuff

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
