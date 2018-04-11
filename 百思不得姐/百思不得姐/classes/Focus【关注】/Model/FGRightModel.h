//
//  FGRightModel.h
//  百思不得姐
//
//  Created by hsf on 18/1/19.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGRightModel : NSObject

@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *fans_count;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy)NSString *introduction;
@property (nonatomic, assign) NSInteger is_follow;
@property (nonatomic, assign) NSInteger is_vip;
@property (nonatomic, assign) NSInteger tiezi_count;
@property (nonatomic, copy) NSString *screen_name;

@property (nonatomic, copy) NSString *uid;
@end
