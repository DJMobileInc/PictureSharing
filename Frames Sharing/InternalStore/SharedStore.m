//
//  SharedStore.m
//  GiftMaker
//
//  Created by sadmin on 11/24/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//
#import "SharedStore.h"
#import "MKStoreManager.h"
#import "Content.h"
#import "ContentPack.h"

@implementation SharedStore
@synthesize allItems;
+ (id)sharedStore
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (IBAction)buyItemsForId:(NSString *)keyId {

    if( [MKStoreManager isFeaturePurchased:keyId])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"you have already purchased this feature" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
        [self updateItems];
        
    }
    else{
        MKStoreManager * mkstore =    [MKStoreManager sharedManager];
        
        NSLog(@"Trying to buy.. %@ ",keyId);
        [mkstore buyFeature:keyId onComplete:^(NSString* purchasedFeature, NSData*purchasedReceipt, NSArray* availableDownloads){
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Purchase was successfully completed. Enjoy!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            
            [self updateItems];
            [_delegate purchaseCompleted];

        }
                onCancelled:^{
                    NSLog(@"Couldn't buy.. hmmmmmmm ");
                
                }];
        
    }
}


-(NSMutableArray *)getAllItems{
    NSMutableArray *content = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray * defaultContent = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray * premiumContent = [[NSMutableArray alloc]initWithCapacity:0];
    
    [defaultContent addObject:@"christmas frame 1 ipad"];
    [defaultContent addObject:@"christmas frame 2 ipad"];
    [defaultContent addObject:@"christmas frame 3 ipad"];
   
    [defaultContent addObject:@"christmas frame 6 ipad"];
    [defaultContent addObject:@"christmas frame 7 ipad"];
    [defaultContent addObject:@"christmas frame 8 ipad"];
    [defaultContent addObject:@"christmas_me_5"];
    [defaultContent addObject:@"christmas_me_6"];
    [defaultContent addObject:@"christmas_me_7"];

    
    [premiumContent  addObject:@"christmas frame 4 ipad"];
    [premiumContent  addObject:@"christmas frame 5 ipad"];
    [premiumContent  addObject:@"christmas frame 9 ipad"];
    [premiumContent  addObject:@"christmas frame 10 ipad"];
    [premiumContent  addObject:@"christmas frame 11 ipad"];
    [premiumContent  addObject:@"christmas frame 12 ipad"];
    [premiumContent  addObject:@"christmas frame 13 ipad"];
    [premiumContent  addObject:@"christmas frame 14 ipad"];
    [premiumContent  addObject:@"christmas frame 15 ipad"];
    [premiumContent  addObject:@"christmas_me_3"];
    [premiumContent  addObject:@"christmas_me_4"];
    [premiumContent  addObject:@"christmas_me_8"];
    [premiumContent  addObject:@"christmas_me_9"];
    [premiumContent  addObject:@"christmas_me_1"];
    [premiumContent  addObject:@"christmas_me_2"];

    //Key
    ContentPack * christmas = [self createContentPackWithDefaultContent:defaultContent andPremiumContent:premiumContent forKey:kChristmasPack];
    christmas.commonName = kChristmasPackName;
    [content addObject:christmas];
    
    //Animals
    NSMutableArray * adefaultContent = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray * apremiumContent = [[NSMutableArray alloc]initWithCapacity:0];
    
    [adefaultContent addObject:@"fur"];

    [adefaultContent addObject:@"lampard"];
    [adefaultContent addObject:@"lampard2"];
    [adefaultContent addObject:@"reptile1"];
    [adefaultContent addObject:@"reptile2"];
    [adefaultContent addObject:@"zebra2"];
    
    [apremiumContent  addObject:@"lampard3"];
    [apremiumContent  addObject:@"lampard4"];
    [apremiumContent addObject:@"reptile4"];
    [apremiumContent addObject:@"reptile3"];
    [apremiumContent addObject:@"tiger"];
    [apremiumContent addObject:@"zebra1"];

    [apremiumContent addObject:@"fur2"];
    
    ContentPack *animals = [self createContentPackWithDefaultContent:adefaultContent andPremiumContent:apremiumContent forKey:kAnimalPack];
    animals.commonName = kAnimalPackName;
    [content addObject:animals];
    
    [apremiumContent removeAllObjects];
    [adefaultContent removeAllObjects];
    
    
    [apremiumContent addObject:@"metal"];
    [apremiumContent addObject:@"artistic"];
    [apremiumContent addObject:@"artisticgreen"];
    [apremiumContent addObject:@"artisticRed"];
    [apremiumContent addObject:@"artisticStripes"];
    [apremiumContent addObject:@"bluesilver"];
    [apremiumContent addObject:@"hell"];
    [apremiumContent addObject:@"hell2"];
    [apremiumContent addObject:@"metalPins"];
    [apremiumContent addObject:@"metalPlate2"];
    [apremiumContent addObject:@"orange"];
    [apremiumContent addObject:@"redYellow"];
    [apremiumContent addObject:@"simpleBlue"];
    [apremiumContent addObject:@"zebra"];
    [apremiumContent addObject:@"yellow"];    
    
    [adefaultContent addObject:@"pack4_2"];
    [adefaultContent addObject:@"pack4_5"];
    [adefaultContent addObject:@"pack4_7"];
    [adefaultContent addObject:@"pack5_1"];
    [adefaultContent addObject:@"pack5_10"];
    
    [adefaultContent addObject:@"pack5_11"];
    [adefaultContent addObject:@"pack5_12"];

    [adefaultContent addObject:@"pack5_13"];
    [adefaultContent addObject:@"pack5_14"];
    [adefaultContent addObject:@"pack5_15"];
    
    [adefaultContent addObject:@"pack5_17"];
    [adefaultContent addObject:@"pack5_18"];
    [adefaultContent addObject:@"pack5_19"];
    [adefaultContent addObject:@"pack5_20"];
    [adefaultContent addObject:@"pack5_22"];
   
    [adefaultContent addObject:@"metal"];
    [adefaultContent addObject:@"pack5_6"];
    [adefaultContent addObject:@"pack5_8"];
    [adefaultContent addObject:@"pack5_9"];
    [adefaultContent addObject:@"pack6_1"];
    [adefaultContent addObject:@"pack6_2"];
    [adefaultContent addObject:@"pack6_3"];
  

    ContentPack *assorted = [self createContentPackWithDefaultContent:adefaultContent andPremiumContent:apremiumContent forKey:kAssortedPack];
    assorted.commonName = kAssortedPackName;
    [content addObject:assorted];

    
    [apremiumContent removeAllObjects];
    [adefaultContent removeAllObjects];
    
    [adefaultContent addObject:@"love"];
    [adefaultContent addObject:@"love2"];
    [adefaultContent addObject:@"love3"];
    [adefaultContent addObject:@"love4"];
    [adefaultContent addObject:@"love5"];
    [adefaultContent addObject:@"love6"];
    [adefaultContent addObject:@"heart1"];
    [adefaultContent addObject:@"heart2"];
    [adefaultContent addObject:@"heart6"];

    [apremiumContent addObject:@"love7"];
    [apremiumContent addObject:@"love8"];
    [apremiumContent addObject:@"love9"];
    [apremiumContent addObject:@"love10"];
    [apremiumContent addObject:@"love11"];
    [apremiumContent addObject:@"love12"];
    [apremiumContent addObject:@"love13"];
    [apremiumContent addObject:@"love14"];
    [apremiumContent addObject:@"love15"];

    ContentPack *love = [self createContentPackWithDefaultContent:adefaultContent andPremiumContent:apremiumContent forKey:kLovePack];
    love.commonName = kLovePackName;
    [content addObject:love];

    [apremiumContent removeAllObjects];
    [adefaultContent removeAllObjects];
    
    [adefaultContent addObject:@"stone1"];
    [adefaultContent addObject:@"stone2"];
    [adefaultContent addObject:@"stone3"];
    
    [apremiumContent addObject:@"stone4"];
    [apremiumContent addObject:@"stone5"];
    [apremiumContent addObject:@"stone6"];
    [apremiumContent addObject:@"stone7"];
    [apremiumContent addObject:@"stone8"];
    [apremiumContent addObject:@"stone9"];
    
    ContentPack *stone = [self createContentPackWithDefaultContent:adefaultContent andPremiumContent:apremiumContent forKey:kStonePack];
    stone.commonName = kStonePackName;
    [content addObject:stone];

    [apremiumContent removeAllObjects];
    [adefaultContent removeAllObjects];
    
    [adefaultContent addObject:@"ash"];
    [adefaultContent addObject:@"fiddleback"];
 //   [adefaultContent addObject:@"honduran_multiply"];
    [adefaultContent addObject:@"knotty"];
    [adefaultContent addObject:@"purplepart"];
    [adefaultContent addObject:@"teakandholly"];
    
    [apremiumContent addObject:@"wood"];
    [apremiumContent addObject:@"wood1"];
    [apremiumContent addObject:@"wood2"];
    [apremiumContent addObject:@"wood3"];
    [apremiumContent addObject:@"wood4"];
    [apremiumContent addObject:@"wood5"];
    [apremiumContent addObject:@"wood6"];
    [apremiumContent addObject:@"wood7"];
    [apremiumContent addObject:@"wood8"];
    [apremiumContent addObject:@"wood9"];
    
    ContentPack *wood = [self createContentPackWithDefaultContent:adefaultContent andPremiumContent:apremiumContent forKey:kWoodPack];
    wood.commonName = kWoodPackName;
    [content addObject:wood];

    
    
    return content;
}


