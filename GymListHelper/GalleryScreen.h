//
//  GalleryScreen.h
//  GymListHelper
//
//  Created by Rodrigo Dias Takase on 01/04/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryScreen : UIViewController <UITableViewDelegate, UITableViewDataSource>
    @property NSInteger ChosenCategory;
    @property NSString* ChosenCategoryName;
@end