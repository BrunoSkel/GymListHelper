//
//  TermsScreen.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 4/16/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TermsScreen.h"

@interface TermsScreen ()



@end

@implementation TermsScreen
- (IBAction)AgreeOnTouch:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"termsofUseFile"];
    [self performSegueWithIdentifier: @"AgreeTouched" sender: self];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue{
}

@end