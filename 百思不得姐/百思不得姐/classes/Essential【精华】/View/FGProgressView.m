//
//  FGProgressView.m
//  百思不得姐
//
//  Created by hsf on 2018/3/26.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGProgressView.h"

@implementation FGProgressView
- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    
    [super setProgress:progress animated:animated];
    
    NSString *text = [NSString stringWithFormat:@"%0.f%%",progress * 100];
    self.progressLabel.text = text;
    
}


@end
