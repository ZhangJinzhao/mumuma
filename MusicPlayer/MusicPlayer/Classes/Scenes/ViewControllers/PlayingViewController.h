//
//  PlayingViewController.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 蓝欧科技. All rights reserved.
//
//播放页面管理
#import <UIKit/UIKit.h>

@interface PlayingViewController : UIViewController

+ (instancetype)sharedPlayingPVC;

//要播放第几首
@property (nonatomic,assign)NSInteger index;


@end
