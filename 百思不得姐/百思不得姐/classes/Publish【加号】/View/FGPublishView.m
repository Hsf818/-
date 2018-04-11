//
//  FGPublishView.m
//  百思不得姐
//
//  Created by hsf on 2018/4/4.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGPublishView.h"
#import "FGVerticalButton.h"
#import "POP.h"

@implementation FGPublishView

+ (instancetype)show{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.userInteractionEnabled = NO;
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartX = 35;
    CGFloat buttonBeginY = (FGScreenH - 2 * buttonH) * 0.5 - FGMargin;
    CGFloat margin = (FGScreenW - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    CGFloat buttonStartY = buttonBeginY - FGScreenH;
    // 添加按钮
    for (int i = 0; i < images.count; i++) {
        FGVerticalButton *btn = [[FGVerticalButton alloc]init];
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        // 设置内容
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 设置frame
        int row = i / maxCols;
        int col = i % maxCols;
        
        CGFloat buttonEndX = buttonStartX + col * (margin + buttonW);
        CGFloat buttonEndY = buttonBeginY + row * buttonH + FGMargin;
        
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonStartX, buttonStartY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonEndX, buttonEndY, buttonW, buttonH)];
        anim.springSpeed = 10;
        anim.springBounciness = 10;
        anim.beginTime = CACurrentMediaTime() + 0.1 * i;
        
        [btn pop_addAnimation:anim forKey:nil];
        
    }
    
    // 添加slogan
    UIImageView *sloganView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self addSubview:sloganView];
//    self.sloganImageView = sloganView;
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    
    CGFloat centerStartY = FGScreenH * 0.2 - FGScreenH;
    CGFloat centerEndY = FGScreenH * 0.2;
    CGFloat centerX = FGScreenW * 0.5;
    
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerStartY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.springBounciness = 10;
    anim.springSpeed = 10;
    anim.beginTime = CACurrentMediaTime() + 0.1 * images.count;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
}

- (void)btnClick:(UIButton *)button{
    if(button.tag == 0){// 发视频
        [self cancelCompletion:^{
            FGLog(@"%s",__func__);
        }];
    }else if (button.tag == 1){ // 发图片
        [self cancelCompletion:^{
            FGLog(@"%s",__func__);
        }];
    }
}

- (IBAction)cancel {
    [self cancelCompletion:nil];
}

- (void)cancelCompletion:(void (^)())completion{
    self.userInteractionEnabled = NO;
    
    for (int i = 1; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerEndY = view.y + FGScreenH;
        anim.beginTime = CACurrentMediaTime() + 0.1 * (i - 2);
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(view.centerX, centerEndY)];
        
        if(i == (self.subviews.count - 1)){ // 如果是最后一个
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                [self removeFromSuperview];
                if (completion){
                    completion();
                }
            }];
        }
        
        [view pop_addAnimation:anim forKey:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelCompletion:nil];
}
@end
