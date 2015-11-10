//
//  PlayingViewController.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 蓝欧科技. All rights reserved.
//

#import "PlayingViewController.h"
#import "LyricModel.h"
//#import "PlayerManager.h"
//#import "DataManager.h"
@interface PlayingViewController ()<PlayerManagerDelegate>
//记录一下当前播放的音乐的索引
@property (nonatomic, assign)NSInteger currentIndex;
//记录当前正在播放的音乐
@property (nonatomic, retain)MusicModel *currentModel;

#pragma mark - 控件
@property (strong, nonatomic) IBOutlet UILabel *lab4SongName;

@property (strong, nonatomic) IBOutlet UILabel *lab4SingerName;

@property (strong, nonatomic) IBOutlet UIImageView *img4Pic;

@property (strong, nonatomic) IBOutlet UILabel *lab4PlayedTime;

@property (strong, nonatomic) IBOutlet UILabel *lab4LastTime;

@property (strong, nonatomic) IBOutlet UISlider *slider4Time;

@property (strong, nonatomic) IBOutlet UISlider *slider4Volume;

@property (strong, nonatomic) IBOutlet UIButton *btn4PlayOrPause;

@property (strong, nonatomic) IBOutlet UITableView *tableView4Lyric;

@property (strong, nonatomic) IBOutlet UIImageView *maoboli;

#pragma mark - 控件事件
- (IBAction)action4Prev:(UIButton *)sender;

- (IBAction)action4PlayOrPause:(UIButton *)sender;

- (IBAction)action4Next:(UIButton *)sender;

- (IBAction)action4ChangeTime:(UISlider *)sender;

- (IBAction)action4ChangeVolume:(UISlider *)sender;


@end
static PlayingViewController *playingVC = nil;
static NSString * cellIdentifier = @"cell";
@implementation PlayingViewController

+ (instancetype)sharedPlayingPVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //在mian里面取到sb
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        //在main sb拿到我们要用的视图控制器
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
        
    });
    return playingVC;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //如果要播放的音乐和当前播放的音乐一样,就什么都不干
    if(_index == _currentIndex){
        return;
    }
    //如果不等于,替换成要播放的音乐
    _currentIndex = _index;
    
    [self startPlay];
}


- (void)startPlay{
    
    //取到要播放的model
//    MusicModel *model = [[DataManager sharedManager]musicModelWithIndex:self.currentIndex];
//    [[PlayerManager sharedManager]playWithUrlString:model.mp3Url];
    //特别注意 此时这里不能够用 _currentModel.mp3Url,这样写不走get方法,一定要用.
    [[PlayerManager sharedManager]playWithUrlString:self.currentModel.mp3Url];
    [self buildUI];
    
}

