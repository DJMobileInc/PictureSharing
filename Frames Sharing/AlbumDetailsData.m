//
//  AlbumDetailsData.m
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/25/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "AlbumDetailsData.h"
#import "Photo.h"
#import "PFExploreCell.h"
#import "Manager.h"
#import "PFDisplayMyPhotoViewController.h"


@implementation AlbumDetailsData

-(void)updateCell:(PFExploreCell *)cell withObject:(id)object andIndexPath:(NSIndexPath*)indexPath{
    
    if([[(Photo *)object thumbnailImageData]length]>0 && [[(Photo *)object imageData]length]>0){
    
        cell.imageView.image = [UIImage imageWithData:[(Photo *)object  thumbnailImageData]];
        
    }
    else{
        [MBProgressHUD showHUDAddedTo:cell animated:YES];
        [self.manager.ff loadBlobsForObj:(Photo *)object onComplete:^
         (NSError *theErr, id theObj, NSHTTPURLResponse *theResponse){
             [MBProgressHUD hideHUDForView:cell animated:YES];
             
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             if(theErr)
             {
                 NSLog(@" Error for blob  %@ ",[theErr debugDescription]);
             }
             
             Photo * photo = theObj;
             if(self.photoArray && photo != nil){
                 if(indexPath.row<self.photoArray.count){
                     
                     [self.photoArray replaceObjectAtIndex:indexPath.row withObject:photo];
                     
                     cell.imageView.image = [UIImage imageWithData:photo.thumbnailImageData];
                     
                 }
             }
         }];
    }

}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    //TODO deselect item
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
   // [self.manager getOwnerOfPhoto:<#(Photo *)#> asynchronusly:<#(BOOL)#>]
    
    
    
    PFDisplayMyPhotoViewController * pdp = [self.storyboard instantiateViewControllerWithIdentifier:@"PFDisplayMyPhotoViewController"];
    Photo * p = [self.photoArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:pdp animated:YES];
    [pdp changeDescription:p.description];
    if(!p.imageData)
    {
        NSLog(@"No image data!!! ");
    }
        [pdp changeImage:[UIImage imageWithData:p.imageData]];
     pdp.photo = p;
    [pdp changeRatings:p.ratings.count];
     
    
}
#pragma mark – UICollectionViewDelegateFlowLayout

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGSize retVal = CGSizeMake(95, 95);
//    // retVal.height += 35;
//    // retVal.width += 35;
//    return  retVal;
//}
//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(1, 1, 1, 1);
//}
#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PFExploreCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ExploreCell" forIndexPath:indexPath];
   // cell.backgroundColor = [UIColor greenColor];
    cell.backgroundColor = [UIColor blackColor];
    Photo * photo = [self.photoArray objectAtIndex:indexPath.row];
    //cell.imageView.image =photo.thumbnailImageData;
    [self updateCell:cell withObject:photo andIndexPath:indexPath];
    
    
    return cell;
}

@end
