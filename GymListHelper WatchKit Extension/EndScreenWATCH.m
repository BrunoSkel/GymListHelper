//
//  EndScreenWATCH.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/31/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import "EndScreenWATCH.h"
//#import "EndScreen.h"
@import WatchKit;
@import UIKit;

@interface EndScreenWATCH ()
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *EndLabel;
@end

@implementation EndScreenWATCH
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [_EndLabel setText:context];
}
@end