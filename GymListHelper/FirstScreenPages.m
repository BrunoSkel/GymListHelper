//
//  FirstScreenPages.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/30/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirstScreenPages.h"

@interface FirstScreenPages ()


@end

@implementation FirstScreenPages
- (IBAction)OnStart:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //screensize
    CGRect screenBound=[[UIScreen mainScreen]bounds];
    CGSize screenSize= screenBound.size;
    //
    
    CGRect myImageRect = CGRectMake(0.0f, 0.0f, screenSize.width, screenSize.height);
    UIImageView *result = [[UIImageView alloc] initWithFrame:myImageRect];
    
    result.contentMode=UIViewContentModeScaleToFill;
    
    result.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
    self.StartBut.hidden=self.ShouldHide;
    
    [self.view addSubview:result];
    
    [self.view addSubview:self.StartBut];
}

@end