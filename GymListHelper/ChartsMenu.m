//
//  ChartsMenu.m
//  GymListHelper
//
//  Created by Danilo S Marshall on 3/26/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "SharePreview.h"
#import "ChartsMenu.h"
#import "ViewController.h"
#import "NewChartDescriptionEditor.h"
#import "Routine Classes/RoutineClass.h"

//#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"

@interface ChartsMenu () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property NSString *language;
@property NSString* hipertrofia;
@property NSString* definition;
@property NSString* tonification;
@property NSString* fatloss;
@property NSString* strength;
@property NSString* tab0;
@property NSString* tab1;
@property NSString* tab2;
@property NSTimer *timer;
@property int TouchedIndex;
@property BOOL isEditing;
@end

@implementation ChartsMenu

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _hipertrofia=@"Hypertrophy";
        _definition=@"Definition";
        _tonification=@"Tonification";
        _strength=@"Strength";
        _fatloss=@"Fat Loss";
        _tab0=@"Gym";
        _tab1=@"Charts";
        _language = [[NSLocale preferredLanguages] objectAtIndex:0];
        _isEditing=YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //BOOL isfirst=[self CheckifnotFirst];
    //if (isfirst==YES){
    //    [self performSegueWithIdentifier:@"Tutorial" sender:self];
    //    return;
    //}
    
    //Tabbar default selection
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:1]];
    
    //Load charts
    [self LoadChartData];
    _tableData=[NSMutableArray arrayWithArray:_allChartData];
    [self.tableView reloadData];
    
    if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
        _hipertrofia=@"Hipertrofia";
        _definition=@"Definição";
        _tonification=@"Tonificação";
        _strength=@"Potência";
        _fatloss=@"Perda de Gordura";
        _tab0=@"Academia";
        _tab1=@"Fichas";
    }
    
    UITabBarItem *item0 = [_tabBar.items objectAtIndex:0];
    item0.title=_tab0;
    UITabBarItem *item1 = [_tabBar.items objectAtIndex:1];
    item1.title=_tab1;
    [item1 setSelectedImage:[UIImage imageNamed:@"tab1sel"]];
    
    //

}

-(BOOL)CheckifnotFirst{
    int firsttime = (int)[[[NSUserDefaults standardUserDefaults] objectForKey:@"firstTimeFile"] integerValue];
    if (firsttime==0){
        firsttime++;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:firsttime] forKey:@"firstTimeFile"];
        return YES;
    }
    else{
        return NO;
    }
    //anti bug
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LoadChartData{
    
    //Load the saved charts. If there's nothing, fill the charts with the example data.
    NSString *Example=@"Example";
    NSString *likethis=@"is like this, this and this";
    NSString *WorkoutName=@"Example Workout";
    NSString *WorkoutDescription=@"This is just an example of what you can do in Mirin. Blablablablabla. Bla.";
    
    if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
        Example=@"Exemplo";
        likethis=@"é realizado assim, assim, e assim.";
        WorkoutName=@"Treino Exemplo";
        WorkoutDescription=@"Isso é apenas um exemplo do que pode ser feito no Mirin. Blablablabla. Bla.";
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"routineData"];
    
    _allChartData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    
    //NSLog(@"Current Categories chart: %@", self.ChartCategoriesArray);
    
    
    //Social
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"byUserFile"];
    
    self.ByUserArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    if (_allChartData==NULL){
        
        NSLog(@"There is no Chart data. Filling up");
        _allChartData = [NSMutableArray array];
        RoutineClass* exampleroutine=[[RoutineClass alloc] initWithDefaultSettings];
        
        exampleroutine.routineName=WorkoutName;
        exampleroutine.routineDescription=WorkoutDescription;
        [_allChartData addObject:exampleroutine];
        
    }
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    self.TouchedIndex=(int)indexPath.row;
    [self performSegueWithIdentifier: @ "EditRoutine" sender: self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //When the chart is touched, open the start screen, sending the chart ID to the next screen
    //self.TouchedIndex=(int)indexPath.row;
    //NSLog(@"Touched index: %ld",(long)indexPath.row);
    //[self performSegueWithIdentifier: @ "GoToMain" sender: self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ContainerConnection"]){
        return;
    }
    
    if([segue.identifier isEqualToString:@"GoToMain"]){
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        self.TouchedIndex=indexPath.row;
        ViewController *controller = (ViewController *)segue.destinationViewController;
        controller.ChosenWorkout=_TouchedIndex;
    }
    
    else if([segue.identifier isEqualToString:@"EditRoutine"]){
        
        NewChartDescriptionEditor *controller = (NewChartDescriptionEditor *)segue.destinationViewController;
        controller.EditThisRoutine = self.TouchedIndex;
        controller.sentNameArray = [NSMutableArray arrayWithArray:self.RoutineNamesArray];
        controller.sentCategorieArray = [NSMutableArray arrayWithArray:self.ChartCategoriesArray];
        [controller editMode];
    }
    
    else if([segue.identifier isEqualToString:@"GoToSharePreview"]){
        SharePreview *controller = (SharePreview *)segue.destinationViewController;

        controller.ShareThisRoutine=self.TouchedIndex;
        controller.RoutineNamesArray=[NSMutableArray arrayWithArray:self.RoutineNamesArray];
        controller.allChartData=self.allChartData;
        controller.allInfoData=[NSMutableArray arrayWithArray:self.allInfoData];
        controller.ChartNamesArray=[NSMutableArray arrayWithArray:self.ChartNamesArray];
        controller.WaitTimesArray=[NSMutableArray arrayWithArray:self.WaitTimesArray];
        controller.ByUserArray=[NSMutableArray arrayWithArray:self.ByUserArray];
        
        controller.ChartCategoriesArray=[NSMutableArray arrayWithArray:self.ChartCategoriesArray];
        
        NSLog(@"prepareForSegue GoToSharePreview");
        //[self ShowBetaAlert];
    }
    
    else if([segue.identifier isEqualToString:@"ToGallery"]){
        
        NSString *title=@"Routine Gallery Beta";
        NSString *message=@"Mirin's Routine Gallery is still under construction. Soon, you'll be able to share and download workouts. Try again later!";
        NSString *understand=@"I understand!";
        
        if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
            title=@"Beta da Galeria de Rotinas";
            message=@"A Galeria de Rotinas do Mirin ainda está em construção. Em breve, você poderá baixar e compartilhar treinos. Tente novamente mais tarde!";
            understand=@"Entendi!";
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: title                                                       message: message
                                                      delegate: self
                                             cancelButtonTitle:understand
                                             otherButtonTitles:nil];
        
        [alert setTag:1];
        [alert show];
        
    }
    
}

