//
//  StoreItemsViewController.m
//  GiftMaker
//
//  Created by Janusz Chudzynski on 11/28/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import "StoreItemsViewController.h"
#import "StoreItemDetailViewController.h"
#import "FrameCell.h"
#import "SharedStore.h"


#define kCellID @"storeFrameCellId"
@interface StoreItemsViewController ()

@end

@implementation StoreItemsViewController
@synthesize images;
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)buyItems:(id)sender {
    SharedStore *s=   [SharedStore sharedStore];
    [s buyItemsForId:self.key];
  

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
   
    return 1;//
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {

    return [images.thumbnails count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FrameCell * cell =   [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    if(!cell){
      
    
    }
    
        cell.photoFrame.image = [self.images.thumbnails objectAtIndex:indexPath.row];
      
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    StoreItemDetailViewController * storeItemsController =[self.storyboard instantiateViewControllerWithIdentifier:@"StoreItemPreviewId"];//
    storeItemsController.image = [self.images.images objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:storeItemsController animated:YES];
}




@end
