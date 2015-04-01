//
//  NewChartDescriptionEditor.h
//  GymListHelper
//
//  Created by Danilo S Marshall on 3/26/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewChartDescriptionEditor : UIViewController

@property int EditThisRoutine;
-(void)editMode;
@property NSMutableArray* sentNameArray;
@property BOOL isEdit;
@property (strong, nonatomic) IBOutlet UITextField *ChartNameNew;
@property (strong, nonatomic) IBOutlet UILabel *MainLabel;
@end
