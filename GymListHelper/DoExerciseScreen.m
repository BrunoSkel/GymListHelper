//
//  DoExerciseScreen.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/18/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "DoExerciseScreen.h"
#import "EndScreen.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CircularTimerView.h"
#import "ExerciseInfoScreen.h"

@interface DoExerciseScreen ()
@property (strong, nonatomic) IBOutlet UIView *NoCooldownView;
@property (strong, nonatomic) IBOutlet UILabel *SeriesIndicatorLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *DoneBarButton;
@property (strong, nonatomic) IBOutlet UILabel *ExerciseName;
@property (strong, nonatomic) IBOutlet UILabel *RepCount;
@property int currentExerciseIndex;
@property int RemainingSeries;
@property int TotalSeries;
@property int ExerciseAmount;
@property (strong, nonatomic) IBOutlet UILabel *DoLabel;
@property (strong, nonatomic) IBOutlet UILabel *RepsLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *HowLabel;
@property (strong, nonatomic) IBOutlet UIButton *DoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *WaitLabel;
@property (strong, nonatomic) IBOutlet UIButton *SkipLabel;
@property int RemainingCooldownSeconds;
@property (strong,nonatomic) NSTimer *stopWatchTimer; //Store the timer
@property (strong, nonatomic) IBOutlet UILabel *cooldownLabel;
@property NSString* chartstring;
@property NSString* result0;
@property NSString* result1;
@property NSString* result2;
@property NSString* language;
@property BOOL skipped;
@property (nonatomic, strong) CircularTimerView *circularTimer;
@property NSArray *RepCountInformation;
@property NSArray *CurrentExerciseData;
@property NSString* SeriesCounterString;
@end

@implementation DoExerciseScreen

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _RemainingSeries=99; //anti bug
    _result0=@"And by that, I mean... nothing?";
    _result1=@"But next time, try not to skip.";
    _result2=@"Now, don't give up!";
    _SeriesCounterString=@"Series %d of %d";
    _language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
        
        _result0=@"Mas não havia nada!";
        _result1=@"Mas na próxima, tente não pular.";
        _result2=@"Continue assim!";
        _SeriesCounterString=@"Série %d de %d";
    }
    
    [self Initiate];
   // [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.navigationBar.tintColor=self.cooldownLabel.textColor;
    self.navigationController.navigationBar.barTintColor=self.view.backgroundColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : self.cooldownLabel.textColor};
    
    _skipped=NO;
    _currentExerciseIndex=0;
    self.navigationItem.title=_chartname;
}

- (void)Initiate{
    //Hide the Cooldown Stuff
    [self HideCooldown];
    //Get the amount of exercises from the chosen chart, and show the first one
    _ExerciseAmount=(int)[_exercisedata count];
    NSLog(@"Exercise Amount on this Chart: %d",_ExerciseAmount);
    if (self.ExerciseAmount==0){
        return;
    }
    else
    [self ShowExercise:self.currentExerciseIndex];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.stopWatchTimer invalidate];
    self.stopWatchTimer = nil;
    self.navigationController.navigationBar.tintColor=nil;
    self.navigationController.navigationBar.barTintColor=nil;
    
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

-(void)HideCooldown{
    [self.stopWatchTimer invalidate];
    self.stopWatchTimer = nil;
    [self.circularTimer removeFromSuperview];
    self.NoCooldownView.hidden=NO;
   // self.DoneBarButton.enabled=YES;
   // self.cooldownLabel.hidden=YES;
   // self.WaitLabel.hidden=YES;
   // self.ExerciseName.hidden=NO;
   // self.RepCount.hidden=NO;
   // self.DoLabel.hidden=NO;
   // self.RepsLabel.hidden=NO;
   // self.HowLabel.hidden=NO;
   // self.DoneLabel.hidden=NO;
   // _SkipLabel.hidden=NO;
    
    //Checks if the series are over
    if (self.RemainingSeries<=0){
        [self Proceed];
    }
    
    [_tableView reloadData];
    
}

