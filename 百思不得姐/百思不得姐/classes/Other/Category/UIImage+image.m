//
//  UIImage+image.m
//  categorys
//
//  Created by hsf on 18/1/9.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "UIImage+image.h"

@implementation UIImage (image)
// 快速的返回一个最原始的图片
+ (instancetype)imageWithOriRenderingImage:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (instancetype)imageStretchableImageName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}
@end
