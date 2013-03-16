//
//  PFAlbumDetailsViewController.m
//  Frames Sharing
//
//  Created by sadmin on 3/14/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFAlbumDetailsViewController.h"
#import "PFExploreCell.h"
#import "Manager.h"
#import "Photo.h"
#import "PhotoFile.h"
#import "PFDisplayMyPhotoViewController.h"

@interface PFAlbumDetailsViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PFAlbumDetailsViewController
Manager * manager;
NSMutableArray * photoArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    manager = [Manager sharedInstance];
    manager.delegate = self;
    
    [manager getPhotosForAlbum:self.albumGuid];
}

-(void)receivedPhotos:(NSArray *)photos{
    photoArray =[NSMutableArray arrayWithArray:photos];
    //start downloading photos...
    //since we have one section it shouldn't be that hard...
    
    
    for(int i = 0; i<photos.count; i++){
        NSString * guid =  [(Photo *)[photoArray objectAtIndex:i]uniqueId];

        NSIndexPath *ip = [NSIndexPath indexPathForItem:i inSection:0];
        
        [manager downloadPhotoWithId:guid forUser:[manager getGUID:manager.user] andIndex:ip];
    }
    
    [self.collectionView reloadData];
}

-(void)downloadedPhotoFile:(PhotoFile *)file forIndex:(NSIndexPath *)indexPath{
    PFExploreCell * cell =(PFExploreCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    UIImage * thumbnail = [UIImage imageWithData:file.thumbnailImageData];
   // NSLog(@"img  %@  thumbnail %@ ",file.imageData, file.thumbnailImageData);
    cell.imageView.image = thumbnail;
    Photo * pf = [photoArray objectAtIndex:indexPath.row];
    pf.photoFile = file;
    [photoArray replaceObjectAtIndex:indexPath.row withObject:pf];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    //TODO deselect item
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    PFDisplayMyPhotoViewController * pdp = [self.storyboard instantiateViewControllerWithIdentifier:@"PFDisplayMyPhotoViewController"];
    Photo * p = [photoArray objectAtIndex:indexPath.row];
   /*
    pdp.descriptionText = p.description;
    pdp.imageData = [UIImage imageWithData:p.photoFile.imageData];
    pdp.starsCount.text =[NSString stringWithFormat:@"%d",p.ratings.count];
 
*/
    [self.navigationController pushViewController:pdp animated:YES];
    [pdp changeDescription:p.description];
    [pdp changeImage:pdp.imageData = [UIImage imageWithData:p.photoFile.imageData]];
    [pdp changeRatings:p.ratings.count];
}
#pragma mark – UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize retVal = CGSizeMake(75, 75);
    // retVal.height += 35;
    // retVal.width += 35;
    return  retVal;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return photoArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PFExploreCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ExploreCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    Photo * photo = [photoArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithData:photo.photoFile.thumbnailImageData];

    return cell;
}



@end
