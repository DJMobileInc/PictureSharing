//
//  AlbumListData.h
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/25/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumListData : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,retain) NSMutableArray * objects;
@property (nonatomic,retain) UIStoryboard * storyboard;
@property (nonatomic,retain)UINavigationController * navigationController;


@end