-(NSMutableArray *)updateItems{
    NSMutableArray * oldArray =  [self getAllItems];
    NSMutableArray * newArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    for(ContentPack * cp in oldArray){
        ContentPack * updatedContent = [self checkIfBought:cp];
        [newArray addObject:updatedContent];
    }

    [_restoreDelegate restoreCompleted:newArray];

    self.allItems = newArray;
    return newArray;
}

-(int)seeIfString:(NSString*)thisString ContainsThis:(NSString*)containsThis
{
    NSRange textRange = [[thisString lowercaseString] rangeOfString:[containsThis lowercaseString]];
    
    if(textRange.location != NSNotFound)
        return textRange.location;
    
    return -1;
}

-(NSMutableArray * )createThumbnailsFor:(NSMutableArray *)tempDefault{

    NSMutableArray * arrayThumbnails  = [[NSMutableArray alloc]initWithCapacity:0];
    
    for(NSString * imText in tempDefault){
        NSMutableString * s = [[NSMutableString alloc]initWithString:imText];
        int index = [self seeIfString:s ContainsThis:@"."];
        if(index!=-1)
        {
            [s insertString:@"_thumb" atIndex:index];
        }
        UIImage * thumb = [UIImage imageNamed:s];
        if(thumb){
        [arrayThumbnails addObject:thumb];
        }
        else{
            NSLog(@"%@ Error Doesn't Exist ", s);
        }
 
    }
    return arrayThumbnails;
}

