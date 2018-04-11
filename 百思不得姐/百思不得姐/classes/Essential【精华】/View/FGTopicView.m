//
//  FGTopicView.m
//  百思不得姐
//
//  Created by hsf on 2018/3/25.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGTopicView.h"
#import "UIImageView+WebCache.h"
#import "FGTopics.h"
#import "FGProgressView.h"
#import "FGTopicPictureViewController.h"

@interface FGTopicView()

@property (weak, nonatomic) IBOutlet UIImageView *gif_Image;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (weak, nonatomic) IBOutlet FGProgressView *progressView;

@end

@implementation FGTopicView

+(instancetype)pictureView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    
    self.autoresizingMask = UIViewAutoresizingNone;
    self.pictureImageView.userInteractionEnabled = YES;
    
    [self.pictureImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPicture)]];
    [super awakeFromNib];
}

- (void)showPicture{
    
    FGTopicPictureViewController *vc = [[FGTopicPictureViewController alloc]init];
    vc.topics = self.topics;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)setTopics:(FGTopics *)topics{
    _topics = topics;
    
    // 立马显示最新的进度值(防止因为网速慢, 导致显示的是其他图片的下载进度)
    [self.progressView setProgress:topics.progress];
    
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:topics.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
//        [self.progressView setHidden:NO];
        
        topics.progress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:topics.progress];
        
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_sync(queue, ^{
            self.progressView.hidden = NO;
        });
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [self.progressView setHidden:YES];
        if(topics.isBigPicture == NO) return ;
        
        // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(topics.pictureF.size, YES, 0);
        
        CGFloat width = topics.pictureF.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        self.pictureImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭图形上下文
        UIGraphicsEndImageContext();
    }];
    
    // 判断是否为gif
    NSString *extension = topics.large_image.pathExtension;
    _gif_Image.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
    // 判断是否需要查看大图
    if (topics.isBigPicture){
        self.checkButton.hidden = NO;
//        self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    }else{
        self.checkButton.hidden = YES;
//        self.pictureImageView.contentMode = UIViewContentModeScaleToFill;
    }
}
@end
