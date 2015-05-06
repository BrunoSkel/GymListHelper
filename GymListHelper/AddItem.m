//
//  AddItem.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/19/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "AddItem.h"

@interface AddItem () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *seriesField;
@property (strong, nonatomic) IBOutlet UITextField *repField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBut;
@property (strong, nonatomic) IBOutlet UIButton *DeleteButton;
@property NSString *retrievedSeries;
@property NSString *retrievedRep;
@property NSString *retrievedName;
@property (strong, nonatomic) IBOutlet UITextView *InfoBox;
@property BOOL isEdit;
@property NSMutableArray *allInfoData;
@property NSMutableArray *allPicData;
@property (strong, nonatomic) IBOutlet UIImageView *PIC1;
@property (strong, nonatomic) IBOutlet UIImageView *PIC2;
@property (strong, nonatomic) IBOutlet UIButton *PIC1Button;
@property (strong, nonatomic) IBOutlet UIButton *PIC2Button;

@property NSString *language;
@property NSString *addstring;
@property NSString *editstring;
@property UIImageView* touchedImage;
@property UIImage *defaultPic;
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
    [self PrepareForShow];
}

- (void)PrepareForShow {
    
    //Appeared: Load Info box, apply translation and Scroll size and check information sent from the previous UIViewController
    self.defaultPic=self.PIC1.image;
    [self loadInfoBoxInfo];
    
    if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
        
        _addstring=@"Novo Exercício";
        _editstring=@"Editar Exercício";
        [self.InfoBox setText:@"Coloque algumas informações aqui!"];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, 930);
    
    if (_isEdit==YES){
        
        [self retrieveInformation];
        
        _nameField.text=_retrievedName;
        _seriesField.text=_retrievedSeries;
        _repField.text=_retrievedRep;
        [self.navigationItem setTitle:self.editstring];
        _DeleteButton.hidden=NO;

        //Fill Box
        
        [self.InfoBox setText:self.allInfoData[self.ChosenWorkout][self.ChosenSubWorkout][self.EditThisExercise]];
        
        //Fill Pics
        if (![self.allPicData[self.ChosenWorkout][self.ChosenSubWorkout][self.EditThisExercise][0] isEqual:@"NoPic"]){
            
            self.PIC1.image=[UIImage imageWithData:self.allPicData[self.ChosenWorkout][self.ChosenSubWorkout][self.EditThisExercise][0]];
            
        }
        
        else{
            NSLog(@"Pic 1 is not filled (NoPic)");
        }
        
        if (![self.allPicData[self.ChosenWorkout][self.ChosenSubWorkout][self.EditThisExercise][1] isEqual:@"NoPic"]){
        
            self.PIC2.image=[UIImage imageWithData:self.allPicData[self.ChosenWorkout][self.ChosenSubWorkout][self.EditThisExercise][1]];
    
        }
        
        else{
            NSLog(@"Pic 2 is not filled (NoPic)");
        }
    
    }
    
    else{ //Not editing, creating new exercise
        _DeleteButton.hidden=YES;
        _nameField.text=@"";
        [self.navigationItem setTitle:self.addstring];
    }
    
        self.PIC1.contentMode=UIViewContentModeScaleAspectFit;
        self.PIC2.contentMode=UIViewContentModeScaleAspectFit;
    
}


- (IBAction)imageTouched:(UIButton *)sender{
    
    if (sender==self.PIC1Button)
        self.touchedImage=self.PIC1;
    if (sender==self.PIC2Button)
        self.touchedImage=self.PIC2;
    
    UIActionSheet* attachmentMenuSheet;
    attachmentMenuSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Take Photo", @"Photo Library", nil];
    
    // Show the sheet
    [attachmentMenuSheet showInView:self.view];
}

- (void)takePhoto {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
   // self.touchedImage=self.PIC1;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)choosePhoto {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   // self.touchedImage=self.PIC2;
    [self presentViewController:picker animated:YES completion:NULL];
    
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
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"picDataFile"];
    
    self.allPicData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
}