-(void)ShowCooldown{
    
    self.NoCooldownView.hidden=YES;
   // self.DoneBarButton.enabled=NO;
    
   // self.cooldownLabel.hidden=NO;
   // self.WaitLabel.hidden=NO;
   // self.ExerciseName.hidden=YES;
   // self.RepCount.hidden=YES;
   // self.DoLabel.hidden=YES;
   // self.RepsLabel.hidden=YES;
   // self.HowLabel.hidden=YES;
   // self.DoneLabel.hidden=YES;
   // _SkipLabel.hidden=YES;
}

- (void)ShowExercise:(int)index{
    //From the Array containing every exercise name, separate the name from the repcount, according to the current exercise index.

    _CurrentExerciseData = [[NSArray alloc] init];
    _CurrentExerciseData=[[_exercisedata objectAtIndex:index] componentsSeparatedByString:@"|"];
    
    //Now, index 0 from the new array is the name we want
    
    //self.ExerciseName.text=[NSString stringWithFormat:@"%@",[_CurrentExerciseData objectAtIndex:0]];
    
    //However, index 1 is the entire repcount. We need to separate those too, as the series amount are for internal use.
    
        _RepCountInformation = [[NSArray alloc] init];
    
        _RepCountInformation=[[_CurrentExerciseData objectAtIndex:1]componentsSeparatedByString:@"x"];
    
    //Now, 0 is the series amount, while 1 is the repcount.
    
    //self.RepCount.text=[NSString stringWithFormat:@"%@",[RepCountInformation objectAtIndex:1]];
    
    //Converting the series' NSString to int
    
    NSString *SeriesString=[_RepCountInformation objectAtIndex:0];
    
    self.TotalSeries=[SeriesString intValue];
    self.RemainingSeries=[SeriesString intValue];
        NSLog(@"Series Amount: %d",self.RemainingSeries);
    
    [_tableView reloadData];
    
}

- (IBAction)DonePressed:(id)sender {
    //When done is pressed, reduce the series number and show the cooldown.
    //Check if he started without anything
    if (self.RemainingSeries-1==0 && self.currentExerciseIndex==_ExerciseAmount-1){
        [self performSegueWithIdentifier:@"toEnd" sender:nil];
        return;
    }
    self.RemainingSeries--;
    [self Cooldown];
    //[self Proceed];
}
- (IBAction)SkipPressed:(id)sender {
    //We check if he skipped, to change the text at the end.
    self.skipped=YES;
    //When Skip is pressed, go to the next exercise regardless of the series/cooldown.
    
    //Checking if he skipped the cooldown or the exercise
    if (self.NoCooldownView.hidden==YES){
     [self HideCooldown];
     return;
    }
    
    else{
    [self HideCooldown];
    [self Proceed];
    }
}

