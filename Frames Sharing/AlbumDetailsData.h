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

@property (nonatomic,strong) Manager * manager;;
@property (nonatomic,strong) NSMutableArray * photoArray;
@property (nonatomic,strong) UIStoryboard * storyboard;
@property (nonatomic, strong)UINavigationController * navigationController;



@end
