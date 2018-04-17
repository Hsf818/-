//
//  FGTopicCell.h
//  百思不得姐
//
//  Created by hsf on 2018/3/20.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FGTopics;
@class FGTopicVideoView;
@interface FGTopicCell : UITableViewCell

@property (nonatomic, strong) UIButton                      *playBtn;
/** 播放按钮block */
@property (nonatomic, copy) void(^playBlock)(UIButton *);
@property (nonatomic, weak) FGTopicVideoView *videoView;

@property (nonatomic, strong) FGTopics *topics;
@end
