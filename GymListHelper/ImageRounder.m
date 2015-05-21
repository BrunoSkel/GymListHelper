//
//  ImageRounder.m
//  Mirin
//
//  Created by Bruno Henrique da Rocha e Silva on 5/7/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import "ImageRounder.h"

@implementation ImageRounder

-(void)awakeFromNib{
    
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.clipsToBounds = YES;
}

@end
