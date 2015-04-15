//
//  InterfaceController.m
//  GymListHelper WatchKit Extension
//
//  Created by Bruno Henrique da Rocha e Silva on 3/24/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "InterfaceController.h"
#import "WatchTableClass.h"
@import WatchKit;
@import UIKit;

@interface InterfaceController()
@property (strong, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property (strong,nonatomic)  NSMutableArray *WatchTableData;
@property (strong,nonatomic)  NSString *WaitTimeString;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *iPhoneWarningLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *StartButton;
@property (strong,nonatomic) NSTimer *syncTimer; //Store the timer
@property NSString *retrievedSeries;
@property NSString *retrievedRep;
@property NSString *retrievedName;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
        [self CheckTableData];
        //[self PullSyncedData];
        //[self populateData];
        [self StartTimer];
}

- (void)CheckTableData{
    //Show the iPhone warning if there's no data to load
    if ([_WatchTableData count]==0){
        [_iPhoneWarningLabel setHidden:NO];
        [_StartButton setHidden:YES];
    }
    else{
        [_iPhoneWarningLabel setHidden:YES];
        [_StartButton setHidden:NO];
    }
    
}

- (void)StartTimer{
    //Pulls synced data every second
    [self CheckTableData];
    self.syncTimer= [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

-(void)updateTimer{
    [self PullSyncedData];
    [self populateData];
    [self CheckTableData];
}

-(void)StopTimer{
    [self.syncTimer invalidate];
    self.syncTimer = nil;
}

- (void)PullSyncedData{
    //Code below pulls the shared data inside a specific suite name. Sending method on ViewController.m
    NSUserDefaults *SharedData = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.coffeetime.GymWatch"];
    //Use example
    //self.myLabel.text = [SharedData stringForKey:@"savedUserInput"];
    
    //So I'll create a SyncedTableData array and pull the synced tableData
    NSMutableArray *SyncedTableData = [SharedData objectForKey:@"currentChart"];
    NSString *SyncedWaitData = [SharedData objectForKey:@"currentWaitTime"];
    //and copy the data to the tableData that will be actually used
    _WatchTableData = [NSMutableArray arrayWithArray:SyncedTableData];
    _WaitTimeString=SyncedWaitData;
    NSLog(@"Synced data: %@",_WatchTableData);
}

-(void)retrieveInformation:(int) i{
    
    //String is recieved as NAME | seriesXrep. Separate those to edit the exercise properly
    
    NSString *fullinfo=[_WatchTableData objectAtIndex:i];
    
    NSArray *CurrentExerciseData = [[NSArray alloc] init];
    CurrentExerciseData=[fullinfo componentsSeparatedByString:@"|"];
    
    //stringbyTrimming = Remove spaces from start and the end
    
    self.retrievedName=[[CurrentExerciseData objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];;
    
    NSArray *RepCountInformation = [[NSArray alloc] init];
    
    RepCountInformation=[[CurrentExerciseData objectAtIndex:1]componentsSeparatedByString:@"x"];
    
    self.retrievedSeries=[[RepCountInformation objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    self.retrievedRep=[[RepCountInformation objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}


- (void)populateData {
    //This fills the Watch table. Works differently from the phone table
    NSInteger rowno=[_WatchTableData count];
    [self.tableView setNumberOfRows:rowno withRowType:@"row"];
    for (NSInteger i = 0; i < self.tableView.numberOfRows; i++) {
        WatchTableClass* theRow = [self.tableView rowControllerAtIndex:i];
        //Name Decompose
        [self retrieveInformation:i];
        //
        [theRow.titleLabel setText:self.retrievedName];
        [theRow.seriesName setText:[NSString stringWithFormat:@"Series: %@ | Reps: %@",self.retrievedSeries,self.retrievedRep]];
    }
}

- (IBAction)OnStartPressed {
    if ([_WatchTableData count]==0)
        return;
    [self StopTimer];
    NSLog(@"Prepare for Segue");
    //Since the WatchKit only lets me send one object, I have to add the WaitTime inside the exercises array and sort it out later
    [_WatchTableData addObject:_WaitTimeString];
    [self pushControllerWithName:@"DoExerciseWATCH" context:_WatchTableData];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

//Tableview Delegates



@end



