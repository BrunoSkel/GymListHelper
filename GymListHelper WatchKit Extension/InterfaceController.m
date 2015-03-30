//
//  InterfaceController.m
//  GymListHelper WatchKit Extension
//
//  Created by Bruno Henrique da Rocha e Silva on 3/24/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import "InterfaceController.h"
#import "WatchTableClass.h"

@interface InterfaceController()
@property (strong, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property (strong,nonatomic)  NSMutableArray *WatchTableData;
@property (strong,nonatomic)  NSString *WaitTimeString;
@property (strong,nonatomic) NSTimer *syncTimer; //Store the timer
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
        [self PullSyncedData];
        [self populateData];
        [self StartTimer];
}

- (void)StartTimer{
    //Pulls synced data every second
    self.syncTimer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

-(void)updateTimer{
    [self PullSyncedData];
    [self populateData];
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


- (void)populateData {
    //This fills the Watch table. Works differently from the phone table
    NSInteger rowno=[_WatchTableData count];
    [self.tableView setNumberOfRows:rowno withRowType:@"row"];
    for (NSInteger i = 0; i < self.tableView.numberOfRows; i++) {
        WatchTableClass* theRow = [self.tableView rowControllerAtIndex:i];
        [theRow.titleLabel setText:[_WatchTableData objectAtIndex:i]];
    }
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



