//
//  UIView+frame.h
//  categorys
//
//  Created by hsf on 18/1/9.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frame)

// 分类里面不能生成成员属性
// 会自动生成get，set方法和成员属性

// @property如果在分类里面只会生成get,set方法的声明，并不会生成成员属性。
@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CGFloat width;

@property (nonatomic, assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;

@property (nonatomic, assign)CGSize size;
@end
