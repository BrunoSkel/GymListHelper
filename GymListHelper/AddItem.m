//
//  AddItem.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/19/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "AddItem.h"

@interface AddItem ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *seriesField;
@property (strong, nonatomic) IBOutlet UITextField *repField;
@property (strong, nonatomic) IBOutlet UILabel *saveButton;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UILabel *MainLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelBut;
@property (strong, nonatomic) IBOutlet UIButton *DeleteButton;
@property NSString *retrievedSeries;
@property NSString *retrievedRep;
@property NSString *retrievedName;
@property (strong, nonatomic) IBOutlet UITextView *InfoBox;
@property BOOL isEdit;
@property NSMutableArray *allInfoData;

@property NSString *language;
@property NSString *addstring;
@property NSString *editstring;
@end

@implementation AddItem

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    //Initialize language strings
    self.language = [[NSLocale preferredLanguages] objectAtIndex:0];
    self.addstring=@"New Exercise";
    self.editstring=@"Edit Exercise";
    
    
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //Loaded: Apply outlet settings
    
    self.seriesField.delegate=self;
    self.repField.delegate=self;
    self.nameField.delegate=self;
    self.InfoBox.layer.borderWidth = 0.5f;
    self.InfoBox.layer.borderColor = [[UIColor blackColor] CGColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Appeared: Load Info box, apply translation and Scroll size and check information sent from the previous UIViewController
    
    [self loadInfoBoxInfo];
    
    if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
        
        _addstring=@"Novo Exercício";
        _editstring=@"Editar Exercício";
        [self.InfoBox setText:@"Coloque algumas informações aqui!"];
    }
    
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    
    if (_isEdit==YES){
        
        [self retrieveInformation];
        
        _nameField.text=_retrievedName;
        _seriesField.text=_retrievedSeries;
        _repField.text=_retrievedRep;
        [_MainLabel setText:self.editstring];
        _DeleteButton.hidden=NO;

        //Fill Box
        
        [self.InfoBox setText:self.allInfoData[self.ChosenWorkout][self.ChosenSubWorkout][self.EditThisExercise]];
        NSLog(@"Desc= %@",self.allInfoData[self.ChosenWorkout][self.ChosenSubWorkout][self.EditThisExercise]);
    }
    
    else{ //Not editing, creating new exercise
        _DeleteButton.hidden=YES;
        _nameField.text=@"";
        [_MainLabel setText:self.addstring];
    }
    
}

-(void)editMode{
    NSLog(@"cheguei");
    //
    self.isEdit=YES;
}

-(void)loadInfoBoxInfo{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"infoDataFile"];
    
    self.allInfoData = [NSMutableArray arrayWithContentsOfFile:filePath];
}

-(void)saveInfoBox{
    //SAVE CHARTS
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"infoDataFile"];
    
    [self.allInfoData writeToFile:filePath atomically:YES];
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


//Getting out of the viewcontroller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //If he deleted it
    if (sender==self.DeleteButton){
        //SAVE CHART
                ChartEditor *controller = (ChartEditor *)segue.destinationViewController;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath;
        
        [[[controller.allChartData objectAtIndex:controller.ChosenWorkout] objectAtIndex:controller.saveToChart] removeObjectAtIndex:_EditThisExercise];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
        [controller.allChartData writeToFile:filePath atomically:YES];
        
        [[[self.allInfoData objectAtIndex:controller.ChosenWorkout] objectAtIndex:controller.saveToChart] removeObjectAtIndex:_EditThisExercise];
        [self saveInfoBox];
        
        //SAVE CHART END
        
        //Update Data
        [controller.tableData removeAllObjects];
        controller.tableData=[NSMutableArray arrayWithArray:[[controller.allChartData objectAtIndex:controller.ChosenWorkout] objectAtIndex:controller.saveToChart]];
        [controller.tableView reloadData];
        
        return;
    }
    
    //Creating new exercise
    if (self.nameField.text.length > 0 && sender!=self.cancelBut) {
        _newitem=[NSString stringWithFormat:@"%@ | %@x%@",self.nameField.text,self.seriesField.text,self.repField.text];
        NSLog(@"%@",_newitem);
        ChartEditor *controller = (ChartEditor *)segue.destinationViewController;
        
        //SAVE CHART
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath;
        
        if (_isEdit==YES){
                [[[controller.allChartData objectAtIndex:controller.ChosenWorkout] objectAtIndex:controller.saveToChart] replaceObjectAtIndex:_EditThisExercise withObject:_newitem];
                [[[self.allInfoData objectAtIndex:controller.ChosenWorkout] objectAtIndex:controller.saveToChart] replaceObjectAtIndex:_EditThisExercise withObject:self.InfoBox.text];
                [self saveInfoBox];
        }
        else{
    [[[controller.allChartData objectAtIndex:controller.ChosenWorkout] objectAtIndex:controller.saveToChart] addObject:_newitem];
            
            [[[self.allInfoData objectAtIndex:controller.ChosenWorkout] objectAtIndex:controller.saveToChart] addObject:self.InfoBox.text];
            [self saveInfoBox];
        }
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
        [controller.allChartData writeToFile:filePath atomically:YES];
        
        
        //SAVE CHART END
        
        //Update Data
        [controller.tableData removeAllObjects];
         controller.tableData=[NSMutableArray arrayWithArray:[[controller.allChartData objectAtIndex:controller.ChosenWorkout] objectAtIndex:controller.saveToChart]];
        [controller.tableView reloadData];

    }
}

/*-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {

    if (self.nameField.text.length > 0) {
        _newitem=[NSString stringWithFormat:@"%@ | %@x%@",self.nameField.text,self.seriesField.text,self.repField.text];
        ChartEditor *controller = (ChartEditor *)segue.destinationViewController;
        [controller.chartA addObject:_newitem];
        
        //SAVE CHART
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartA"];
        
        [controller.chartA writeToFile:filePath atomically:YES];
        //SAVE CHART END
        
        
        [controller.tableView reloadData];
        
    }
    
    
}*/

-(void)retrieveInformation{
    
    //String is recieved as NAME | seriesXrep. Separate those to edit the exercise properly
    
    NSString *fullinfo=[[[_sentArray objectAtIndex:_ChosenWorkout] objectAtIndex:_ChosenSubWorkout] objectAtIndex:_EditThisExercise];
    
    NSArray *CurrentExerciseData = [[NSArray alloc] init];
    CurrentExerciseData=[fullinfo componentsSeparatedByString:@"|"];
    
    //stringbyTrimming = Remove spaces from start and the end
    
    _retrievedName=[[CurrentExerciseData objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];;
    
    NSArray *RepCountInformation = [[NSArray alloc] init];
    
    RepCountInformation=[[CurrentExerciseData objectAtIndex:1]componentsSeparatedByString:@"x"];
    
    _retrievedSeries=[[RepCountInformation objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    _retrievedRep=[[RepCountInformation objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}

@end