-(NSMutableArray * )createImagesFor:(NSMutableArray *)tempDefault{
   NSMutableArray * imageNamesArray  = [[NSMutableArray alloc]initWithCapacity:0];
    for(NSString * s in tempDefault)
    {   UIImage *im = [UIImage imageNamed:s];
        if(im)
        {
            [imageNamesArray addObject:im];
        }
        else{
            NSLog(@" Error Image %@ doesn't exist ",s );
        }
    }
    return imageNamesArray;
}



-(ContentPack *)createContentPackWithDefaultContent:(NSMutableArray *) defaultArray andPremiumContent:(NSMutableArray *)premiumArray forKey:(NSString*)key{
    ContentPack * contentPack = [[ContentPack alloc]init];
    Content * defaultContent = [[Content alloc]init];
    Content * premiumContent = [[Content alloc]init];

    NSMutableArray * premiumContentArrayThumbnails = [self createThumbnailsFor:premiumArray];
    NSMutableArray * premiumContentArray=[self createImagesFor:premiumArray];
    premiumContent.images = premiumContentArray;
    premiumContent.thumbnails = premiumContentArrayThumbnails;
    
    NSMutableArray * freeContentArrayThumbnails = [self createThumbnailsFor:defaultArray];
    NSMutableArray * freeContentArray=[self createImagesFor:defaultArray];
    defaultContent.thumbnails = freeContentArrayThumbnails;
    defaultContent.images = freeContentArray;

    contentPack.premiumContent = premiumContent;
    contentPack.freeContent = defaultContent;
    contentPack.key = key;
    return contentPack;
}


-(ContentPack *)checkIfBought:(ContentPack *)contentPack{
    if( [MKStoreManager isFeaturePurchased:contentPack.key])
    {
        NSLog(@" it is purchased ");
        for(UIImage * im in contentPack.premiumContent.images)
        {
            [contentPack.freeContent.images addObject:im];
        }
        
        for(UIImage * im in contentPack.premiumContent.thumbnails)
        {
            [contentPack.freeContent.thumbnails addObject:im];
        }
    }
    else{
        NSLog(@" it is not purchased ");
        
    }
    return contentPack;
}
\


- (void)restorePreviousPurchases { //needs account info to be entered
    if([SKPaymentQueue canMakePayments]) {
        [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^(void) {
            NSLog(@"Restored.");
            /* update views, etc. */
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Your purchased items were successfully restored. Enjoy!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];

            [self updateItems];
            
        }
       onError:^(NSError *error) {
           NSLog(@"Couldn't be Restored."); 
   
       
       }];
    }
    else
    {

        /* show parental control warning */
    }
}


-(void)buyFeaturesForIdentifier:(NSString * )identifier{
    
    NSLog(@"Identifier: %@",identifier);
    MKStoreManager * mkstore =    [MKStoreManager sharedManager];
    [mkstore buyFeature:identifier onComplete:^(NSString* purchasedFeature, NSData*purchasedReceipt, NSArray* availableDownloads){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Purchase was successfully completed. Enjoy!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        //refresh collection view
        [self updateItems];
        
        
    }
            onCancelled:^{
                
                
            }];
}



@end
