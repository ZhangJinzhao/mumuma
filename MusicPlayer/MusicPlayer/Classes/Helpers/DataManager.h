//
//  DataManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 蓝欧科技. All rights reserved.
//
//数据管理
#import <Foundation/Foundation.h>

typedef void (^UpdataUI)();

@interface DataManager : NSObject

@property (nonatomic, copy) UpdataUI myUpdataUI;
@property (nonatomic, strong) NSArray * allMusic;
/**
 *  
   单例方法
   @return 单例
 
 
 */
+ (DataManager *)sharedManager;
- (MusicModel *)musicModelWithIndex:(NSInteger)index;
@end
