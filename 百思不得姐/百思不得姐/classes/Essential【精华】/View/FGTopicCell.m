//
//  FGTopicCell.m
//  百思不得姐
//
//  Created by hsf on 2018/3/20.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGTopicCell.h"
#import "UIImageView+WebCache.h"
#import "FGTopics.h"
#import "FGTopicPictureView.h"
#import "FGTopicVoiceView.h"
#import "FGTopicVideoView.h"
#import "FGComment.h"
#import "FGUser.h"

@interface FGTopicCell()

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *text_label;

@property (nonatomic, weak) FGTopicPictureView *pictureView;
@property (nonatomic, weak) FGTopicVoiceView *voiceView;
@property (nonatomic, weak) FGTopicVideoView *videoView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end
@implementation FGTopicCell
- (FGTopicVideoView *)videoView
{
    if(!_videoView){
        FGTopicVideoView *videoView = [FGTopicVideoView videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (FGTopicPictureView *)pictureView
{
    if(!_pictureView){
        FGTopicPictureView *pictureV = [FGTopicPictureView pictureView];
        [self.contentView addSubview:pictureV];
        _pictureView = pictureV;
    }
    return _pictureView;
}

- (FGTopicVoiceView *)voiceView
{
    if(!_voiceView){
        FGTopicVoiceView *voiceV = [FGTopicVoiceView voiceView];
        [self.contentView addSubview:voiceV];
        _voiceView = voiceV;
    }
    return _voiceView;
}

- (void)setTopics:(FGTopics *)topics{
    _topics = topics;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:topics.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    
    self.nameLabel.text = topics.name;
    self.timeLable.text = topics.create_time;
    
    // 设置按钮文字
    [self setButtonTitle:self.dingButton count:topics.ding placeholder:@"顶"];
    [self setButtonTitle:self.caiButton count:topics.cai placeholder:@"踩"];
    [self setButtonTitle:self.commentButton count:topics.comment placeholder:@"评论"];
    [self setButtonTitle:self.shareButton count:topics.repost placeholder:@"分享"];
    
    // 文字最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * FGMargin, MAXFLOAT);
    
    // 文字的最大高度
    CGFloat textH = [topics.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    if (topics.type == FGTopicPicture){// 图片帖子
        self.pictureView.hidden = NO;
        self.pictureView.topics = topics;
        if(topics.pictureF.origin.x == 0){
            // 图片显示出来的宽度
            CGFloat pictureW = maxSize.width;
            // 图片显示出来的高度
            CGFloat pictureH = pictureW * self.height / self.width;
            
            if (pictureH >= FGTopicPictureMaxH){// 大图
                pictureH = FGTopicPictureH;
                topics.bigPicture = YES;
            }
            
            // 计算图片的frame
            CGFloat pictureX = FGMargin;
            CGFloat pictureY = FGTextY + textH + FGMargin;
            
            self.pictureView.frame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
        }else{
            self.pictureView.frame = topics.pictureF;
        }
        
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }else if (topics.type == FGTopicVoice){// 声音帖子
        self.voiceView.hidden = NO;
        self.voiceView.topics = topics;
        if(topics.voiceF.origin.x == 0){
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = voiceW * topics.height / topics.width;
            CGFloat voiceX = FGMargin;
            CGFloat voiceY = FGTextY + textH + FGMargin;
            self.voiceView.frame = CGRectMake(voiceX, voiceY, voiceW, voiceH);
        }else{
            self.voiceView.frame = topics.voiceF;
        }
        
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
    }else if (topics.type == FGTopicVideo){// 视频帖子
        self.videoView.hidden = NO;
        self.videoView.topics = topics;
        if(topics.videoF.origin.x == 0){
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW * topics.height / topics.width;
            CGFloat videoX = FGMargin;
            CGFloat videoY = FGTextY + textH + FGMargin;
            
            self.videoView.frame = CGRectMake(videoX, videoY, videoW, videoH);
        }else{
            self.videoView.frame = topics.videoF;
        }
        
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
    }else{ // 段子
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    FGComment *cmt = [topics.top_cmt firstObject];
    
    if(cmt){
        self.commentLabel.text = [NSString stringWithFormat:@"%@ : %@",cmt.user.username,cmt.content];
    }else{
        self.commentView.hidden = YES;
    }
    // 设置文字
    self.text_label.text = topics.text;
}

- (void)setButtonTitle:(UIButton *)btn count:(NSInteger)count placeholder:(NSString *)placeholder{
    if(count > 1000){
        placeholder = [NSString stringWithFormat:@"%.ld万人",count / 10000];
    }else{
        placeholder = [NSString stringWithFormat:@"%ld人",count];
    }
    [btn setTitle:placeholder forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = imageView;
    
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = FGMargin;
    frame.size.width -= 2 * FGMargin;
    frame.size.height -= FGMargin;
    frame.origin.y += FGMargin;
    
    [super setFrame:frame];
}

@end
