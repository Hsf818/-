//
//  FGTopicVoiceView.m
//  百思不得姐
//
//  Created by hsf on 2018/4/12.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGTopicVoiceView.h"
#import "UIImageView+WebCache.h"
#import "FGTopics.h"
#import "FGTopicPictureViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface FGTopicVoiceView()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *voiceTime;
@property (weak, nonatomic) IBOutlet UILabel *voiceTimes;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImage;

/** 音乐播放器 */
@property(nonatomic, strong) AVAudioPlayer *musicPlayer;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

/** 之前音乐名 */
@property (nonatomic, copy) NSString *oldVoice;
/** 当前音乐名 */
@property (nonatomic, copy) NSString *currentVoice;
@end

@implementation FGTopicVoiceView

- (AVAudioPlayer *)musicPlayer{
    
    if(_musicPlayer == nil){
        NSData *audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_topics.voiceuri]];
        
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSArray * arr = [_topics.voiceuri componentsSeparatedByString:@"/"];
        
        self.currentVoice = arr[arr.count - 1];
        NSLog(@"arr = %@",arr[arr.count - 1]);
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", docDirPath,arr[arr.count - 1]];
        
        [audioData writeToFile:filePath atomically:NO];
        
        
        NSError *error = nil;
        NSURL *url = [NSURL fileURLWithPath:filePath];
        _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        _musicPlayer.numberOfLoops = 0;
        
        _musicPlayer.delegate = self;
        
        if (error) {
            FGLog(@"初始化出错%@",error.localizedDescription);
            return nil;
        }
        
        //为了支持后台播放
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//        [audioSession setActive:YES error:nil];
        
        // 添加通知，拔出耳机后暂停播放
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return _musicPlayer;
}

- (IBAction)startVoice:(id)sender {
//    if(_oldVoice != _currentVoice){
//        [_musicPlayer stop];
//        _musicPlayer = nil;
//    }
    if(![self.musicPlayer isPlaying]){
        [self.musicPlayer play];
        [self.voiceButton setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
    }else{
        [self.musicPlayer pause];
        [self.voiceButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
    }
    self.oldVoice = self.currentVoice;

}

+(instancetype)voiceView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    // 给图片添加监听器
    self.voiceImage.userInteractionEnabled = YES;
    [self.voiceImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}
- (void)showPicture
{
    FGTopicPictureViewController *showPicture = [[FGTopicPictureViewController alloc] init];
    showPicture.topics = self.topics;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}
- (void)setTopics:(FGTopics *)topics{
    _topics = topics;
    // 图片
    [self.voiceImage sd_setImageWithURL:[NSURL URLWithString:topics.large_image]];
    
    // 播放次数
    NSString *voices = nil;
    if (topics.playcount < 10000) {
        voices = [NSString stringWithFormat:@"%zd次播放",topics.playcount];
    }else if (topics.playcount > 10000){
        voices = [NSString stringWithFormat:@"%.1zd万次播放",(topics.playcount / 10000)];
    }
    self.voiceTime.text = voices;
    
    // 播放时长
    NSInteger minute = topics.voicetime / 60;
    NSInteger second = topics.voicetime % 60;
    self.voiceTimes.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
}

@end
