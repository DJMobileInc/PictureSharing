//
//  StoreItemsViewController.h
//  GiftMaker
//
//  Created by Janusz Chudzynski on 11/28/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Content.h"
@interface StoreItemsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) Content * images;
@property (nonatomic,strong) NSString * key;

@end
