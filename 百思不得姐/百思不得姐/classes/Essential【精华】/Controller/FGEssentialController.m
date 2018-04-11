//
//  FGEssentialController.m
//  百思不得姐
//
//  Created by hsf on 18/1/14.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGEssentialController.h"
#import "FGRecommendTagsTableViewController.h"

#import "FGAllViewController.h"
#import "FGWordViewController.h"
#import "FGVideoViewController.h"
#import "FGVoiceViewController.h"
#import "FGPictureViewController.h"

@interface FGEssentialController ()<UIScrollViewDelegate>

/*指示器*/
@property (nonatomic, weak) UIView *indicatorView;
@property (nonatomic, weak) UIButton *selectButton;

@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation FGEssentialController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self setupNav];
    
    // 添加自控制器
    [self setupChildVCs];
    
    // 设置顶部标签栏
    [self setupTitlesView];
    
    // 设置cotentview
    [self setupContentView];
}

- (void)setupChildVCs{
    FGAllViewController *all = [[FGAllViewController alloc]init];
    [self addChildViewController:all];
    
    FGVideoViewController *video = [[FGVideoViewController alloc]init];
    
    [self addChildViewController:video];
    
    FGVoiceViewController *voice = [[FGVoiceViewController alloc]init];
    [self addChildViewController:voice];
    
    FGPictureViewController *picture = [[FGPictureViewController alloc]init];
    [self addChildViewController:picture];
    
    FGWordViewController *word = [[FGWordViewController alloc]init];
    [self addChildViewController:word];
    
}
/*
 * 设置ContentView
 */
- (void)setupContentView{
    // 不要设置自动设置inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 创建scrollview
    UIScrollView *scro = [[UIScrollView alloc]init];
    scro.frame = self.view.bounds;
    
    scro.delegate = self;
    scro.contentSize = CGSizeMake(self.childViewControllers.count * scro.width, 0);
    scro.pagingEnabled = YES;
    [self.view insertSubview:scro atIndex:0];
    self.contentView = scro;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:scro];
}

/**
 * 设置顶部标签栏
 */
- (void)setupTitlesView{
    UIView *titleView = [[UIView alloc]init];
    titleView.y = 64;
    titleView.width = self.view.width;
    titleView.height = 40;
    titleView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    UIView *view = [[UIView alloc]init];
    view.height = 2;
    view.tag = -1;
    view.backgroundColor = [UIColor redColor];
    view.y = titleView.height - view.height;
    [titleView addSubview:view];
    self.indicatorView = view;
    
    NSArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    CGFloat width = titleView.width / titles.count;
    CGFloat height = titleView.height;
    for(NSInteger i = 0;i < titles.count; i++){
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.tag = i;
        btn.width = width;
        btn.x = i * width;
        btn.height = height;
        
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [titleView addSubview:btn];
        // 默认选中第一个
        if(i == 0){
            btn.enabled = NO;
            self.selectButton = btn;
            
            [btn.titleLabel sizeToFit];
            self.indicatorView.width = btn.titleLabel.width;
            self.indicatorView.centerX = btn.centerX;
        }
    }
}

- (void)btnClick:(UIButton *)button{
    
    self.selectButton.enabled = YES;
    button.enabled = NO;
    self.selectButton = button;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
    
}

- (void)setupNav{
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
    // 设置背景色
    self.view.backgroundColor = FGGolobBg;
}

- (void)tagClick
{
    FGRecommendTagsTableViewController *tagVC = [[FGRecommendTagsTableViewController alloc]init];
    
    [self.navigationController pushViewController:tagVC animated:YES];
}

#pragma mark - UIScrolleviewDelegate
// scrollview停止减速滑动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出子控制器
    UITableViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self btnClick:self.titleView.subviews[index + 1]];
}
@end
