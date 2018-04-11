//
//  FGTabBar.m
//  百思不得姐
//
//  Created by hsf on 18/1/14.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGTabBar.h"
#import "FGPublishViewController.h"
#import "FGPublishView.h"

@interface FGTabBar()
@property (nonatomic, weak) UIButton *publishButton;
@end

@implementation FGTabBar
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 设置tabbar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        
        // 添加发布按钮
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        publishButton.size = publishButton.currentBackgroundImage.size;
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}

- (void)publishClick{
    
    FGPublishViewController *vc = [[FGPublishViewController alloc]init];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
    
//    FGPublishView *publish = [FGPublishView show];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.frame = publish.bounds;
//    [window addSubview:publish];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = 15;
    CGFloat width = self.frame.size.width / 5;
    CGFloat height = self.frame.size.height - 2 * y;
    int count = 0;
    
    self.publishButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    for (UIView *button in self.subviews) {
        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton) continue;
        
        x = width * ((count > 1) ?(count + 1): count);
        button.frame = CGRectMake(x, y, width, height);
        count ++;
        
    }
    
}
@end