//搭界面
- (void)buildUI{
    
                               //这里一定要写self.currentModel
                               //否则不走getter方法
    self.lab4SingerName.text = self.currentModel.singer;
    self.lab4SingerName.textColor = [UIColor whiteColor];
    self.lab4SongName.text = self.currentModel.name;
    self.lab4SongName.textColor = [UIColor whiteColor];
    
    [self.img4Pic sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];
    
    //更改button
    //[self.btn4PlayOrPause setTitle:@"暂停" forState:UIControlStateNormal];
    [self.btn4PlayOrPause setBackgroundImage:[UIImage imageNamed:@"pause@2x"] forState:UIControlStateNormal];
    //改变进度条的最大值
    self.slider4Time.maximumValue = [self.currentModel.duration integerValue]/1000;
    
    self.slider4Time.value = 0;
    
    //更改旋转的角度,图片归位
    self.img4Pic.transform = CGAffineTransformMakeRotation(0);
    
    //设置毛玻璃
    [self.maoboli sd_setImageWithURL:[NSURL URLWithString:self.currentModel.blurPicUrl]];
    
    //解析歌词
    [[LyricManager sharedManager]loadLyricWith:self.currentModel.lyric];
    [self.tableView4Lyric reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentIndex = -1;
    
    //    //设置圆角
    //    _img4Pic.layer.masksToBounds = YES;
    //    _img4Pic.layer.cornerRadius = 120;
    
    //设置自已为播放器的代理,帮播放器干一些事情
    [PlayerManager sharedManager].delegate = self;
    
    //注册
    [self.tableView4Lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    self.tableView4Lyric.backgroundColor = [UIColor clearColor];
    
    //self.tableView4Lyric.alpha = 0;
    
    //设置开始的音量进度条
    self.slider4Volume.value = [[PlayerManager sharedManager]volume];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)action4Back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//上一首
- (IBAction)action4Prev:(UIButton *)sender {
    _currentIndex--;
    //判断是不是第一首
    if(_currentIndex == -1){
      //如果是第一首就播放最后一首
        _currentIndex = [DataManager sharedManager].allMusic.count-1;
    }
    [self startPlay];
        
}

//播放or暂停
- (IBAction)action4PlayOrPause:(UIButton *)sender {
    //判断是否正在播放
    if ([PlayerManager sharedManager].isPlaying){
        //如果正在播放,就让播放器暂停,同时改变button的text
        [[PlayerManager sharedManager]pause];
        //[sender setTitle:@"播放" forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"play@2x"] forState:UIControlStateNormal];
    }else{
        //暂停状态关闭:开始播放,并改变btn为暂停
        [[PlayerManager sharedManager]play];
        //[sender setTitle:@"暂停" forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"pause@2x"] forState:UIControlStateNormal];
    }
    //TODO:这里有个bug,在暂停之后,点击下一首,下一个歌曲就不播放了
}

//下一首
- (IBAction)action4Next:(UIButton *)sender {
    _currentIndex++;
    //判断是不是最后一首
    if(_currentIndex == [DataManager sharedManager].allMusic.count){
        //如果是最后一首就播放第一首
        _currentIndex = 0;
    }
    [self startPlay];
}

//改变播放进度
- (IBAction)action4ChangeTime:(UISlider *)sender {
    UISlider *slider = sender;
    //调用接口
    [[PlayerManager sharedManager]seekToTime:slider.value];
}

//改变音量
- (IBAction)action4ChangeVolume:(UISlider *)sender {
    [[PlayerManager sharedManager]changeToVolume:sender.value];
}

#pragma mark - PlayerManagerDelegate
//播放器播放结束了,开始播放下一首
- (void)playerDidPlayEnd{
    [self action4Next:nil];
}

//播放器每0.1秒会让代理(也就是这个页面)执行一下这个事件
- (void)playerPlayingWithTime:(NSTimeInterval)time{
//    NSLog(@"%f",time);
    self.slider4Time.value = time;
    self.lab4PlayedTime.text = [self stringWithTime:time];
    //歌曲总时间
    NSTimeInterval allTime = [self.currentModel.duration integerValue] / 1000;
    //剩余时间
    NSTimeInterval time2 = allTime - time;
    self.lab4LastTime.text =  [self stringWithTime:time2];
    
     //每0.1秒旋转一度
    self.img4Pic.transform = CGAffineTransformRotate(self.img4Pic.transform,M_PI/180);
    //根据 当前播放时间获取到应该播放哪句歌词
    NSInteger index = [[LyricManager sharedManager]indexWith:time];
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    //让tableView选中我们找到的歌词
    [self.tableView4Lyric selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    
}
#pragma mark - 私有方法
//根据时间获取到字符串
- (NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger minutes = time / 60;
    NSInteger seconds = (int)time % 60;
    return [NSString stringWithFormat:@"%ld:%ld",minutes,seconds];
}

#pragma mark - getter
//确保当前播放的音乐是最新的
- (MusicModel *)currentModel{
    //取到要播放的model
    MusicModel *model = [[DataManager sharedManager]musicModelWithIndex:self.currentIndex];
    return model;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [LyricManager sharedManager].allLyric.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    //设置歌词
    LyricModel *lyric = [LyricManager sharedManager].allLyric[indexPath.row];
    //设置歌词
    cell.textLabel.text = lyric.lyricContext;
    //更改歌词颜色
    cell.textLabel.textColor = [UIColor whiteColor];
    
    //cell.backgroundColor = [UIColor colorWithRed:0.000 green:0.008 blue:1.000 alpha:1.000];
    cell.backgroundColor = [UIColor clearColor];
    //
    cell.contentView.backgroundColor = [UIColor clearColor];
    //设置你想要的cell背景颜色，alpha是透明度参数
    //设置居中
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //设置选中cell的时候,没有暗黑色的显示(歌词黑条条)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




@end
