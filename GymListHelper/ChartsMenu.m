//
//  ChartsMenu.m
//  GymListHelper
//
//  Created by Danilo S Marshall on 3/26/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "ChartsMenu.h"
#import "ViewController.h"
#import "NewChartDescriptionEditor.h"

#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"

@interface ChartsMenu () <UITableViewDelegate, UITableViewDataSource,FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *FBLoginBtn;


@property NSTimer *timer;
@property int TouchedIndex;
@end

@implementation ChartsMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    //Load charts
    [self LoadChartData];
    _tableData=[NSMutableArray arrayWithArray:_allChartData];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200",[[NSUserDefaults standardUserDefaults] valueForKey:@"loggedUserFacebookId"]]];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        
        self.profileImg.image = image;
        
        self.profileName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"loggedUserName"];
    }else{
        self.profileImg.image = [UIImage imageNamed:@"guest"];
        self.profileName.text = @"Guest";
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"loggedUserId"];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(indicator:) userInfo:nil repeats:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [_timer invalidate];
}

-(void)indicator:(BOOL)animated{
    [_tableView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LoadChartData{
    
    //Load the saved charts. If there's nothing, fill the charts with the example data.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    _allChartData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
    
    _ChartNamesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"routineNamesFile"];
    
    _RoutineNamesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"waitTimesFile"];
    
    _WaitTimesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    
    //Social
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"byUserFile"];
    
    self.ByUserArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    if (_allChartData==NULL){
        
        NSLog(@"There is no Chart data. Filling up");
        _allChartData = [NSMutableArray array];
        //Adding a new chart
        [_allChartData addObject: [NSMutableArray array]];
        //Adding charts A/B/C to the new chart
        [[_allChartData objectAtIndex:0] addObject: [NSMutableArray array]];
        [[_allChartData objectAtIndex:0] addObject: [NSMutableArray array]];
        [[_allChartData objectAtIndex:0] addObject: [NSMutableArray array]];
        //Filling A
        [[[_allChartData objectAtIndex:0] objectAtIndex:0] addObject:@"Example A1 | 4x8"];
        [[[_allChartData objectAtIndex:0] objectAtIndex:0] addObject:@"Example A2 | 4x8"];
        [[[_allChartData objectAtIndex:0] objectAtIndex:0] addObject:@"Example A3 | 4x8"];
        [[[_allChartData objectAtIndex:0] objectAtIndex:0] addObject:@"Example A4 | 4x8"];
        //Filling B
        [[[_allChartData objectAtIndex:0] objectAtIndex:1] addObject:@"Example B1 | 4x10"];
        [[[_allChartData objectAtIndex:0] objectAtIndex:1] addObject:@"Example B2 | 4x10"];
        [[[_allChartData objectAtIndex:0] objectAtIndex:1] addObject:@"Example B3 | 4x10"];
        //Filling C
        [[[_allChartData objectAtIndex:0] objectAtIndex:2] addObject:@"Example C1 | 3x15"];
        [[[_allChartData objectAtIndex:0] objectAtIndex:2] addObject:@"Example C2 | 3x15"];
        
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
        [_allChartData writeToFile:filePath atomically:YES];
        
        
        //Adding new WaitTime array
        _WaitTimesArray = [NSMutableArray array];
        [_WaitTimesArray addObject: [NSMutableArray array]];
        //Adding example times to the new chart
        [[_WaitTimesArray objectAtIndex:0] addObject: @"30"];
        [[_WaitTimesArray objectAtIndex:0] addObject: @"20"];
        [[_WaitTimesArray objectAtIndex:0] addObject: @"10"];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"waitTimesFile"];
        [_WaitTimesArray writeToFile:filePath atomically:YES];
        
    }
    if (_ChartNamesArray==NULL){
        
        _RoutineNamesArray = [NSMutableArray array];
        [_RoutineNamesArray addObject: @"Example Workout"];
        
        _ChartNamesArray = [NSMutableArray array];
        //Adding a new chart
        [_ChartNamesArray addObject: [NSMutableArray array]];
        [[_ChartNamesArray objectAtIndex:0] addObject:@"A"];
        [[_ChartNamesArray objectAtIndex:0] addObject:@"B"];
        [[_ChartNamesArray objectAtIndex:0] addObject:@"C"];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
        [_ChartNamesArray writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"routineNamesFile"];
        [_RoutineNamesArray writeToFile:filePath atomically:YES];
        
        self.ByUserArray = [NSMutableArray array];
        [self.ByUserArray addObject: @"0§myself§0"]; // separation char: § , param1: userid param2:user name, param3:shared = chartid or 0 if not shared
        
        filePath = [documentsDirectory stringByAppendingPathComponent:@"byUserFile"];
        [self.ByUserArray writeToFile:filePath atomically:YES];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //When the chart is touched, open the start screen, sending the chart ID to the next screen
    _TouchedIndex=indexPath.row;
    NSLog(@"Touched index: %ld",(long)indexPath.row);
    [self performSegueWithIdentifier: @ "GoToMain" sender: self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"GoToMain"]){
        ViewController *controller = (ViewController *)segue.destinationViewController;
        controller.ChosenWorkout=_TouchedIndex;
    }
    
    else if([segue.identifier isEqualToString:@"EditRoutine"]){
        NewChartDescriptionEditor *controller = (NewChartDescriptionEditor *)segue.destinationViewController;
        NSIndexPath *indexPath = [self getButtonIndexPath:sender];
        controller.EditThisRoutine=indexPath.row;
        controller.sentNameArray=[NSMutableArray arrayWithArray:_RoutineNamesArray];
        [controller editMode];
    }
    
}

