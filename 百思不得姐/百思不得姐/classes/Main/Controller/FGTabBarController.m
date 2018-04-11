//
//  FGTabBarController.m
//  百思不得姐
//
//  Created by hsf on 18/1/14.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGTabBarController.h"
#import "FGMeController.h"
#import "FGFocusController.h"
#import "FGEssentialController.h"
#import "FGNewController.h"
#import "FGTabBar.h"
#import "FGNavgationController.h"

@interface FGTabBarController ()

@end

@implementation FGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setItemTitle];
    
    [self setUpChildVC];
}

- (void)setItemTitle{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)setUpChildVC{
    FGEssentialController *essentialVC = [[FGEssentialController alloc]init];
    [self setUpOneChild:essentialVC title:@"精华" image:@"tabBar_essence_icon" selectImage:@"tabBar_essence_click_icon"];
    
    FGNewController *newVC = [[FGNewController alloc]init];
    [self setUpOneChild:newVC title:@"新帖" image:@"tabBar_new_icon" selectImage:@"tabBar_new_click_icon"];
    
    FGFocusController *focusVC = [[FGFocusController alloc]init];
    [self setUpOneChild:focusVC title:@"关注" image:@"tabBar_friendTrends_icon" selectImage:@"tabBar_friendTrends_click_icon"];
    
    FGMeController *myVC = [[FGMeController alloc]init];
    [self setUpOneChild:myVC title:@"我" image:@"tabBar_me_icon" selectImage:@"tabBar_me_click_icon"];
    
    [self setValue:[[FGTabBar alloc]init] forKey:@"tabBar"];
}

- (void)setUpOneChild:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selImage{
    
    
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageWithOriRenderingImage:selImage];
    
    FGNavgationController *nav = [[FGNavgationController alloc]initWithRootViewController:vc];
    vc.navigationItem.title = title;
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    [self addChildViewController:nav];
}

@end
