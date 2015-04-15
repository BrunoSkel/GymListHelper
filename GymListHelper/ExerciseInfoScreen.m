//
//  ExerciseInfoScreen.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 4/13/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "ExerciseInfoScreen.h"

@interface ExerciseInfoScreen ()
@property (strong, nonatomic) IBOutlet UITextView *TextView;
@property NSString *retrievedSeries;
@property NSString *retrievedRep;
@property (strong, nonatomic) IBOutlet UILabel *exNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *seriesRepsLabel;
@property NSString *retrievedName;
@end

@implementation ExerciseInfoScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.TextView.layer.borderWidth = 0.5f;
    self.TextView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self retrieveInformation];
    self.exNameLabel.text=self.retrievedName;
    self.seriesRepsLabel.text=[NSString stringWithFormat:@"Series: %@ | Reps: %@",self.retrievedSeries,self.retrievedRep];
    if (self.infodata!=NULL)
    self.TextView.text=self.infodata;
    else{
        self.TextView.text=@"No Information Available";
    }
}

-(void)retrieveInformation{
    
    //String is recieved as NAME | seriesXrep. Separate those to edit the exercise properly
    
    //NSString *fullinfo=[self.tableData objectAtIndex:i];
    
    NSArray *CurrentExerciseData = [[NSArray alloc] init];
    CurrentExerciseData=[self.fullname componentsSeparatedByString:@"|"];
    
    //stringbyTrimming = Remove spaces from start and the end
    
    self.retrievedName=[[CurrentExerciseData objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];;
    
    NSArray *RepCountInformation = [[NSArray alloc] init];
    
    RepCountInformation=[[CurrentExerciseData objectAtIndex:1]componentsSeparatedByString:@"x"];
    
    self.retrievedSeries=[[RepCountInformation objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    self.retrievedRep=[[RepCountInformation objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}

@end