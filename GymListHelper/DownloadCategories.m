//
//  DownloadCategories.m
//  GymListHelper
//
//  Created by Danilo S Marshall on 3/26/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "DownloadCategories.h"
#import "GalleryScreen.h"

@interface DownloadCategories () <UITableViewDelegate, UITableViewDataSource>
    @property (strong,nonatomic)  NSMutableArray *tableData;
    @property NSInteger TouchedIndex;


@end

@implementation DownloadCategories

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableData = [NSMutableArray new];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if([language isEqualToString:@"pt"]||[language isEqualToString:@"pt_br"]){
        [self.tableData addObject:@"Hipertrofia"];
        [self.tableData addObject:@"Definição"];
        [self.tableData addObject:@"Tornificação"];
        [self.tableData addObject:@"Perda de Gordura"];
        [self.tableData addObject:@"Potência"];
    }else{
        [self.tableData addObject:@"Hypertrophy"];
        [self.tableData addObject:@"Definition"];
        [self.tableData addObject:@"Tonification"];
        [self.tableData addObject:@"Fat Loss"];
        [self.tableData addObject:@"Strengh"];
    }
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        default:
            if([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"pt"]||[[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"pt_br"]){
                sectionName = @"Toque para selecionar";
            }else{
                sectionName = @"Tap to select";
            }
            
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
    static NSString *simpleTableIdentifier = @"CategoriesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = self.tableData[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //When the chart is touched, open the start screen, sending the chart ID to the next screen
    self.TouchedIndex=indexPath.row;
    NSLog(@"Touched index: %ld",(long)indexPath.row);
    [self performSegueWithIdentifier: @ "GoToCategory" sender: self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"GoToCategory"]){
        GalleryScreen *controller = (GalleryScreen *)segue.destinationViewController;
        controller.ChosenCategory = self.TouchedIndex;
        
        controller.ChosenCategoryName = self.tableData[self.TouchedIndex];
    }
    
}


@end