//
//  FGRecommentModel.m
//  百思不得姐
//
//  Created by hsf on 18/1/19.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGRecommentModel.h"

@implementation FGRecommentModel
- (NSMutableArray *)rights
{
    if(!_rights){
        _rights = [NSMutableArray array];
    }
    return _rights;
}


@end