-(NSIndexPath *) getButtonIndexPath:(UIButton *) button
{
    CGRect buttonFrame = [button convertRect:button.bounds toView:_tableView];
    return [_tableView indexPathForRowAtPoint:buttonFrame.origin];
}

#pragma mark Delegate Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        default:
            sectionName = @"Tap to Select";
            break;
    }
    return sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableModel";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIButton *editButton = (UIButton *)[cell.contentView.subviews objectAtIndex:0];
    [editButton setTag:indexPath.row];
    [editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareButton = (UIButton *)[cell.contentView.subviews objectAtIndex:1];
    
    UILabel *lbChartName = (UILabel *)[cell.contentView.subviews objectAtIndex:2];
    UILabel *lbUserName = (UILabel *)[cell.contentView.subviews objectAtIndex:3];
    UIImageView *imgUserPic = (UIImageView *)[cell.contentView.subviews objectAtIndex:4];
    
    lbChartName.text = [self.RoutineNamesArray objectAtIndex:indexPath.row];
    // separation char: § , param1: userid param2:user name, param3:shared = chartid or 0 if not shared
    
    NSArray* params = [self.ByUserArray[indexPath.row] componentsSeparatedByString: @"§"];
    
    if([params[1] isEqualToString:@"myself"]){
        if([params[2] isEqualToString:@"0"]){
            
            [shareButton setTag:indexPath.row];
            [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            [shareButton setEnabled:NO];
        }
        
        [shareButton setHidden:NO];
        [lbUserName setHidden:YES];
        [imgUserPic setHidden:YES];
    }else{
        [shareButton setHidden:YES];
        [lbUserName setHidden:NO];
        [imgUserPic setHidden:NO];
        lbUserName.text = [NSString stringWithFormat:@"by %@",params[1]];
        
        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100",params[0]]];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        imgUserPic.image = image;

    }

    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Required method for not losing data after changing viewcontrollers. Its supposed to be empty
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue{
    
}


-(IBAction)editButtonPressed:(UIButton*)sender{
    NSLog(@"%ld",(long)sender.tag);
    NSLog(@"%@",self.ChartNamesArray[sender.tag]);
    NSLog(@"%@",self.RoutineNamesArray[sender.tag]);
    NSLog(@"%@",self.WaitTimesArray[sender.tag]);
    NSLog(@"%@",self.allChartData[sender.tag]);
    NSLog(@"%@",self.ByUserArray[sender.tag]);

}

-(IBAction)shareButtonPressed:(UIButton*)sender{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"loggedUserId"] == 0){ //0 means user is not logged in, go to login screen
        
        [self performSegueWithIdentifier:@"GoToLogin" sender:self];
        
    }else{
    
        NSLog(@"%ld",(long)sender.tag);
        NSLog(@"%@",self.ChartNamesArray[sender.tag]);
        NSLog(@"%@",self.RoutineNamesArray[sender.tag]);
        NSLog(@"%@",self.WaitTimesArray[sender.tag]);
        NSLog(@"%@",self.allChartData[sender.tag]);
        NSLog(@"%@",self.ByUserArray[sender.tag]);
        
        [sender setEnabled:NO];
        

        NSError *error = NULL;
        
        //Serialize ChartNamesArray
        NSData *jsonData = [[CJSONSerializer serializer] serializeObject:self.ChartNamesArray[sender.tag] error:&error];
        NSString* jsonSrtChartNames = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        //Serialize WaitTimesArray
        jsonData = [[CJSONSerializer serializer] serializeObject:self.WaitTimesArray[sender.tag] error:&error];
        NSString* jsonSrtWaitTimes = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        //Serialize allChartData
        jsonData = [[CJSONSerializer serializer] serializeObject:self.allChartData[sender.tag] error:&error];
        NSString* jsonSrtAllChartData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        //Create "form" data
        NSString *sendData = @"userid=";
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"0"]];
        
        sendData = [sendData stringByAppendingString:@"&name="];
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", self.RoutineNamesArray[sender.tag]]];
        
        sendData = [sendData stringByAppendingString:@"&category="];
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];
        
        sendData = [sendData stringByAppendingString:@"&category1="];
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"0"]];
        
        sendData = [sendData stringByAppendingString:@"&category2="];
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"0"]];
        
        sendData = [sendData stringByAppendingString:@"&category3="];
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"0"]];
        
        sendData = [sendData stringByAppendingString:@"&estimatedTime="];
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];
        
        sendData = [sendData stringByAppendingString:@"&waitTime="];
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", jsonSrtWaitTimes]];
        
        sendData = [sendData stringByAppendingString:@"&language="];
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @"0"]];
        
        sendData = [sendData stringByAppendingString:@"&comment="];
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];
        
        sendData = [sendData stringByAppendingString:@"&chartNames="];
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", jsonSrtChartNames]];
        
        sendData = [sendData stringByAppendingString:@"&exercises="];
        sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", jsonSrtAllChartData]];
        
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
            NSLog(@"Error");
        }
        else
        {
            //The response is in data
            NSLog(@"%@", results);
            
            if([results isEqualToString:@"ERROR2"]){
                NSLog(@"Error2");
            }else{
                NSLog(@"Compartilhado");
                
                self.ByUserArray[sender.tag] = [NSString stringWithFormat:@"0§myself§%@", results];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"byUserFile"];
                [self.ByUserArray writeToFile:filePath atomically:YES];
                
            }
        }
    }
}

