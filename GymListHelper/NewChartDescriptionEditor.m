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
@property NSString *editroutinestring;
@property NSString *addroutinestring;
@property NSString *newroutinestring;
@property NSString *language;

@property (weak, nonatomic) IBOutlet UISwitch *switchHypertrophy;
@property (weak, nonatomic) IBOutlet UILabel *labelHypertrophy;
@property (weak, nonatomic) IBOutlet UISwitch *switchDefinition;
@property (weak, nonatomic) IBOutlet UILabel *labelDefinition;
@property (weak, nonatomic) IBOutlet UISwitch *switchTonification;
@property (weak, nonatomic) IBOutlet UILabel *labelTonification;
@property (weak, nonatomic) IBOutlet UISwitch *switchFatLoss;
@property (weak, nonatomic) IBOutlet UILabel *labelFatLoss;
@property (weak, nonatomic) IBOutlet UISwitch *switchStrengh;
@property (weak, nonatomic) IBOutlet UILabel *labelStrengh;

- (IBAction)switchObjective:(id)sender;
@end

@implementation NewChartDescriptionEditor

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _editroutinestring=@"Edit Routine";
    _addroutinestring=@"Add New Routine";
    _newroutinestring=@"New Routine";
    
    _language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    
    if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
    
        _editroutinestring=@"Editar Treino";
        _addroutinestring=@"Novo Treino";
        _newroutinestring=@"Novo Treino";
        
    }
    
    // Do any additional setup after loading the view.
    self.ChartNameNew.delegate = self;
    
    self.switchHypertrophy.tag = 0;
    self.switchDefinition.tag = 1;
    self.switchTonification.tag = 2;
    self.switchFatLoss.tag = 3;
    self.switchStrengh.tag = 4;
    //_isEdit=NO;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"view will appear");
    if (self.isEdit==YES){
        self.ChartNameNew.text = self.sentNameArray[self.EditThisRoutine];
        [self.MainLabel setText:self.editroutinestring];
        self.DeleteButton.hidden = NO;
        
        // Check categories data and change switches
        self.ChartCategories = self.sentCategorieArray[self.EditThisRoutine];
        
        if([self.ChartCategories[0] isEqual: @"YES"]) {
            [self.switchHypertrophy setOn:YES];
            self.labelHypertrophy.textColor = [UIColor colorWithRed:0.10588235 green:0.61176471 blue:0.090196078 alpha:1.0];
        }
        else {
            [self.switchHypertrophy setOn:NO];
            self.labelHypertrophy.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
        
        if([self.ChartCategories[1] isEqual: @"YES"]) {
            [self.switchDefinition setOn:YES];
            self.labelDefinition.textColor = [UIColor colorWithRed:0.10588235 green:0.61176471 blue:0.090196078 alpha:1.0];
        } else {
            [self.switchDefinition setOn:NO];
            self.labelDefinition.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
        
        if([self.ChartCategories[2] isEqual: @"YES"]) {
            [self.switchTonification setOn:YES];
            self.labelTonification.textColor = [UIColor colorWithRed:0.10588235 green:0.61176471 blue:0.090196078 alpha:1.0];
        }
        else {
            [self.switchTonification setOn:NO];
            self.labelTonification.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
        
        if([self.ChartCategories[3] isEqual: @"YES"]) {
            [self.switchFatLoss setOn:YES];
            self.labelFatLoss.textColor = [UIColor colorWithRed:0.10588235 green:0.61176471 blue:0.090196078 alpha:1.0];
        }
        else {
            [self.switchFatLoss setOn:NO];
            self.labelFatLoss.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
        
        if([self.ChartCategories[4] isEqual: @"YES"]) {
            [self.switchStrengh setOn:YES];
            self.labelStrengh.textColor = [UIColor colorWithRed:0.10588235 green:0.61176471 blue:0.090196078 alpha:1.0];
        }
        else {
            [self.switchStrengh setOn:NO];
            self.labelStrengh.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
        NSLog(@"Current chart: %@", self.ChartCategories);
    }
    else{
        self.DeleteButton.hidden = YES;
        self.ChartNameNew.text = self.newroutinestring;
        [self.MainLabel setText:self.addroutinestring];
        
        self.ChartCategories = [NSMutableArray array];
        [self.ChartCategories addObject:@"YES"]; // Hypertrophy
        [self.switchHypertrophy setOn:YES];
        self.labelHypertrophy.textColor = [UIColor colorWithRed:0.10588235 green:0.61176471 blue:0.090196078 alpha:1.0];
        
        [self.ChartCategories addObject:@"NO"]; // Definition
        [self.switchDefinition setOn:NO];
        self.labelDefinition.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        
        [self.ChartCategories addObject:@"NO"]; // Tonification
        [self.switchTonification setOn:NO];
        self.labelTonification.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        
        [self.ChartCategories addObject:@"NO"]; // Fat Loss
        [self.switchFatLoss setOn:NO];
        self.labelFatLoss.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        
        [self.ChartCategories addObject:@"NO"]; // Strengh
        [self.switchStrengh setOn:NO];
        self.labelStrengh.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];

        NSLog(@"Current chart: %@", self.ChartCategories);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Checking if he pressed the delete button
    UIButton *button = (UIButton *)sender;
    if (button==self.DeleteButton){
        ChartsMenu *controller = (ChartsMenu *)segue.destinationViewController;
        
        //SAVE CHART
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        NSString *filePath;
        
        //Delete the Exercises from this routine
        
        [controller.allChartData removeObjectAtIndex:self.EditThisRoutine];
        filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
        [controller.allChartData writeToFile:filePath atomically:YES];
        
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
        
        //Now reload
        [controller.tableData removeAllObjects];
        controller.tableData=[NSMutableArray arrayWithArray:controller.allChartData];
        [controller.tableView reloadData];
        return;
    }
    //Check if hes editing or creating a new chart
    if (self.isEdit==YES){
        NSLog(@"Saving Edition");
        if (self.ChartNameNew.text.length > 0 && sender!=self.cancelBut) {
            ChartsMenu *controller = (ChartsMenu *)segue.destinationViewController;
            
            //SAVE CHART
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filePath;
            
            //Add new workout, and a subworkout A and B since segmented control doesnt allow only one segment
            
            
            //Adding new chart name
            NSLog(@"Old: %@",controller.RoutineNamesArray[self.EditThisRoutine]);
            [controller.RoutineNamesArray replaceObjectAtIndex:self.EditThisRoutine withObject:self.ChartNameNew.text];
                        NSLog(@"New: %@",[controller.RoutineNamesArray objectAtIndex:self.EditThisRoutine]);
            
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
    
    if (self.ChartNameNew.text.length > 0 && sender!=self.cancelBut) {
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
        
        //Adding new chart name
        [controller.RoutineNamesArray addObject: self.ChartNameNew.text];
        
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
    if(self.switchHypertrophy.isOn) [self.ChartCategories replaceObjectAtIndex:0 withObject:@"YES"];
    else [self.ChartCategories replaceObjectAtIndex:0 withObject:@"NO"];
    
    if(self.switchDefinition.isOn) [self.ChartCategories replaceObjectAtIndex:1 withObject:@"YES"];
    else [self.ChartCategories replaceObjectAtIndex:1 withObject:@"NO"];
    
    if(self.switchTonification.isOn) [self.ChartCategories replaceObjectAtIndex:2 withObject:@"YES"];
    else [self.ChartCategories replaceObjectAtIndex:2 withObject:@"NO"];
    
    if(self.switchFatLoss.isOn) [self.ChartCategories replaceObjectAtIndex:3 withObject:@"YES"];
    else [self.ChartCategories replaceObjectAtIndex:3 withObject:@"NO"];
    
    if(self.switchStrengh.isOn) [self.ChartCategories replaceObjectAtIndex:4 withObject:@"YES"];
    else [self.ChartCategories replaceObjectAtIndex:4 withObject:@"NO"];
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
- (IBAction)switchObjective:(id)sender {
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
}
@end
