//
//  FGTopicVideoView.m
//  百思不得姐
//
//  Created by hsf on 2018/4/12.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGTopicVideoView.h"
#import "UIImageView+WebCache.h"
#import "FGTopics.h"
#import "FGTopicPictureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

@interface FGTopicVideoView()
@property (weak, nonatomic) IBOutlet UILabel *videoPlays;
@property (weak, nonatomic) IBOutlet UILabel *videoTime;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;

@end

@implementation FGTopicVideoView

+(instancetype)videoView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (IBAction)startVideo:(id)sender {
   
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    // 给图片添加监听器
    self.videoImage.userInteractionEnabled = YES;
    [self.videoImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
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
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:topics.large_image]];
    
    // 播放次数
    NSString *videos = nil;
    if (topics.playcount < 10000) {
        videos = [NSString stringWithFormat:@"%zd次播放",topics.playcount];
    }else if (topics.playcount > 10000){
        videos = [NSString stringWithFormat:@"%.1zd万次播放",(topics.playcount / 10000)];
    }
    self.videoPlays.text = videos;
    
    // 播放时长
    NSInteger minute = topics.videotime / 60;
    NSInteger second = topics.videotime % 60;
    self.videoTime.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
}


@end
