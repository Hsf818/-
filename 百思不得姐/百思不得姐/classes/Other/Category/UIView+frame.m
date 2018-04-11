//
//  UIView+frame.m
//  categorys
//
//  Created by hsf on 18/1/9.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "UIView+frame.h"

@implementation UIView (frame)

-(CGSize)size{
    return  self.frame.size;
}
- (void)setSize:(CGSize)size{
    
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;

}

-(CGFloat)centerY{
    return self.center.y;
}
-(void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

-(CGFloat)centerX{
    return self.center.x;
}
-(void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)height{
    return self.frame.size.height;
}
-(void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)width{
    return self.frame.size.width;
}
-(void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

-(CGFloat)x{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (CGFloat)y{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

@end
