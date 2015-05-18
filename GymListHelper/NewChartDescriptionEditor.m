//
//  NewChartDescriptionEditor.m
//  GymListHelper
//
//  Created by Danilo S Marshall on 3/26/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "NewChartDescriptionEditor.h"
#import "ChartsMenu.h"
#import "GoalPicker.h"
#import "GoalCellController.h"

@interface NewChartDescriptionEditor ()
@property (strong, nonatomic) IBOutlet UIButton *saveBut;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *DeleteButton;
@property NSString *editroutinestring;
@property NSString *addroutinestring;
@property NSString *newroutinestring;
@property (strong, nonatomic) IBOutlet UITextView *routineInfoBox;
@property NSString *language;
@end
@implementation NewChartDescriptionEditor

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        //Translation initialization
        
        _editroutinestring=@"Edit Routine";
        _newroutinestring=@"New Routine";
        _language = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        
        //Chart categories needs to be created now, as the ViewController info will be soon be sent to the GoalPicker tableview
        self.ChartCategories = [NSMutableArray array];
        [self.ChartCategories addObject:@"YES"]; // Hypertrophy
        [self.ChartCategories addObject:@"NO"]; // Definition
        [self.ChartCategories addObject:@"NO"]; // Tonification
        [self.ChartCategories addObject:@"NO"]; // Fat Loss
        [self.ChartCategories addObject:@"NO"]; // Strength
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.ChartNameNew.delegate = self;
   /* self.switchHypertrophy.tag = 0;
    self.switchDefinition.tag = 1;
    self.switchTonification.tag = 2;
    self.switchFatLoss.tag = 3;
    self.switchStrengh.tag = 4;*/
    //_isEdit=NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
        
        _editroutinestring=@"Editar Treino";
        _newroutinestring=@"Novo Treino";
        
    }

    if (self.isEdit==YES){
        NSLog(@"%@",self.sentNameArray[self.EditThisRoutine][0]);
        self.ChartNameNew.text = self.sentNameArray[self.EditThisRoutine][0];
        self.routineInfoBox.text = self.sentNameArray[self.EditThisRoutine][1];
        [self.navigationItem setTitle:self.editroutinestring];
        self.DeleteButton.enabled = YES;
        
        // Check categories data and change switches
        self.ChartCategories = self.sentCategorieArray[self.EditThisRoutine];
        
    }
    else{
        self.DeleteButton.enabled = NO;
        self.ChartNameNew.text = self.newroutinestring;
        [self.navigationItem setTitle:self.newroutinestring];
        
        NSLog(@"Current chart: %@", self.ChartCategories);
    }
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
//==========================================================================

