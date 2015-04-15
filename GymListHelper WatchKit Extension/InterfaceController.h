//
//  InterfaceController.h
//  GymListHelper WatchKit Extension
//
//  Created by Bruno Henrique da Rocha e Silva on 3/24/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
    @property (strong,nonatomic)  NSMutableArray *tableData;
@end
