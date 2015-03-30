//
//  FirstScreenPages.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/30/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirstScreenPages.h"

@interface FirstScreenPages ()


@end

@implementation FirstScreenPages

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
}

@end