-(void)editMode{
    NSLog(@"cheguei");
    _isEdit=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Checking if he pressed the delete button
    UIButton *button = (UIButton *)sender;
    
    if ([segue.identifier isEqualToString:@"ContainerConnection"]){
        GoalCellController *controller = (GoalCellController *)segue.destinationViewController;
        controller.parent=self;
        return;
    }
    
    if (button==(UIButton*)self.DeleteButton){
        ChartsMenu *controller = (ChartsMenu *)segue.destinationViewController;
        
        //SAVE CHART
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        NSString *filePath;
        
        //Delete the Exercises from this routine
        
        [controller.allChartData removeObjectAtIndex:self.EditThisRoutine];
        filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
        [controller.allChartData writeToFile:filePath atomically:YES];
        
        //Delete weight data
        [controller.allWeightData removeObjectAtIndex:self.EditThisRoutine];
        filePath = [documentsDirectory stringByAppendingPathComponent:@"weightDataFile"];
        [controller.allWeightData writeToFile:filePath atomically:YES];
        
        //Delete all information
        
        [controller.allInfoData removeObjectAtIndex:self.EditThisRoutine];
        filePath = [documentsDirectory stringByAppendingPathComponent:@"infoDataFile"];
        [controller.allInfoData writeToFile:filePath atomically:YES];
        
        //Delete the routine name
        [controller.RoutineNamesArray removeObjectAtIndex:self.EditThisRoutine];
        
        //Delete the categories
        [controller.ChartCategoriesArray removeObjectAtIndex:self.EditThisRoutine];
        
        //Delete the subroutine names
        [controller.ChartNamesArray removeObjectAtIndex:self.EditThisRoutine];
        
        //Delete wait times associated to this chart
        [controller.WaitTimesArray removeObjectAtIndex:self.EditThisRoutine];
        
        //Delete pictures associated to this chart
        [controller.allPicData removeObjectAtIndex:self.EditThisRoutine];
        
        //Delete the owner data
        [controller.ByUserArray removeObjectAtIndex:self.EditThisRoutine];
        
        //And save everything
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"chartNamesFile"];
        [controller.ChartNamesArray writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"chartCategoriesFile"];
        [controller.ChartCategoriesArray writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"routineNamesFile"];
        [controller.RoutineNamesArray writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"waitTimesFile"];
        [controller.WaitTimesArray writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"byUserFile"];
        [controller.ByUserArray writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"picDataFile"];
        [controller.allPicData writeToFile:filePath atomically:YES];
        
        //Now reload
        [controller.tableData removeAllObjects];
        controller.tableData=[NSMutableArray arrayWithArray:controller.allChartData];
        [controller.tableView reloadData];
        return;
    }
    //Check if hes editing or creating a new chart
    if (self.isEdit==YES){
        NSLog(@"Saving Edition");
        if (button==self.saveBut && self.ChartNameNew.text.length > 0) {
            ChartsMenu *controller = (ChartsMenu *)segue.destinationViewController;
            
            //SAVE CHART
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filePath;
            
            //Add new workout, and a subworkout A and B since segmented control doesnt allow only one segment
            
            
            //Adding new chart name
            [controller.RoutineNamesArray[self.EditThisRoutine] replaceObjectAtIndex:0 withObject:self.ChartNameNew.text];
            [controller.RoutineNamesArray[self.EditThisRoutine] replaceObjectAtIndex:1 withObject:self.routineInfoBox.text];
            
            filePath = [documentsDirectory
                        stringByAppendingPathComponent:@"routineNamesFile"];
            [controller.RoutineNamesArray writeToFile:filePath atomically:YES];
            
            //Adding categories
            [self SaveSwitchValues];
            //NSLog(@"Current chart: %@", self.ChartCategories);
            [controller.ChartCategoriesArray replaceObjectAtIndex:self.EditThisRoutine withObject:self.ChartCategories];
            
            filePath = [documentsDirectory
                        stringByAppendingPathComponent:@"chartCategoriesFile"];
            [controller.ChartCategoriesArray writeToFile:filePath atomically:YES];
            
            
            //SAVE CHART END
            
            //Update Data
            [controller.tableData removeAllObjects];
            controller.tableData = [NSMutableArray arrayWithArray:controller.allChartData];
            [controller.tableView reloadData];
            
        }

        return;
    }
    
    if (self.ChartNameNew.text.length > 0 && button==self.saveBut) {
        ChartsMenu *controller = (ChartsMenu *)segue.destinationViewController;
        
        //SAVE CHART
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        NSString *filePath;
        
        //Add new workout, and a subworkout A
        [controller.allChartData addObject: [NSMutableArray array]];
        NSInteger newposition=[controller.allChartData count]-1;
        NSLog(@"New position = %ld",(long)newposition);
        [controller.allChartData[newposition] addObject: [NSMutableArray array]];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
        [controller.allChartData writeToFile:filePath atomically:YES];
        
        //Adding Information file for the chart
        //Add new workout, and a subworkout A
        [controller.allInfoData addObject: [NSMutableArray array]];
        [controller.allInfoData[newposition] addObject: [NSMutableArray array]];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"infoDataFile"];
        [controller.allInfoData writeToFile:filePath atomically:YES];
        
        //Adding Pictures file for the chart
        //Add new workout, and a subworkout A
        [controller.allPicData addObject: [NSMutableArray array]];
        [controller.allPicData[newposition] addObject: [NSMutableArray array]];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"picDataFile"];
        [controller.allPicData writeToFile:filePath atomically:YES];
        
        //Adding Weight file for the chart
        //Add new workout, and a subworkout A
        [controller.allWeightData addObject: [NSMutableArray array]];
        [controller.allWeightData[newposition] addObject: [NSMutableArray array]];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"weightDataFile"];
        [controller.allWeightData writeToFile:filePath atomically:YES];
        
        //Adding new chart name and description
        [controller.RoutineNamesArray addObject: [NSMutableArray array]];
        [controller.RoutineNamesArray[newposition] addObject: self.ChartNameNew.text];
        [controller.RoutineNamesArray[newposition] addObject: self.routineInfoBox.text];
        
        //And A string names
        [controller.ChartNamesArray addObject: [NSMutableArray array]];
        
        [controller.ChartNamesArray[newposition] addObject: @"A"];
        
        [controller.WaitTimesArray addObject: [NSMutableArray array]];
        [controller.WaitTimesArray[newposition] addObject: @"30"];
        
        //Adding categories
        [self SaveSwitchValues];
        //NSLog(@"Current chart: %@", self.ChartCategories);
        [controller.ChartCategoriesArray addObject:self.ChartCategories];
        
        //Adding owner user for this new Chart
        [controller.ByUserArray addObject: @"0§myself§0"];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"chartNamesFile"];
        [controller.ChartNamesArray writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"chartCategoriesFile"];
        [controller.ChartCategoriesArray writeToFile:filePath atomically:YES];
        
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

