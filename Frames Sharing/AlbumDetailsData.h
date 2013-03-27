//
//  AlbumDetailsData.h
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/25/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Manager.h"

@interface AlbumDetailsData : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,retain) Manager * manager;;
@property (nonatomic,retain) NSMutableArray * photoArray;
@property (nonatomic,retain) UIStoryboard * storyboard;
@property (nonatomic,retain)UINavigationController * navigationController;



@end
