//
//  SharePreview.m
//  GymListHelper
//
//  Created by Rodrigo Dias Takase on 09/04/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import "SharePreview.h"
#import "NewChartDescriptionEditor.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"

@interface SharePreview ()
@property (weak, nonatomic) IBOutlet UILabel *lbChartName;
@property (weak, nonatomic) IBOutlet UILabel *lbObjective;
@property (weak, nonatomic) IBOutlet UILabel *lbUsername;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserpic;

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UITextView *txtExercises;

@property (strong, nonatomic) NSArray* arrLanguages;
@property (nonatomic) NSInteger ChosenLanguage;

@end

@implementation SharePreview

- (void)textViewDidBeginEditing:(UITextView *)txtDescription {
    NSLog(@"textViewDidBeginEditing:");

    if([self.txtDescription.text isEqualToString:@"Add your description here"]){
        self.txtDescription.text = @"";
    }else if([self.txtDescription.text isEqualToString:@""]){
        self.txtDescription.text = @"Add your description here";
    }
    
    [txtDescription becomeFirstResponder];
}

- (void)keyboardWasShown:(NSNotification*)notification {

}

- (void)keyboardWillBeHidden:(NSNotification*)notification {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapRecognized:)];
//    singleTap.numberOfTapsRequired = 1;
//    [self.descriptionTextView addGestureRecognizer:singleTap];
//    [singleTap re];
    
    self.ChosenLanguage = 0;
    
    self.arrLanguages = @[@"English",@"Portuguese",@"Spanish",@"Chinese",@"Danish",@"Dutch",@"Finnish",@"French",@"German",@"Greek",@"Indonesian",@"Italian",@"Japanese",@"Korean",@"Malay",@"Norwegian",@"Russian",@"Swedish",@"Thai",@"Turkish",@"Vietnamese",@"Other"];
    
//    NSLog(@"SharePreview viewDidLoad");
    self.lbChartName.text = self.RoutineNamesArray[self.ShareThisRoutine];
    
    
    int firstId = -1;
    NSMutableString* objectives = [NSMutableString new];
    for(int i=0;i<[self.ChartCategoriesArray[self.ShareThisRoutine] count];i++){
        if([self.ChartCategoriesArray[self.ShareThisRoutine][i] isEqualToString:@"YES"]){
            if((i > firstId)&&(firstId != -1)){
                [objectives appendString:@", "];
            }
            if(firstId == -1){
                firstId = i;
            }
            switch(i){
                case 0:
                    [objectives appendString:@"Hypertrophy"];
                    break;
                case 1:
                    [objectives appendString:@"Definition"];
                    break;
                case 2:
                    [objectives appendString:@"Tonification"];
                    break;
                case 3:
                    [objectives appendString:@"Fat Loss"];
                    break;
                case 4:
                    [objectives appendString:@"Strength"];
                    break;
            }
            
        }
    }
    self.lbObjective.text = [NSString stringWithFormat:@"Objective: %@",objectives];
    
    
    NSMutableString *strExercises = [NSMutableString new];


    int subroutinesWithExercises = 0;
    int i=0;
    for(NSString *str in self.ChartNamesArray[self.ShareThisRoutine]){
        [strExercises appendString:@"• "];
        [strExercises appendString:str];
        [strExercises appendString:@"\n"];

        //for(NSArray* arr in self.allChartData[self.ShareThisRoutine]){
            //NSLog(@"%@",arr);
            
            
            if([self.allChartData[self.ShareThisRoutine][i] count] != 0){
                NSLog(@"%lu",[self.allChartData[self.ShareThisRoutine][i] count]);
                NSLog(@"%@",self.allChartData[self.ShareThisRoutine][i]);
                
                subroutinesWithExercises++;
                for(NSString* str2 in self.allChartData[self.ShareThisRoutine][i]){
                    [strExercises appendString:@"       "];
                    [strExercises appendString:str2];
                    [strExercises appendString:@"\n"];
                }
            }
            

        //}
        
        i++;
    }
    
    if(subroutinesWithExercises == 0){
        strExercises = [NSMutableString stringWithString:@"No exercises added"];
    }
    self.txtExercises.text = strExercises;
    
    NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100",[[NSUserDefaults standardUserDefaults] valueForKey:@"loggedUserFacebookId"]]];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    
    self.imgUserpic.image = image;
    
    self.lbUsername.text = [NSString stringWithFormat:@"by %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"loggedUserName"]];
    ;
}

-(void)viewDidAppear:(BOOL)animated{
    
    
//    NSLog(@"SharePreview viewDidAppear");
    
    
}

