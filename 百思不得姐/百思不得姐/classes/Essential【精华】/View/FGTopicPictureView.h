//
//  FGTopicView.h
//  百思不得姐
//
//  Created by hsf on 2018/3/25.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FGTopics;

@interface FGTopicPictureView : UIView

+ (instancetype)pictureView;

@property (nonatomic, strong) FGTopics *topics;
@end
