//
//  NewChartDescriptionEditor.m
//  GymListHelper
//
//  Created by Danilo S Marshall on 3/26/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "NewChartDescriptionEditor.h"
#import "ChartsMenu.h"

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
        NSLog(@"New position = %ld",newposition);
        [[controller.allChartData objectAtIndex:newposition] addObject: [NSMutableArray array]];
        [[controller.allChartData objectAtIndex:newposition] addObject: [NSMutableArray array]];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
        [controller.allChartData writeToFile:filePath atomically:YES];
        
        //Adding new chart name
        [controller.RoutineNamesArray addObject: self.ChartNameNew.text];
        
        //And A and B string names
        [controller.ChartNamesArray addObject: [NSMutableArray array]];
        
        [[controller.ChartNamesArray objectAtIndex:newposition] addObject: @"A"];
        [[controller.ChartNamesArray objectAtIndex:newposition] addObject: @"B"];
        
        [controller.WaitTimesArray addObject: [NSMutableArray array]];
        [[controller.WaitTimesArray objectAtIndex:newposition] addObject: @"30"];
        [[controller.WaitTimesArray objectAtIndex:newposition] addObject: @"30"];
        
        //Adding owner user for this new Chart
        [controller.ByUserArray addObject: @"0§myself§0"];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"chartNamesFile"];
        [controller.ChartNamesArray writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"routineNamesFile"];
        [controller.RoutineNamesArray writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"waitTimesFile"];
        [controller.WaitTimesArray writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"byUserFile"];
        [controller.ByUserArray writeToFile:filePath atomically:YES];
        
        //SAVE CHART END
        
        //Update Data
        [controller.tableData removeAllObjects];
        controller.tableData=[NSMutableArray arrayWithArray:controller.allChartData];
        
    }
}

//Picker stuff
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
