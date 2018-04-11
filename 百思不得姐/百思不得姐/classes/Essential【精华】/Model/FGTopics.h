//
//  FGTopics.h
//  百思不得姐
//
//  Created by hsf on 2018/3/20.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGTopics : NSObject
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 发帖时间 */
@property (nonatomic, copy) NSString *create_time;
/** 文字内容 */
@property (nonatomic, copy) NSString *text;
/** 顶的数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩的数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发的数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论的数量 */
@property (nonatomic, assign) NSInteger comment;
/** 小图片 */
@property (nonatomic, copy) NSString *small_image;
/** 大图片 */
@property (nonatomic, copy) NSString *large_image;
/** 中图片 */
@property (nonatomic, copy) NSString *middle_image;

/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;

/** type **/
@property (nonatomic, assign) FGTopicType type;

/** cell高度 **/
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/**  picture尺寸 **/
@property (nonatomic, assign) CGRect pictureF;

/**  picture尺寸 **/
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;

/**  picture尺寸 **/
@property (nonatomic, assign) CGFloat progress;

@end
