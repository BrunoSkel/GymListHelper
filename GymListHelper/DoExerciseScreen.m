//
//  DoExerciseScreen.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/18/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "DoExerciseScreen.h"
#import "EndScreen.h"

@interface DoExerciseScreen ()
@property (strong, nonatomic) IBOutlet UILabel *ChartNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ExerciseName;
@property (strong, nonatomic) IBOutlet UILabel *RepCount;
@property int currentExerciseIndex;
@property int RemainingSeries;
@property int ExerciseAmount;
@property (strong, nonatomic) IBOutlet UILabel *DoLabel;
@property (strong, nonatomic) IBOutlet UILabel *RepsLabel;
@property (strong, nonatomic) IBOutlet UIButton *HowLabel;
@property (strong, nonatomic) IBOutlet UIButton *DoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *WaitLabel;
@property (strong, nonatomic) IBOutlet UIButton *SkipLabel;
@property int RemainingCooldownSeconds;
@property (strong,nonatomic) NSTimer *stopWatchTimer; //Store the timer
@property (strong, nonatomic) IBOutlet UILabel *cooldownLabel;
@property BOOL skipped;
@end

@implementation DoExerciseScreen
- (void)viewDidLoad {
    [super viewDidLoad];
    _skipped=NO;
    _currentExerciseIndex=0;
    _ChartNameLabel.text=_chartname;
    [self Initiate];
}

- (void)Initiate{
    //Hide the Cooldown Stuff
    [self HideCooldown];
    //Get the amount of exercises from the chosen chart, and show the first one
    _ExerciseAmount=(int)[_exercisedata count];
    NSLog(@"Exercise Amount on this Chart: %d",_ExerciseAmount);
    if (_ExerciseAmount==0){
        return;
    }
    else
    [self ShowExercise:_currentExerciseIndex];
}

-(void)HideCooldown{
    [self.stopWatchTimer invalidate];
    self.stopWatchTimer = nil;
    _cooldownLabel.hidden=YES;
    _WaitLabel.hidden=YES;
    _ExerciseName.hidden=NO;
    _RepCount.hidden=NO;
    _DoLabel.hidden=NO;
    _RepsLabel.hidden=NO;
    _HowLabel.hidden=NO;
    _DoneLabel.hidden=NO;
    _SkipLabel.hidden=NO;
}

-(void)ShowCooldown{
    _cooldownLabel.hidden=NO;
    _WaitLabel.hidden=NO;
    _ExerciseName.hidden=YES;
    _RepCount.hidden=YES;
    _DoLabel.hidden=YES;
    _RepsLabel.hidden=YES;
    _HowLabel.hidden=YES;
    _DoneLabel.hidden=YES;
    _SkipLabel.hidden=YES;
}

- (void)ShowExercise:(int)index{
    //From the Array containing every exercise name, separate the name from the repcount, according to the current exercise index.

    NSArray *CurrentExerciseData = [[NSArray alloc] init];
    CurrentExerciseData=[[_exercisedata objectAtIndex:index] componentsSeparatedByString:@"|"];
    
    //Now, index 0 from the new array is the name we want
    
    _ExerciseName.text=[NSString stringWithFormat:@"%@",[CurrentExerciseData objectAtIndex:0]];
    
    //However, index 1 is the entire repcount. We need to separate those too, as the series amount are for internal use.
    
        NSArray *RepCountInformation = [[NSArray alloc] init];
    
        RepCountInformation=[[CurrentExerciseData objectAtIndex:1]componentsSeparatedByString:@"x"];
    
    //Now, 0 is the series amount, while 1 is the repcount.
    
    _RepCount.text=[NSString stringWithFormat:@"%@",[RepCountInformation objectAtIndex:1]];
    
    //Converting the series' NSString to int
    
    NSString *SeriesString=[RepCountInformation objectAtIndex:0];
    
    _RemainingSeries=[SeriesString intValue];
        NSLog(@"Series Amount: %d",_RemainingSeries);
}

- (IBAction)DonePressed:(id)sender {
    //When done is pressed, reduce the series number and show the cooldown.
    //Check if he started without anything
    if (_ExerciseAmount==0){
        [self performSegueWithIdentifier:@"toEnd" sender:nil];
        return;
    }
    _RemainingSeries--;
    [self Cooldown];
    //[self Proceed];
}
- (IBAction)SkipPressed:(id)sender {
    //We check if he skipped, to change the text at the end.
    _skipped=YES;
    //When Skip is pressed, go to the next exercise regardless of the series/cooldown.
    [self HideCooldown];
    [self Proceed];
}

-(void) Cooldown{
    [self ShowCooldown];
    _RemainingCooldownSeconds=_cooldownAmount;
    //StopwatchTimer takes 1 second to initialize, so we do it manually one time
    [self updateTimer];
            self.stopWatchTimer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

-(void)updateTimer{
    if (_RemainingCooldownSeconds==60){
            self.cooldownLabel.text=[NSString stringWithFormat:@"01:00"];
    }
    else{
    self.cooldownLabel.text=[NSString stringWithFormat:@"00:%02d",_RemainingCooldownSeconds];
    }
    if (_RemainingCooldownSeconds==0){
        [self HideCooldown];
        //Checks if the series are over
        if (_RemainingSeries<=0)
            [self Proceed];
    }
    else
    _RemainingCooldownSeconds--;
}

-(void)Proceed{
    //If there's still more exercises to go, show the next one. Else, finish the app
    _currentExerciseIndex++;
    if (_currentExerciseIndex<_ExerciseAmount){
        [self ShowExercise:_currentExerciseIndex];
    }
    else
    {
        [self performSegueWithIdentifier:@"toEnd" sender:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toEnd"]){
        EndScreen *controller = (EndScreen *)segue.destinationViewController;
        //Shows if there's no exercise
        if (_ExerciseAmount==0){
            controller.endtext=[NSString stringWithFormat:@"And by that, I mean... nothing?"];
            return;
        }
        if (_skipped==YES)
        controller.endtext=[NSString stringWithFormat:@"But next time, try not to skip."];
        else
         controller.endtext=[NSString stringWithFormat:@"Now, don't give up!"];
    }
}

@end
