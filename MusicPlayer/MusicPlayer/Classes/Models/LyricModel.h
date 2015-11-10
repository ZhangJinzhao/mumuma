//
//  LyricModel.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 蓝欧科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject

//歌词时间
@property (nonatomic, assign) NSTimeInterval time;
//歌词内容
@property (nonatomic, strong) NSString * lyricContext;

//方便起见,写一个构造方法
- (instancetype)initWithTime:(NSTimeInterval)time lyric:(NSString *)lyric;

@end
