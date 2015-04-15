//
//  PageViewOverride.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/31/15.
//  Copyright (c) 2015 çå. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageViewOverride.h"

@interface PageViewOverride ()

@property UIPageViewController* pageController;
@end

@implementation PageViewOverride

-(void)viewDidLayoutSubviews {
    UIView* v = self.view;
    NSArray* subviews = v.subviews;
    if( [subviews count] == 2 ) {
        UIScrollView* sv = nil;
        UIPageControl* pc = nil;
        for( UIView* t in subviews ) {
            if( [t isKindOfClass:[UIScrollView class]] ) {
                sv = (UIScrollView*)t;
            } else if( [t isKindOfClass:[UIPageControl class]] ) {
                pc = (UIPageControl*)t;
            }
        }
        if( sv != nil && pc != nil ) {
            // expand scroll view to fit entire view
            sv.frame = v.bounds;
            // put page control in front
            [v bringSubviewToFront:pc];
        }
    }
    [super viewDidLayoutSubviews];
    
}

@end