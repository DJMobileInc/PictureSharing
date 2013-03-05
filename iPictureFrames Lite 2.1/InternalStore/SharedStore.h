//
//  SharedStore.h
//  GiftMaker
//
//  Created by sadmin on 11/24/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//
#define kAnimals 1
#define kAssorted 2
#define kChristmas 3
#define kLove 4
#define kStone 5
#define kWood 6

#define kChristmasPack @"com.djmobile.christmasFrames1"
#define kWoodPack @"com.djmobile.woodPack1"
#define kStonePack @"com.djmobile.stonelPack1"
#define kLovePack @"com.djmobile.lovePack1"
#define kAnimalPack @"com.djmobile.download.animal1"
#define kAssortedPack @"com.djmobile.assortedPack1"

#define kChristmasPackName @"Christmas"
#define kWoodPackName @"Wood"
#define kStonePackName @"Stone"
#define kLovePackName @"Love"
#define kAnimalPackName @"Animal"
#define kAssortedPackName @"Assorted"

#import <Foundation/Foundation.h>
@protocol PurchaseCompleted<NSObject>
    -(void)purchaseCompleted;
@end
@protocol RestoreCompleted<NSObject>
-(void)restoreCompleted:(NSMutableArray *)dictionary;
@end

@interface SharedStore : NSObject
+ (id)sharedStore;
@property(nonatomic,strong) NSMutableArray * allItems;
@property (nonatomic)id <PurchaseCompleted> delegate;
@property (nonatomic)id <RestoreCompleted> restoreDelegate;
-(NSMutableArray *)updateItems;

- (void)restorePreviousPurchases;
- (IBAction)buyItemsForId:(NSString *)keyId;

@end