-(void)saveInfoBox{
    //SAVE CHARTS
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"infoDataFile"];
    
    [self.allInfoData writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"picDataFile"];
    
    [self.allPicData writeToFile:filePath atomically:YES];
    
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
    
    if (sender==self.cancelBut){
        NSLog(@"Canceled");
    return;
    }
    
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
        
        [self.allPicData[self.ChosenWorkout][self.ChosenSubWorkout] removeObjectAtIndex:self.EditThisExercise];
        
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
            
            if (self.PIC1.image!=self.defaultPic){
                NSLog(@"Pic1 was edited: Swapping stuff");
                NSData* imageData = UIImageJPEGRepresentation(self.PIC1.image, 1.0);
                
                [self.allPicData[controller.ChosenWorkout][controller.saveToChart][self.EditThisExercise] replaceObjectAtIndex:0 withObject:imageData];
                
            }
            
            if (self.PIC2.image!=self.defaultPic){
                NSLog(@"Pic2 was edited: Swapping stuff");
                NSData* imageData = UIImageJPEGRepresentation(self.PIC2.image, 1.0);
                
                [self.allPicData[controller.ChosenWorkout][controller.saveToChart][self.EditThisExercise] replaceObjectAtIndex:1 withObject:imageData];
                
            }
            
                [self saveInfoBox];
        }
        else{
            [[[controller.allChartData objectAtIndex:controller.ChosenWorkout] objectAtIndex:controller.saveToChart] addObject:_newitem];
            
            [[[self.allInfoData objectAtIndex:controller.ChosenWorkout] objectAtIndex:controller.saveToChart] addObject:self.InfoBox.text];
            
            [self.allPicData[controller.ChosenWorkout][controller.saveToChart] addObject: [NSMutableArray array]];
            
            NSInteger newpos=[self.allPicData[controller.ChosenWorkout][controller.saveToChart] count]-1;
            
            //On new exercises, check if a picture was added, otherwise, say it didnt changed
            
            if (self.PIC1.image!=self.defaultPic){
                
                NSData* imageData = UIImageJPEGRepresentation(self.PIC1.image, 1.0);
                
                [self.allPicData[controller.ChosenWorkout][controller.saveToChart][newpos] addObject:imageData];
                
            }
            
            else{
                [self.allPicData[controller.ChosenWorkout][controller.saveToChart][newpos] addObject:@"NoPic"];
            }
            
            if (self.PIC2.image!=self.defaultPic){
                
                NSData* imageData = UIImageJPEGRepresentation(self.PIC2.image, 1.0);
                
                [self.allPicData[controller.ChosenWorkout][controller.saveToChart][newpos] addObject:imageData];
                
            }
            
            else{
                [self.allPicData[controller.ChosenWorkout][controller.saveToChart][newpos] addObject:@"NoPic"];
            }
            
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

-(void)CheckifChangedPicture{
    
    //On edit mode, check if he added a new pic on place of the default one
    
    if (self.PIC1.image!=self.defaultPic){
    
    NSData* imageData = UIImageJPEGRepresentation(self.PIC1.image, 1.0);
    
    [self.allPicData[self.ChosenWorkout][self.ChosenSubWorkout][self.EditThisExercise] replaceObjectAtIndex:0 withObject:imageData];
        
    }
    
    if (self.PIC2.image!=self.defaultPic){
    
    NSData* imageData = UIImageJPEGRepresentation(self.PIC2.image, 1.0);
    
    [self.allPicData[self.ChosenWorkout][self.ChosenSubWorkout][self.EditThisExercise] replaceObjectAtIndex:1 withObject:imageData];
        
    }
}


//ImagePicker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.touchedImage.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
        switch (buttonIndex) {
                
            case 0:
                [self takePhoto];
                break;
                
            case 1:
                [self choosePhoto];
                break;
                
            default:
                break;
        }
}

@end