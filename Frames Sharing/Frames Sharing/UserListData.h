//
//  UserListData.h
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 4/24/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Manager.h"
@interface UserListData : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    
    Manager * manager;
}
@property (nonatomic,retain) NSMutableArray * objects;
@property (nonatomic,retain) UIStoryboard * storyboard;
@property (nonatomic,retain)UINavigationController * navigationController;
@end
