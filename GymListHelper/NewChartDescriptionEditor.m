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
@property (strong, nonatomic) IBOutlet UIButton *DeleteButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelBut;
@property (strong, nonatomic) IBOutlet UITextField *ChartObjective;
@end

@implementation NewChartDescriptionEditor

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ChartNameNew.delegate=self;
    //_isEdit=NO;
}

//Make the keyboard dissapear after editing textfields======================
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
        [theTextField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
//================================================================

-(void)editMode{
    NSLog(@"cheguei");
    _isEdit=YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"view will appear");
    if (_isEdit==YES){
        _ChartNameNew.text=[_sentNameArray objectAtIndex:_EditThisRoutine];
        [_MainLabel setText:@"Edit Routine"];
        _DeleteButton.hidden=NO;
    }
    else{
        _DeleteButton.hidden=YES;
        _ChartNameNew.text=@"New Routine";
        [_MainLabel setText:@"Add New Routine"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Checking if he pressed the delete button
    UIButton *button = (UIButton *)sender;
    if (button==_DeleteButton){
        ChartsMenu *controller = (ChartsMenu *)segue.destinationViewController;
        //SAVE CHART
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath;
        
        //Delete the Exercises from this routine
        
        [controller.allChartData removeObjectAtIndex:_EditThisRoutine];
        filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
        [controller.allChartData writeToFile:filePath atomically:YES];
        
        //Delete the routine name
        [controller.RoutineNamesArray removeObjectAtIndex:_EditThisRoutine];
        
        //Delete the subroutine names
        [controller.ChartNamesArray removeObjectAtIndex:_EditThisRoutine];
        
        //Delete wait times associated to this chart
        [controller.WaitTimesArray removeObjectAtIndex:_EditThisRoutine];
        
        //Delete the owner data
        [controller.ByUserArray removeObjectAtIndex:_EditThisRoutine];
        
        //And save everything
        
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
        
        //Now reload
        [controller.tableData removeAllObjects];
        controller.tableData=[NSMutableArray arrayWithArray:controller.allChartData];
        [controller.tableView reloadData];
        return;
    }
    //Check if hes editing or creating a new chart
    if (_isEdit==YES){
        NSLog(@"Saving Edition");
        if (self.ChartNameNew.text.length > 0 && sender!=self.cancelBut) {
            ChartsMenu *controller = (ChartsMenu *)segue.destinationViewController;
            
            //SAVE CHART
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filePath;
            
            //Add new workout, and a subworkout A and B since segmented control doesnt allow only one segment
            
            
            //Adding new chart name
            NSLog(@"Old: %@",[controller.RoutineNamesArray objectAtIndex:_EditThisRoutine]);
            [controller.RoutineNamesArray replaceObjectAtIndex:_EditThisRoutine withObject:self.ChartNameNew.text];
                        NSLog(@"New: %@",[controller.RoutineNamesArray objectAtIndex:_EditThisRoutine]);
            
            filePath = [documentsDirectory
                        stringByAppendingPathComponent:@"routineNamesFile"];
            [controller.RoutineNamesArray writeToFile:filePath atomically:YES];
            
            
            //SAVE CHART END
            
            //Update Data
            [controller.tableData removeAllObjects];
            controller.tableData=[NSMutableArray arrayWithArray:controller.allChartData];
            [controller.tableView reloadData];
            
        }

        return;
    }
    
    if (self.ChartNameNew.text.length > 0 && sender!=self.cancelBut) {
        ChartsMenu *controller = (ChartsMenu *)segue.destinationViewController;
        
        //SAVE CHART
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath;
        
        //Add new workout, and a subworkout A and B since segmented control doesnt allow only one segment
        [controller.allChartData addObject: [NSMutableArray array]];
        NSInteger newposition=[controller.allChartData count]-1;
        NSLog(@"New position = %ld",(long)newposition);
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
        [controller.tableView reloadData];
        
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