- (IBAction)ShareBtnAction:(id)sender{
    NSError *error = NULL;

    //Serialize ChartNamesArray
    NSData *jsonData = [[CJSONSerializer serializer] serializeObject:self.ChartNamesArray[self.ShareThisRoutine] error:&error];
    NSString* jsonSrtChartNames = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    //Serialize WaitTimesArray
    jsonData = [[CJSONSerializer serializer] serializeObject:self.WaitTimesArray[self.ShareThisRoutine] error:&error];
    NSString* jsonSrtWaitTimes = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    //Serialize allChartData
    jsonData = [[CJSONSerializer serializer] serializeObject:self.allChartData[self.ShareThisRoutine] error:&error];
    NSString* jsonSrtAllChartData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    
    //Serialize allInfoData
    jsonData = [[CJSONSerializer serializer] serializeObject:self.allInfoData[self.ShareThisRoutine] error:&error];
    NSString* jsonSrtAllInfoChartData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    
    
        //Serialize categories
    jsonData = [[CJSONSerializer serializer] serializeObject:self.ChartCategoriesArray[self.ShareThisRoutine] error:&error];
    NSString* jsonSrtCategoriesData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    //Create "form" data
    NSString *sendData = @"userid=";
    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"loggedUserId"]]];

    sendData = [sendData stringByAppendingString:@"&name="];
    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", self.RoutineNamesArray[self.ShareThisRoutine]]];

    sendData = [sendData stringByAppendingString:@"&category="];
    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", jsonSrtCategoriesData]];
    
    sendData = [sendData stringByAppendingString:@"&category1="];
    if([self.ChartCategoriesArray[self.ShareThisRoutine][0] isEqualToString:@"YES"]){
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"1"]];
    }else{
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"0"]];
    }
    
    sendData = [sendData stringByAppendingString:@"&category2="];
    if([self.ChartCategoriesArray[self.ShareThisRoutine][1] isEqualToString:@"YES"]){
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"1"]];
    }else{
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"0"]];
    }

    sendData = [sendData stringByAppendingString:@"&category3="];
    if([self.ChartCategoriesArray[self.ShareThisRoutine][2] isEqualToString:@"YES"]){
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"1"]];
    }else{
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"0"]];
    }
    sendData = [sendData stringByAppendingString:@"&category4="];
    if([self.ChartCategoriesArray[self.ShareThisRoutine][3] isEqualToString:@"YES"]){
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"1"]];
    }else{
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"0"]];
    }
    sendData = [sendData stringByAppendingString:@"&category5="];
    if([self.ChartCategoriesArray[self.ShareThisRoutine][4] isEqualToString:@"YES"]){
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"1"]];
    }else{
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"0"]];
    }
    sendData = [sendData stringByAppendingString:@"&estimatedTime="];
    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];

    sendData = [sendData stringByAppendingString:@"&waitTime="];
    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", jsonSrtWaitTimes]];

    sendData = [sendData stringByAppendingString:@"&language="];
    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%ld",self.ChosenLanguage]];

    sendData = [sendData stringByAppendingString:@"&comment="];
    sendData = [sendData stringByAppendingString:self.txtDescription.text];

    sendData = [sendData stringByAppendingString:@"&chartNames="];
    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", jsonSrtChartNames]];

    sendData = [sendData stringByAppendingString:@"&exercises="];
    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", jsonSrtAllChartData]];
    
    sendData = [sendData stringByAppendingString:@"&exercisesInfo="];
    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", jsonSrtAllInfoChartData]];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.gamescamp.com.br/gymhelper/webservices/insertChart.php"]];

    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];

    //Here you send your data
    [request setHTTPBody:[sendData dataUsingEncoding:NSUTF8StringEncoding]];

    [request setHTTPMethod:@"POST"];
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];


    if (error)
    {
        NSLog(@"Error = %@", error);
    }
    else
    {
        //The response is in data
        NSLog(@"%@", results);

        if([results isEqualToString:@"ERROR2"]){
            NSLog(@"Error2");
        }else{
            NSLog(@"Compartilhado");

            self.ByUserArray[self.ShareThisRoutine] = [NSString stringWithFormat:@"0§myself§%@", results];

            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"byUserFile"];
            [self.ByUserArray writeToFile:filePath atomically:YES];
            
        }
    }
    
    
    [self performSegueWithIdentifier:@"GoToCharts" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Edit"]){
        NSLog(@"EditEdit");
        NewChartDescriptionEditor *controller = (NewChartDescriptionEditor *)segue.destinationViewController;
        controller.EditThisRoutine=self.ShareThisRoutine;
        controller.sentNameArray=[NSMutableArray arrayWithArray:self.RoutineNamesArray];
        [controller editMode];
    }
}

//PickerStuff

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.arrLanguages count];
}

//The data to return for the row and component (column) that's being passed in
//- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//
//    return self.arrLanguages[row];
//}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"System" size:16]];
        //[tView setTextAlignment:UITextAlignmentLeft];
        tView.numberOfLines=3;
    }
    // Fill the label text here
    tView.text=self.arrLanguages[row];
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.ChosenLanguage = row;
}

@end
