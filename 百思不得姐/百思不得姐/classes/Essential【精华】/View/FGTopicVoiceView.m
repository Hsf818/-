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

@interface FGTopicVoiceView()
@property (weak, nonatomic) IBOutlet UILabel *voiceTime;
@property (weak, nonatomic) IBOutlet UILabel *voiceTimes;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImage;

@end

@implementation FGTopicVoiceView

+(instancetype)voiceView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
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
