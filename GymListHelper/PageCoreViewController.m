//
//  PageCoreViewController.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/30/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageCoreViewController.h"
#import "FirstScreenPages.h"
//#import "PageViewOverride.h"

@interface PageCoreViewController ()

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (weak, nonatomic) IBOutlet UIButton *StartBut;

@end

@implementation PageCoreViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    //XCODE BUG FIXER
    //[PageViewOverride _bugFix];
    //
    //Check if it's not the first time he sees this screen..
    BOOL isfirst=[self CheckifnotFirst];
    if (isfirst==NO){
        [self performSegueWithIdentifier:@"ToMain" sender:self];
        return;
    }
    // Create the data model
    _pageTitles = @[@"Welcome!", @"Easy", @"Helpful", @"Apple Watch"];
    _pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    FirstScreenPages *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    

    
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

- (FirstScreenPages *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    FirstScreenPages *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.ShouldHide=YES;
    if (index==3){
       pageContentViewController.ShouldHide=NO;
        NSLog(@"ShowGetStarted");
    }
   // else
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((FirstScreenPages*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((FirstScreenPages*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
