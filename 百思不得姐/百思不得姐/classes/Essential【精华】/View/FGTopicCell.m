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
#import "FGTopicView.h"

@interface FGTopicCell()

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *text_label;

@property (nonatomic, weak) FGTopicView *pictureView;

@end
@implementation FGTopicCell

- (FGTopicView *)pictureView
{
    if(!_pictureView){
        FGTopicView *pictureV = [FGTopicView pictureView];
        [self.contentView addSubview:pictureV];
        _pictureView = pictureV;
    }
    return _pictureView;
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
    
    if (topics.type == FGTopicPicture){// 图片帖子
        self.pictureView.topics = topics;
        self.pictureView.frame = topics.pictureF;
    }else if (topics.type == FGTopicVideo){// 视频帖子
        
    }else if (topics.type == FGTopicVoice){// 声音帖子
        
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
