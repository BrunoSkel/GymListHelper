//
//  EndScreen.m
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/19/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "EndScreen.h"


@interface EndScreen ()
@property (strong, nonatomic) IBOutlet UILabel *EndTextLabel;
@end

@implementation EndScreen
- (void)viewDidLoad {
    [super viewDidLoad];
    _EndTextLabel.text=_endtext;
}
@end