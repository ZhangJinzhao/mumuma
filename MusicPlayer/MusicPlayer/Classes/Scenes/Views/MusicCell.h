//
//  MusicCell.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 蓝欧科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *pic4Cell;
@property (strong, nonatomic) IBOutlet UILabel *lab4SongName;
@property (strong, nonatomic) IBOutlet UILabel *lab4SingerName;

@property (nonatomic, retain) MusicModel * musicModel;

@end
