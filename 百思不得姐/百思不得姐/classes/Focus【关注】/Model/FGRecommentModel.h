//
//  FGRecommentModel.h
//  百思不得姐
//
//  Created by hsf on 18/1/19.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGRecommentModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger id;


@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger currentPage;



@property (nonatomic, strong) NSMutableArray *rights;
@end
