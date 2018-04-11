//
//  FGRcommentController.m
//  百思不得姐
//
//  Created by hsf on 18/1/19.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGRcommentController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "FGRecommentTagCell.h"
#import "FGRecommentModel.h"
#import "FGRightModel.h"
#import "FGRightCell.h"
#import "MJRefresh.h"

@interface FGRcommentController ()<UITableViewDelegate,UITableViewDataSource>
// 左边tag
@property (nonatomic, strong)NSArray *categories;
// 右边数据
@property (nonatomic, strong)NSArray *items;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;

/** AFN请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation FGRcommentController

static NSString *const tagCell = @"tagCell";
static NSString *const rightCell = @"rightCell";

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [self setupRefresh];
    
    [self requestData];
    
}

- (void)setupRefresh{
    
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.rightTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRight)];
    
    self.rightTableView.mj_footer.hidden = YES;
}

#pragma mark - 加载用户数据
- (void)loadNewUsers
{
    FGRecommentModel *rc = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    
    // 设置当前页码为1
    rc.currentPage = 1;
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(rc.id);
    params[@"page"] = @(rc.currentPage);
    self.params = params;
    
    // 发送请求给服务器, 加载右侧的数据
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 字典数组 -> 模型数组
        NSArray *rights = [FGRightModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 清除所有旧数据
        [rc.rights removeAllObjects];
        
        // 添加到当前类别对应的用户数组中
        [rc.rights addObjectsFromArray:rights];
        
        // 保存总数
        rc.total = [responseObject[@"total"] integerValue];
        
        // 不是最后一次请求
        if (self.params != params) return;
        
        // 刷新右边的表格
        [self.rightTableView reloadData];
        
        // 结束刷新
        [self.rightTableView.mj_header endRefreshing];
        
        // 让底部控件结束刷新
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 结束刷新
        [self.rightTableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreRight{
    FGRecommentModel *category = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    
    // 发送请求给服务器, 加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.id);
    params[@"page"] = @(++category.currentPage);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 字典数组 -> 模型数组
        NSArray *users = [FGRightModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 添加到当前类别对应的用户数组中
        [category.rights addObjectsFromArray:users];
        
        // 不是最后一次请求
        if (self.params != params) return;
        
        // 刷新右边的表格
        [self.rightTableView reloadData];
        
        // 让底部控件结束刷新
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 让底部控件结束刷新
        [self.rightTableView.mj_footer endRefreshing];
    }];
    

}

/**
 * 时刻监测footer的状态
 */
- (void)checkFooterState
{
    FGRecommentModel *rc = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    
    // 每次刷新右边数据时, 都控制footer显示或者隐藏
    self.rightTableView.mj_footer.hidden = (rc.rights.count == 0);
    
    // 让底部控件结束刷新
    if (rc.rights.count == rc.total) { // 全部数据已经加载完毕
        [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
    } else { // 还没有加载完毕
        [self.rightTableView.mj_footer endRefreshing];
    }
}

- (void)setUpTableView{
    self.title = @"我的关注";
    self.view.backgroundColor = FGGolobBg;
    // 注册tableview
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FGRecommentTagCell class])  bundle:nil] forCellReuseIdentifier:tagCell];
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FGRightCell class])  bundle:nil] forCellReuseIdentifier:rightCell];
    
    // 设置tableview横滑取消
    self.categoryTableView.showsHorizontalScrollIndicator = NO;
    self.rightTableView.showsHorizontalScrollIndicator = NO;
    
    // 设置inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(-20, 44, 0, 0);
    self.rightTableView.contentInset = self.categoryTableView.contentInset;
    
//    self.categoryTableView.pagingEnabled = YES;
//    self.rightTableView.pagingEnabled = YES;
}

- (void)requestData{
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        [SVProgressHUD dismiss];
        self.categories = [FGRecommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.categoryTableView reloadData];
        
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        // 让用户表格进入下拉刷新状态
        [self.rightTableView.mj_header beginRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showInfoWithStatus:@"加载失败"];
        NSLog(@"----%@",error);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // 左边的类别表格
    if (tableView == self.categoryTableView) return self.categories.count;
    
    // 监测footer的状态
    [self checkFooterState];
    
    FGRecommentModel *c = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    // 右边的用户表格
    return c.rights.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        FGRecommentTagCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCell];
        
        cell.category = self.categories[indexPath.row];
        return cell;
    }else{
        
        FGRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCell];
        FGRecommentModel *c = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        cell.right = c.rights[indexPath.row];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 结束刷新
    [self.rightTableView.mj_header endRefreshing];
    [self.rightTableView.mj_footer endRefreshing];
    
    FGRecommentModel *c = self.categories[indexPath.row];
    if (c.rights.count) {
        // 显示曾经的数据
        [self.rightTableView reloadData];
    } else {
        // 赶紧刷新表格,目的是: 马上显示当前category的用户数据, 不让用户看见上一个category的残留数据
        [self.rightTableView reloadData];
        
        // 进入下拉刷新状态
        [self.rightTableView.mj_header beginRefreshing];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - 控制器的销毁
- (void)dealloc
{
    // 停止所有操作
    [self.manager.operationQueue cancelAllOperations];
}
@end