#pragma mark Auxiliar
- (void) SaveSwitchValues {
  /*  if(self.switchHypertrophy.isOn) [self.ChartCategories replaceObjectAtIndex:0 withObject:@"YES"];
    else [self.ChartCategories replaceObjectAtIndex:0 withObject:@"NO"];
    
    if(self.switchDefinition.isOn) [self.ChartCategories replaceObjectAtIndex:1 withObject:@"YES"];
    else [self.ChartCategories replaceObjectAtIndex:1 withObject:@"NO"];
    
    if(self.switchTonification.isOn) [self.ChartCategories replaceObjectAtIndex:2 withObject:@"YES"];
    else [self.ChartCategories replaceObjectAtIndex:2 withObject:@"NO"];
    
    if(self.switchFatLoss.isOn) [self.ChartCategories replaceObjectAtIndex:3 withObject:@"YES"];
    else [self.ChartCategories replaceObjectAtIndex:3 withObject:@"NO"];
    
    if(self.switchStrengh.isOn) [self.ChartCategories replaceObjectAtIndex:4 withObject:@"YES"];
    else [self.ChartCategories replaceObjectAtIndex:4 withObject:@"NO"];*/
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
/*- (IBAction)switchObjective:(id)sender {
    if([sender tag] == 0) {
        if(!self.switchHypertrophy.isOn) {
            self.labelHypertrophy.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
        else {
            self.labelHypertrophy.textColor = [UIColor colorWithRed:0.10588235 green:0.61176471 blue:0.090196078 alpha:1.0];
        }
    }
    else if([sender tag] == 1) {
        if(!self.switchDefinition.isOn) {
            self.labelDefinition.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
        else {
            self.labelDefinition.textColor = [UIColor colorWithRed:0.10588235 green:0.61176471 blue:0.090196078 alpha:1.0];
        }
    }
    else if([sender tag] == 2) {
        if(!self.switchTonification.isOn) {
            self.labelTonification.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
        else {
            self.labelTonification.textColor = [UIColor colorWithRed:0.10588235 green:0.61176471 blue:0.090196078 alpha:1.0];
        }
    }
    else if([sender tag] == 3) {
        if(!self.switchFatLoss.isOn) {
            self.labelFatLoss.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
        else {
            self.labelFatLoss.textColor = [UIColor colorWithRed:0.10588235 green:0.61176471 blue:0.090196078 alpha:1.0];
        }
    }
    else if([sender tag] == 4) {
        if(!self.switchStrengh.isOn) {
            self.labelStrengh.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
        else {
            self.labelStrengh.textColor = [UIColor colorWithRed:0.10588235 green:0.61176471 blue:0.090196078 alpha:1.0];
        }
    }
}*/
@end
