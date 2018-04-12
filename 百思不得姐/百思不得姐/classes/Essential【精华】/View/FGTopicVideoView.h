//
//  FGTopicVideoView.h
//  百思不得姐
//
//  Created by hsf on 2018/4/12.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FGTopics;
@interface FGTopicVideoView : UIView

+(instancetype)videoView;

@property (nonatomic, strong) FGTopics *topics;
@end
