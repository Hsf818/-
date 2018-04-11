//
//  FGRecommendModel.h
//  百思不得姐
//
//  Created by hsf on 2018/3/18.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGRecommendModel : NSObject
/** 图片*/
@property (nonatomic, copy) NSString *image_list;
/** 名字*/
@property (nonatomic, copy) NSString *theme_name;
/** 子标题*/
@property (nonatomic, copy) NSString *sub_number;
@end
