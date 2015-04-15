//
//  GalleryScreen.m
//  GymListHelper
//
//  Created by Rodrigo Dias Takase on 01/04/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "GalleryScreen.h"
#import "ChartsMenu.h"
#import "CJSONDeserializer.h"
#import "DownloadPreview.h"

@interface GalleryScreen () <UITableViewDelegate, UITableViewDataSource>

    @property (weak, nonatomic) IBOutlet UILabel *lbCategoryName;

    @property (strong,nonatomic)  NSMutableArray *tableData;
    @property (strong) IBOutlet UITableView *tableView;

    @property ChartsMenu *controller;

    @property (strong, nonatomic) NSArray* arrLanguages;

    @property (nonatomic) NSInteger TouchedIndex;

    @property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation GalleryScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrLanguages = @[@"English",@"Portuguese",@"Spanish",@"Chinese",@"Danish",@"Dutch",@"Finnish",@"French",@"German",@"Greek",@"Indonesian",@"Italian",@"Japanese",@"Korean",@"Malay",@"Norwegian",@"Russian",@"Swedish",@"Thai",@"Turkish",@"Vietnamese",@"Other"];
 
    self.tableData = [NSMutableArray new];
    
    [self getChartsFromDB];

    self.lbCategoryName.text = self.ChosenCategoryName;
    
    [self.picker selectRow:self.ChosenLanguage inComponent:0 animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{

}

-(void)viewDidDisappear:(BOOL)animated{

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count] - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"GalleryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if([self.tableData count] > 0){
        if([self.tableData[indexPath.row] count] > 0){
            //cell.textLabel.text = self.tableData[indexPath.row][4];
            
            UILabel *lbChartName = (UILabel *)cell.contentView.subviews[0];
            lbChartName.text = self.tableData[indexPath.row][4];
            
            UILabel *lbUserName = (UILabel *)cell.contentView.subviews[1];
            lbUserName.text = [NSString stringWithFormat:@"by %@",self.tableData[indexPath.row][0]];
            
            UIImageView *imgPic = (UIImageView *)cell.contentView.subviews[2];
            NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100",self.tableData[indexPath.row][1]]];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage * image = [UIImage imageWithData:imageData];
            imgPic.image = image;
            
        }
    }

    return cell;
}

-(void)getChartsFromDB{
    [self.tableData removeAllObjects];
    
    NSError *error = NULL;
    
    NSString *sendData = @"category=";
    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%d", (self.ChosenCategory + 1)]];
    
    sendData = [sendData stringByAppendingString:@"&language="];
    sendData = [sendData stringByAppendingString:[NSString stringWithFormat:@"%d", self.ChosenLanguage]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.gamescamp.com.br/gymhelper/webservices/getChartsWithCategory.php"]];
    
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
        NSArray* chartsData = [results componentsSeparatedByString: @"¶"];
        for(NSString *chartData in chartsData){
            NSArray* chartInfo = [chartData componentsSeparatedByString: @"§"];
        
            NSMutableArray *cellData = [NSMutableArray new];
            
            for(int i=0;i<[chartInfo count];i++){
                [cellData addObject:chartInfo[i]];
            }
            
            [self.tableData addObject:cellData];

        }
    }
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //When the chart is touched, open the start screen, sending the chart ID to the next screen
    self.TouchedIndex=(int)indexPath.row;
    NSLog(@"Touched index: %ld",(long)indexPath.row);
    [self performSegueWithIdentifier: @ "GoToPreview" sender: self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"GoToPreview"]){
        DownloadPreview *controller = (DownloadPreview *)segue.destinationViewController;
        //controller.ChosenWorkout=_TouchedIndex;
        
        controller.currentDownloadChart = [NSArray arrayWithArray:self.tableData[self.TouchedIndex]];
        
        controller.currentCategory = self.ChosenCategory;
        controller.currentCategoryName = self.ChosenCategoryName;
        controller.currentLanguage = self.ChosenLanguage;
        
        
        //NSLog(@"%@",self.tableData[self.TouchedIndex]);
    }
    
}
//PickerStuff

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.arrLanguages count];
}

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
    NSLog(@"row chosen = %ld",(long)row);
    
    
    [self getChartsFromDB];
    
}

@end
