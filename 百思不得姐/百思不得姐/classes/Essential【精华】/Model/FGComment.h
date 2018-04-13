//
//  FGComment.h
//  百思不得姐
//
//  Created by hsf on 2018/4/13.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FGUser;

@interface FGComment : NSObject
/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 评论的文字内容 */
@property (nonatomic, copy) NSString *content;
/** 被点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;
/** 用户 */
@property (nonatomic, strong) FGUser *user;
@end
