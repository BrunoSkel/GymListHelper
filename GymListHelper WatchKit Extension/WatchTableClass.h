//
//  WatchTableClass.h
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/24/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface WatchTableClass : NSObject
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *seriesName;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@end