//
//  FGTopicPictureViewController.m
//  百思不得姐
//
//  Created by hsf on 2018/3/27.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGTopicPictureViewController.h"
#import "FGTopics.h"
#import "UIImageView+WebCache.h"
#import "FGProgressView.h"
#import "SVProgressHUD.h"

@interface FGTopicPictureViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *largeImage;
@property (weak, nonatomic) IBOutlet FGProgressView *progressView;

@end

@implementation FGTopicPictureViewController

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupImageView];
    
}
- (void)setupImageView{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.scrollView addSubview:imageView];
    self.largeImage = imageView;
    
    // 图片尺寸
    CGFloat pictureW = FGScreenW;
    CGFloat pictureH = pictureW * self.topics.height / self.topics.width;
    
    if (pictureH > FGScreenH){ // 如果图片尺寸超过屏幕高度，需要滑动
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
        self.scrollView.contentInset = UIEdgeInsetsMake(-40, 0, -40, 0);
    }else{// 展示图片
        imageView.size = CGSizeMake(pictureW, pictureH);
        imageView.centerY = FGScreenH * 0.5;
    }
    
    // 马上显示进度条
    [self.progressView setProgress:self.topics.progress animated:YES];
    
    // 下载图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topics.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        [self.progressView setProgress:1.0 * receivedSize / expectedSize animated:YES];
        self.progressView.hidden = NO;
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        self.progressView.hidden = YES;
    }];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save {
    
    if(self.largeImage.image == nil){
        [SVProgressHUD setStatus:@"图片没有下载完成"];
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(self.largeImage.image, self, @selector(image: didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if(error){
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
