//
//  DoExerciseScreen.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/18/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "DoExerciseScreenWATCH.h"
#import <AudioToolbox/AudioToolbox.h>
//#import "EndScreen.h"
@import WatchKit;
@import UIKit;

@interface DoExerciseScreenWATCH ()
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *ExerciseName;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *RepCount;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property int currentExerciseIndex;
@property int RemainingSeries;
@property int ExerciseAmount;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *DoLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *RepsLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *DoneLabel;
@property int RemainingCooldownSeconds;
@property (strong,nonatomic) NSTimer *stopWatchTimer; //Store the timer
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *cooldownLabel;
@property BOOL skipped;
@property NSString *EndingString;
@property BOOL isOnCooldown;
//Timer to change the text on the done button
@property (strong,nonatomic) NSTimer *syncTimer; //Store the timer
@property int DoneLabelInt;
@end

@implementation DoExerciseScreenWATCH
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    _skipped=NO;
    _isOnCooldown=NO;
    _currentExerciseIndex=0;
    _DoneLabelInt=0;
    //_ChartNameLabel.text=_chartname;
    
    
    //SORTING THE WAIT TIME
    _cooldownAmount=[[context objectAtIndex:[context count]-1] intValue];
    //and remove it before initiating everything else
    [context removeObjectAtIndex:[context count]-1];
    NSLog(@"Wait Time: %d",_cooldownAmount);
    //Fill the internal exercise array
    _exercisedata=[NSMutableArray arrayWithArray:context];
    [self Initiate];
}

- (void)Initiate{
    //Inititate timer to change the text on the done button
        self.syncTimer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimerLabel) userInfo:nil repeats:YES];
    //Hide the Cooldown Stuff
    [self HideCooldown];
    //Get the amount of exercises from the chosen chart, and show the first one
    _ExerciseAmount=(int)[_exercisedata count];
    NSLog(@"Exercise Amount on this Chart: %d",_ExerciseAmount);
    if (self.ExerciseAmount!=0)
        [self ShowExercise:_currentExerciseIndex];
    else{
        self.EndingString=@"By that, I mean nothing.";
        [self pushControllerWithName:@"ToEnd" context:_EndingString];
    }
}

-(void) updateTimerLabel{
    //Changes the Text for the Done Label.
    if (self.isOnCooldown==YES){
        [self.DoneLabel setTitle:@"Press to Skip"];
        return;
    }
    self.DoneLabelInt++;
    if (self.DoneLabelInt>=1){
    [self.DoneLabel setTitle:@"Press to Skip"];
        self.DoneLabelInt=-1;
    }
    else{
            [self.DoneLabel setTitle:@"Touch to Continue"];
    }
}

-(void)HideCooldown{
    self.isOnCooldown=NO;
    [self.stopWatchTimer invalidate];
    self.stopWatchTimer = nil;
    self.cooldownLabel.hidden=YES;
    self.ExerciseName.hidden=NO;
    self.RepCount.hidden=NO;
    [self.DoLabel setText:@"Do:"];
    self.RepsLabel.hidden=NO;
   // self.DoneLabel.hidden=NO;
}

-(void)ShowCooldown{
    self.isOnCooldown=YES;
    self.cooldownLabel.hidden=NO;
    self.ExerciseName.hidden=YES;
    self.RepCount.hidden=YES;
    [self.DoLabel setText:@"Wait..."];
    self.RepsLabel.hidden=YES;
   // self.DoneLabel.hidden=YES;
}

- (void)ShowExercise:(int)index{
    //From the Array containing every exercise name, separate the name from the repcount, according to the current exercise index.
    
    NSArray *CurrentExerciseData = [[NSArray alloc] init];
    CurrentExerciseData=[[_exercisedata objectAtIndex:index] componentsSeparatedByString:@"|"];
    
    //Now, index 0 from the new array is the name we want
    
    self.ExerciseName.text=[NSString stringWithFormat:@"%@",[CurrentExerciseData objectAtIndex:0]];
    
    //However, index 1 is the entire repcount. We need to separate those too, as the series amount are for internal use.
    
    NSArray *RepCountInformation = [[NSArray alloc] init];
    
    RepCountInformation=[[CurrentExerciseData objectAtIndex:1]componentsSeparatedByString:@"x"];
    
    //Now, 0 is the series amount, while 1 is the repcount.
    
    self.RepCount.text=[NSString stringWithFormat:@"%@",[RepCountInformation objectAtIndex:1]];
    
    //Converting the series' NSString to int
    
    NSString *SeriesString=[RepCountInformation objectAtIndex:0];
    
    self.RemainingSeries=[SeriesString intValue];
    NSLog(@"Series Amount: %d",_RemainingSeries);
}

- (IBAction)DonePressed:(id)sender {
    //Do nothing if its on cooldown
        if (self.isOnCooldown==YES){
            return;
        }
    //When done is pressed, reduce the series number and show the cooldown.
    if (self.ExerciseAmount==0){
        [self pushControllerWithName:@"ToEnd" context:nil];
        return;
    }
    self.RemainingSeries--;
    [self Cooldown];
    //[self Proceed];
}
- (IBAction)SkipPressed:(id)sender {
    //We check if he skipped, to change the text at the end.
    _skipped=YES;
    //When Skip is pressed, go to the next exercise regardless of the series/cooldown.
    
    if (self.isOnCooldown==YES){
        [self HideCooldown];
        return;
    }
    
    [self HideCooldown];
    [self Proceed];
}

-(void) Cooldown{
    [self ShowCooldown];
    self.RemainingCooldownSeconds=self.cooldownAmount;
    //StopwatchTimer takes 1 second to initialize, so we do it manually one time
    [self updateTimer];
    self.stopWatchTimer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

-(void)updateTimer{
    if (self.RemainingCooldownSeconds==60){
        self.cooldownLabel.text=[NSString stringWithFormat:@"01:00"];
    }
    else{
        self.cooldownLabel.text=[NSString stringWithFormat:@"00:%02d",self.RemainingCooldownSeconds];
    }
    if (self.RemainingCooldownSeconds==0){
        [self HideCooldown];
        //Checks if the series are over
        if (self.RemainingSeries<=0){
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            [self Proceed];
        }
    }
    else
        self.RemainingCooldownSeconds--;
}

-(void)Proceed{
    //If there's still more exercises to go, show the next one. Else, finish the app
    self.currentExerciseIndex++;
    if (self.currentExerciseIndex<self.ExerciseAmount){
        [self ShowExercise:self.currentExerciseIndex];
    }
    else
    {
        if (self.skipped==YES)
           self.EndingString=@"Next time, try not to skip.";
        else{
            self.EndingString=@"Nice job!";
        }
        [self pushControllerWithName:@"ToEnd" context:self.EndingString];
    }
}

/*-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toEnd"]){
        EndScreen *controller = (EndScreen *)segue.destinationViewController;
        if (_skipped==YES)
            controller.endtext=[NSString stringWithFormat:@"But next time, try not to skip."];
        else
            controller.endtext=[NSString stringWithFormat:@"Now, don't give up!"];
    }
}*/

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end
