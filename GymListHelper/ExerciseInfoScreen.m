//
//  ExerciseInfoScreen.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 4/13/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "ExerciseInfoScreen.h"
#import "ZoomImage.h"

@interface ExerciseInfoScreen ()
@property (strong, nonatomic) IBOutlet UITextView *TextView;
@property NSString *retrievedSeries;
@property NSString *retrievedRep;
@property (strong, nonatomic) IBOutlet UILabel *exNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *seriesRepsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *PIC1;
@property (strong, nonatomic) IBOutlet UIImageView *PIC2;
@property (strong, nonatomic) IBOutlet UIButton *PIC1BUT;
@property (strong, nonatomic) IBOutlet UIButton *PIC2BUT;
@property UIImage *defaultImage;
@property NSString *retrievedName;
@end

@implementation ExerciseInfoScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultImage=self.PIC1.image;
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
    
    if (![self.picdata[0] isEqual:@"NoPic"]){
        
        self.PIC1.image=[UIImage imageWithData:self.picdata[0]];
        
    }
    
    else{
        NSLog(@"Pic 1 is not filled (NoPic)");
    }
    
    if (![self.picdata[1] isEqual:@"NoPic"]){
        
        self.PIC2.image=[UIImage imageWithData:self.picdata[1]];
        
    }
    
    self.PIC1.contentMode=UIViewContentModeScaleAspectFit;
    self.PIC2.contentMode=UIViewContentModeScaleAspectFit;
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toImageView"]){
        
        UINavigationController *navController = [segue destinationViewController];
        ZoomImage *controller = (ZoomImage *)([navController viewControllers][0]);
        if (sender==self.PIC1BUT)
            controller.sentimage=self.PIC1.image;
        if (sender==self.PIC2BUT)
            controller.sentimage=self.PIC2.image;
    }
}
@end