//
//  PFExploreViewController.m
//  Frames Sharing
//
//  Created by Terry Lewis II on 3/4/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFExploreViewController.h"
#import "PFExploreCell.h"
#import "Photo.h"
#import "PFDisplayPhotoViewController.h"

@interface PFExploreViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation PFExploreViewController
Manager * manager;
NSMutableArray * photoArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    manager = [Manager sharedInstance];
    manager.exploreDelegate = self;
    [manager.ff setAutoLoadBlobs:NO];
        
    if(!photoArray){
        photoArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    else{
        [photoArray removeAllObjects];
    }

}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    //TODO deselect item
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFDisplayPhotoViewController * pdp = [self.storyboard instantiateViewControllerWithIdentifier:@"PFDisplayPhotoViewController"];
    Photo * p = [photoArray objectAtIndex:indexPath.row];
    pdp.photo = p;   
    [self.navigationController pushViewController:pdp animated:YES];
 
    [pdp changeDescription:p.description];
    [pdp changeImage:[UIImage imageWithData:p.imageData]];
    [pdp changeRatings:p.ratings.count];
    
}

#pragma mark – UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize retVal = CGSizeMake(75, 75);
    return  retVal;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
    return [photoArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PFExploreCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ExploreCell" forIndexPath:indexPath];
    Photo * photo =       [photoArray objectAtIndex:indexPath.row];
    [self updateCell:cell withObject:photo andIndexPath:indexPath];

    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [photoArray removeAllObjects];
    [self.collectionView reloadData];
    [manager getPhotosWithSearchQuery:searchBar.text];
}

-(void)searchCompletedWithResults:(NSArray *)array{
    //NSLog(@"Search completed with Array %@",array);
    photoArray = (NSMutableArray *) array;
    [self.searchBar resignFirstResponder];
    [self.collectionView reloadData];
}

-(void)updateCell:(PFExploreCell *)cell withObject:(id)object andIndexPath:(NSIndexPath*)indexPath{
    
    NSLog(@"Update Cell");
    
    [manager.ff loadBlobsForObj:object onComplete:^
     
     (NSError *theErr, id theObj, NSHTTPURLResponse *theResponse){
         Photo * photo = theObj;
         if(photoArray){
             [photoArray replaceObjectAtIndex:indexPath.row withObject:photo];
             
             cell.imageView.image = [UIImage imageWithData:photo.thumbnailImageData];
             
             NSLog(@"Cell Updated ");
             
         }
     }];
}






@end
