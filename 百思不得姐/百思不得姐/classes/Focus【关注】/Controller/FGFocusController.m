//
//  FGFocusController.m
//  百思不得姐
//
//  Created by hsf on 18/1/14.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGFocusController.h"
#import "FGRcommentController.h"
@interface FGFocusController ()

@end

@implementation FGFocusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏标题
    self.navigationItem.title = @"我的关注";
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick)];
    
    // 设置背景色
    self.view.backgroundColor = FGGolobBg;
}

- (void)friendsClick
{
    FGRcommentController *vc = [[FGRcommentController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
