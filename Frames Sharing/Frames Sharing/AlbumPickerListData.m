//
//  AlbumPickerListData.m
//  Frames Sharing
//
//  Created by sadmin on 4/3/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "AlbumPickerListData.h"
#import "Album.h"

@implementation AlbumPickerListData

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlbumCell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlbumCell"];

    }
    //cell.accessoryType= UITableViewCellAccessoryCheckmark;
    Album * album = (Album *)self.objects[indexPath.row];
  //  NSLog(@"album %@", [manager getGUID:album]);
    cell.textLabel.text =album.name;
    return cell;
}




@end
