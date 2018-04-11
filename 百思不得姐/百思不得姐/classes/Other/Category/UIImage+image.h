//
//  UIImage+image.h
//  categorys
//
//  Created by hsf on 18/1/9.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (image)
// 快速的返回一个最原始的图片
+ (instancetype)imageWithOriRenderingImage:(NSString *)imageName;

// 快速拉伸图片
+ (instancetype)imageStretchableImageName:(NSString *)imageName;
@end
