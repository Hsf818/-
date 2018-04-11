//
//  UIBarButtonItem+FGBarButtonItem.h
//  百思不得姐
//
//  Created by hsf on 18/1/14.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (FGBarButtonItem)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
