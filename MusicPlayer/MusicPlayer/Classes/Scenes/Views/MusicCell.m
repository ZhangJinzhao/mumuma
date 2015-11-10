//
//  MusicCell.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 蓝欧科技. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell

- (void)setMusicModel:(MusicModel *)musicModel{
    _musicModel = musicModel;
    _lab4SingerName.text = musicModel.name;
    _lab4SongName.text = musicModel.singer;
    [_pic4Cell sd_setImageWithURL:[NSURL URLWithString:musicModel.picUrl]];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
