//
//  NewChartDescriptionEditor.h
//  GymListHelper
//
//  Created by Danilo S Marshall on 3/26/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewChartDescriptionEditor : UIViewController <UITextFieldDelegate>

@property int EditThisRoutine;
@property BOOL isEdit;
@property NSMutableArray* sentNameArray;
@property NSMutableArray* sentCategorieArray;
@property NSMutableArray* sentDescriptionArray;
@property NSMutableArray* sentEstimatedTimeArray;

@property (strong, nonatomic) IBOutlet UITextField *ChartNameNew;
@property (strong, nonatomic) IBOutlet UILabel *MainLabel;

-(void)editMode;

@end
