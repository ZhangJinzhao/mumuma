//
//  LyricManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 蓝欧科技. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"

@interface LyricManager()
//用来存放歌词
@property (nonatomic, strong)NSMutableArray * lyrics;

@end

static LyricManager *manager = nil;
@implementation LyricManager

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LyricManager new];
    });
    return manager;
}
/**
 *
 *
 *  @param lyricStr  
 [00:18.030]大部分人要我学习去看 世俗的眼光 
 [00:26.440]我认真学习了世俗眼光 世俗到天亮 
 [00:34.260]一部外国电影没听懂一句话 
 [00:38.330]看完结局才是笑话 
 [00:42.520]你看我多乖多聪明多么听话 多奸诈 
 [00:50.800]喝了几大碗米酒再离开是为了模仿 
 [00:59.160]一出门不小心吐的那幅是谁的书画 
 [01:07.620]你一天一口一个 亲爱的对方 
 [01:11.730]多么不流行的模样 
 [01:15.440] 
 [01:15.990]都应该练练书法再出门闯荡 
 [01:19.360]才会有人热情买账 
 [01:23.420]要是能重来 我要选李白 
 [01:27.210]几百年前做的好坏 没那么多人猜
 */
- (void)loadLyricWith:(NSString *)lyricStr{
    //1.分行
    NSMutableArray * lyricStringArray = [[lyricStr componentsSeparatedByString:@"\n"]mutableCopy];
    //最后一行是@""
    //所以需要将最后一行移除
    [lyricStringArray removeLastObject];
    
    //要先将之前歌曲的歌词移除
    [self.lyrics removeAllObjects];
    
    
    for (NSString *str in lyricStringArray) {
//        if([str isEqualToString:@""]){
//            continue;
//        }
        //2.分开时间和歌词
        //str = [01:27.210]几百年前做的好坏 没那么多人猜
       NSArray *timeAndLyric = [str componentsSeparatedByString:@"]"];
        
        //3.去掉时间左边的"["
        NSString *time = [timeAndLyric[0] substringFromIndex:1];
        //time = 01:27.210
        //4.截取时间获取分和秒
        NSArray *minuteAndSecond = [time componentsSeparatedByString:@":"];
        //分
        NSInteger minute = [minuteAndSecond[0] integerValue];
        //秒
        double second = [minuteAndSecond[1]doubleValue];
        //5.装成一个model
        LyricModel *model = [[LyricModel alloc]initWithTime:(minute * 60 + second) lyric:timeAndLyric[1]];
        //6.添加到数组中
        [self.lyrics addObject:model];
        
    }
}

- (NSInteger)indexWith:(NSTimeInterval)time{
    NSInteger index = 0;
    //遍历数组,找到还没有播放的那一句歌词
    for (int i=0;i<self.lyrics.count;i++){
        LyricModel *model = self.lyrics[i];
        if (model.time > time) {
            //注意如果是第0个元素,而且元素时间比要播放的时间大,i - 1 就会小于0,这样tableView就会crash
            index = (i - 1>0)?i - 1 : 0;
            //一定要break,要不就会一直循环下去.
            break;
        }
    }
    return index;
}

- (NSMutableArray *)lyrics{
    if(!_lyrics){
        _lyrics = [NSMutableArray new];
    }
    return _lyrics;
}

- (NSArray *)allLyric{
    return _lyrics;
}



@end