-(NSIndexPath *) getButtonIndexPath:(UIButton *) button
{
    CGRect buttonFrame = [button convertRect:button.bounds toView:self.tableView];
    return [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
}

#pragma mark Delegate Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *tapstring=@"Routines";
    
    if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
            tapstring=@"Treinos";
    }
    
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
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableModel";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (_isEditing == YES) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    //UIButton *editButton = (UIButton *)[cell.contentView.subviews objectAtIndex:0];
    //[editButton setTag:indexPath.row];
    
    UIButton *shareButton = (UIButton *)[cell.contentView.subviews objectAtIndex:1];
    
    UILabel *lbChartName = (UILabel *)[cell.contentView.subviews objectAtIndex:2];
    UILabel *lbUserName = (UILabel *)[cell.contentView.subviews objectAtIndex:3];
    UIImageView *imgUserPic = (UIImageView *)[cell.contentView.subviews objectAtIndex:4];
    UILabel *lbObjective = (UILabel*)cell.contentView.subviews[5];
    
    lbChartName.text = ((RoutineClass*)self.allChartData[indexPath.row]).routineName;
    [shareButton setEnabled:YES];
    
    UIImageView *lbImageTag = (UIImageView *)[cell.contentView.subviews objectAtIndex:0];
    
    int firstId = -1;
    NSMutableString* objectives = [NSMutableString new];
    NSMutableString* tagimagefile=@"routinetagother.png";
    BOOL tagset=NO;
    for(int i=0;i<[self.allChartData count];i++){
        if([((RoutineClass*)self.allChartData[indexPath.row]).routineCategories[i] isEqualToString:@"YES"]){
            if((i > firstId)&&(firstId != -1)){
                [objectives appendString:@", "];
            }
            if(firstId == -1){
                firstId = i;
            }
            switch(i){
                case 0:
                    [objectives appendString:self.hipertrofia];
                    break;
                case 1:
                    [objectives appendString:self.definition];
                    break;
                case 2:
                    [objectives appendString:self.tonification];
                    break;
                case 3:
                    [objectives appendString:self.fatloss];
                    break;
                case 4:
                    [objectives appendString:self.strength];
                    break;
            }
            if (tagset==NO){
                tagset=YES;
                tagimagefile=[NSString stringWithFormat:@"routinetag%d.png",i];
            }
        }
    }
    
    lbObjective.text = [NSString stringWithFormat:@"%@",objectives];
    lbImageTag.image=[UIImage imageNamed:tagimagefile];
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

-(void)ShouldShareButtonAppear:(UITableViewCell*)cell:(int)row{
}


- (IBAction)EditPressed:(id)sender {
    if (_isEditing==NO){
    self.navigationItem.leftBarButtonItem.title=@"Done";
    _isEditing=YES;
        
    }
    else{
        self.navigationItem.leftBarButtonItem.title=@"Edit";
        _isEditing=NO;
    }
    
    [self.tableView reloadData];
    
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

-(IBAction)shareButtonPressed:(UIButton*)sender{
    
                    [self ShowBetaAlert];
                    return;
    
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"loggedUserId"] == 0){ //0 means user is not logged in, go to login screen
        
        [self performSegueWithIdentifier:@"GoToLogin" sender:self];
        
    }else{

        self.TouchedIndex = (int)sender.tag;
        
        [self performSegueWithIdentifier:@"GoToSharePreview" sender:self];
               // [self ShowBetaAlert];
    }
}

- (IBAction)BrowseWorkouts:(id)sender {
    
    [self ShowBetaAlert];
    
}

-(void)ShowBetaAlert{
    NSString *title=@"Routine Gallery Beta";
    NSString *message=@"Mirin's Routine Gallery is still under construction. Soon, you'll be able to share and download workouts. Try again later!";
    NSString *understand=@"I understand!";
    
    if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
        title=@"Beta da Galeria de Rotinas";
        message=@"A Galeria de Rotinas do Mirin ainda está em construção. Em breve, você poderá baixar e compartilhar treinos. Tente novamente mais tarde!";
        understand=@"Entendi!";
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: title                                                       message: message
                                                  delegate: self
                                         cancelButtonTitle:understand
                                         otherButtonTitles:nil];
    
    [alert setTag:1];
    [alert show];
}

@end