-(void) Cooldown{
    [self ShowCooldown];
    [self createCircle];
    self.RemainingCooldownSeconds=_cooldownAmount;
    //StopwatchTimer takes 1 second to initialize, so we do it manually one time
    [self updateTimer];
            self.stopWatchTimer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

-(void)updateTimer{
    self.cooldownLabel.text=[NSString stringWithFormat:@"%02d",self.RemainingCooldownSeconds];
    if (self.RemainingCooldownSeconds==0){
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        [self HideCooldown];
    }
    else
    self.RemainingCooldownSeconds--;
}

-(void)Proceed{
    //If there's still more exercises to go, show the next one. Else, finish the app
    self.currentExerciseIndex++;
    NSLog([NSString stringWithFormat:@"%d",self.currentExerciseIndex]);
    if (self.currentExerciseIndex<self.ExerciseAmount){
        [self ShowExercise:self.currentExerciseIndex];
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
        if (self.ExerciseAmount==0){
            controller.endtext=self.result0;
            return;
        }
        if (self.skipped==YES)
        controller.endtext=self.result1;
        else
         controller.endtext=self.result2;
    }
    
    if([segue.identifier isEqualToString:@"ExerciseInfo"]){
        
        ExerciseInfoScreen *controller = (ExerciseInfoScreen *)segue.destinationViewController;
        
        controller.fullname=_exercisedata[_currentExerciseIndex];
        
        controller.infodata=self.infodata[_currentExerciseIndex];
        controller.picdata=self.picdata[_currentExerciseIndex];
    }
    
}

-(void)createCircle{
    self.circularTimer = [[CircularTimerView alloc] initWithPosition:CGPointMake(self.view.center.x-70, self.view.center.y-70)
                                                              radius:70
                                                      internalRadius:55];
    
    self.circularTimer.backgroundColor = [UIColor darkGrayColor];
    self.circularTimer.backgroundFadeColor = [UIColor darkGrayColor];
    self.circularTimer.foregroundColor = self.cooldownLabel.textColor;
    self.circularTimer.foregroundFadeColor = self.cooldownLabel.textColor;
    self.circularTimer.direction = 0;
    self.circularTimer.font = [UIFont systemFontOfSize:0];
    
    self.circularTimer.frameBlock = ^(CircularTimerView *circularTimerView){
        circularTimerView.text = [NSString stringWithFormat:@"%f", [circularTimerView intervalLength]];
    };
    [self.circularTimer setupCountdown:_cooldownAmount];
    
    __weak typeof(self) weakSelf = self;
    self.circularTimer.startBlock = ^(CircularTimerView *circularTimerView){
   //     weakSelf.statusLabel.text = @"Running!";
    };
    self.circularTimer.endBlock = ^(CircularTimerView *circularTimerView){
   //     weakSelf.statusLabel.text = @"Not running anymore!";
    };
    //self.statusLabel.text = ([self.circularTimer willRun]) ? @"Circle will run" : @"Circle won't run";
    
    [self.view addSubview:self.circularTimer];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *tapstring=@"Information";
    
    NSString *sectionName;
    switch (section)
    {
        default:
            sectionName = tapstring;
            break;
    }
    return sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tableView)
    return 4;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DoModel";
    UITableViewCell *cell;
    if (tableView==_tableView){
    if (indexPath.row==0)
        simpleTableIdentifier=@"DoModel";
    if (indexPath.row==1)
        simpleTableIdentifier=@"RepsModel";
    if (indexPath.row==2)
        simpleTableIdentifier=@"WeightModel";
    if (indexPath.row==3){
        simpleTableIdentifier=@"SeriesXofY";
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    if (indexPath.row==0){
        UILabel *NameLabel = (UILabel *)[cell.contentView.subviews objectAtIndex:1];
        NameLabel.text=[NSString stringWithFormat:@"%@",[_CurrentExerciseData objectAtIndex:0]];
    }
    
    if (indexPath.row==1){
        UILabel *RepsLabel = (UILabel *)[cell.contentView.subviews objectAtIndex:0];
        RepsLabel.text=[NSString stringWithFormat:@"%@",[_RepCountInformation objectAtIndex:1]];
    }
    
    if (indexPath.row==3){
        UILabel *sNoLabel = (UILabel *)[cell.contentView.subviews objectAtIndex:0];
        sNoLabel.text=[NSString stringWithFormat:_SeriesCounterString,self.TotalSeries-self.RemainingSeries+1,self.TotalSeries];
    }
    }
    else{
       // if (indexPath.row==0)
       //     simpleTableIdentifier=@"SkipModel";
       // if (indexPath.row==1)
            simpleTableIdentifier=@"DoneModel";
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
       // if (indexPath.row==0){
       //     UILabel *SkipLabel = (UILabel *)[cell.contentView.subviews objectAtIndex:0];
       //     SkipLabel.text=@"Skip";
       // }
        
       // if (indexPath.row==1){
            UILabel *DoneLabel = (UILabel *)[cell.contentView.subviews objectAtIndex:0];
            DoneLabel.text=@"Done";
       // }
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView!=_tableView)
    return 0;
    return 50;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier: @ "ExerciseInfo" sender: self];
}

@end
