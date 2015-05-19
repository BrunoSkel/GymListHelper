//
//  GoalCellController.m
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 5/7/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "GoalCellController.h"
#import "GoalPicker.h"

@interface GoalCellController ()
@property NSString *language;
@property NSString* hipertrofia;
@property NSString* definition;
@property NSString* tonification;
@property NSString* fatloss;
@property NSString* strength;
@property NSString* SeveralString;
@property NSString* NoneString;
@end

@implementation GoalCellController

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _SeveralString=@"(Several)";
        _NoneString=@"None";
        _hipertrofia=@"Hypertrophy";
        _definition=@"Definition";
        _tonification=@"Tonification";
        _strength=@"Strength";
        _fatloss=@"Fat Loss";
        _language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if([self.language isEqualToString:@"pt"]||[self.language isEqualToString:@"pt_br"]){
            _SeveralString=@"(Vários)";
            _NoneString=@"Nenhum";
            _hipertrofia=@"Hipertrofia";
            _definition=@"Definição";
            _tonification=@"Tonificação";
            _strength=@"Potência";
            _fatloss=@"Perda de Gordura";
        }
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    GoalPicker* controller=(GoalPicker *)segue.destinationViewController;
    controller.parent=self.parent;
}

-(void)viewWillAppear:(BOOL)animated{
    self.detailLabel.text=_NoneString;
    int goalnumber=0;
    //Changing the Detail text according to goals chosen
    for (int i=0;i<[self.parent.ChartCategories count];i++){
        if ([self.parent.ChartCategories[i] isEqual:@"YES"]){
            goalnumber++;
        }
    }
    
    if (goalnumber>1)
        self.detailLabel.text=_SeveralString;
    
    else if (goalnumber!=0){
        if ([self.parent.ChartCategories[0] isEqual:@"YES"]){
            self.detailLabel.text=_hipertrofia;
        }
        if ([self.parent.ChartCategories[1] isEqual:@"YES"]){
            self.detailLabel.text=_definition;
        }
        if ([self.parent.ChartCategories[2] isEqual:@"YES"]){
            self.detailLabel.text=_tonification;
        }
        if ([self.parent.ChartCategories[3] isEqual:@"YES"]){
            self.detailLabel.text=_fatloss;
        }
        if ([self.parent.ChartCategories[4] isEqual:@"YES"]){
            self.detailLabel.text=_strength;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