- (IBAction)LogInOutAction:(id)sender {
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"loggedUserId"] == 0){
        //Go To Login Screen
        [self performSegueWithIdentifier:@"GoToLogin" sender:self];
    }else{
        //Logout
        self.profileImg.image = [UIImage imageNamed:@"guest"];
        self.profileName.text = @"Guest";
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"loggedUserId"];
        //[FBSDKLoginManager finalize];
        //[FBSDKAccessToken ];
    }
    
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)FBLoginBtn{
    NSLog(@"LOGOUT");

    self.profileImg.image = [UIImage imageNamed:@"guest"];
    self.profileName.text = @"Guest";

}

- (void)
loginButton:	(FBSDKLoginButton *)FBLoginBtn
didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
error:	(NSError *)error
{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 
                 NSLog(@"fetched user:%@", result);
                 
                 [[NSUserDefaults standardUserDefaults] setValue: result[@"id"] forKey:@"loggedUserFacebookId"];
                 
                 [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@ %@", result[@"first_name"],result[@"last_name"]] forKey:@"loggedUserName"];
                 
                 NSString *sendData = @"facebookid=";
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", result[@"id"]]];
                 
                 sendData = [sendData stringByAppendingString:@"&name="];
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@ %@", result[@"first_name"],result[@"last_name"]]]];
                 
                 sendData = [sendData stringByAppendingString:@"&email="];
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];
                 
                 sendData = [sendData stringByAppendingString:@"&password="];
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];
                 
                 sendData = [sendData stringByAppendingString:@"&pic="];
                 sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%@", @""]];
                 
                 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.gamescamp.com.br/gymhelper/webservices/insertUser.php"]];
                 
                 [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
                 
                 //Here you send your data
                 [request setHTTPBody:[sendData dataUsingEncoding:NSUTF8StringEncoding]];
                 
                 [request setHTTPMethod:@"POST"];
                 NSURLResponse *response = nil;
                 NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                 
                 NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 
                 
                 if (error)
                 {
                     NSLog(@"Error");
                 }
                 else
                 {
                     //The response is in data
                     NSLog(@"%@", results);
                     
                     if([results isEqualToString:@"ERROR2"]){
                         NSLog(@"InsertUser Error2");
                     }else{
                         NSLog(@"InsertUser ok = %@",results);
                         
                         [[NSUserDefaults standardUserDefaults] setInteger:[results intValue] forKey:@"loggedUserId"];
                         
                         NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200",[[NSUserDefaults standardUserDefaults] valueForKey:@"loggedUserFacebookId"]]];
                         NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
                         UIImage * image = [UIImage imageWithData:imageData];
                         
                         self.profileImg.image = image;
                         
                         self.profileName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"loggedUserName"];
                     }
                 }
                 
             }
         }];
    }else{
        NSLog(@"Not Logged");
    }
}

@end
