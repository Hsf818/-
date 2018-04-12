//
//  FGWordViewController.m
//  百思不得姐
//
//  Created by hsf on 2018/3/19.
//  Copyright © 2018年 衡申发. All rights reserved.
//

#import "FGTopicViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "FGTopics.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "FGTopicCell.h"

@interface FGTopicViewController ()

/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;

@end

@implementation FGTopicViewController
- (NSMutableArray *)topics
{
    if(!_topics){
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRefresh];
    
    [self setupTableview];
}

static NSString *FGTopicCellId = @"topic";
- (void)setupTableview{
    // 设置内边距
    //    CGFloat top = FGTitilesViewH;
    //    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FGTopicCell class]) bundle:nil] forCellReuseIdentifier:FGTopicCellId];
    self.tableView.backgroundColor = FGGolobBg;
}

- (void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadNewData{
    // 结束上拉刷新
    [self.tableView.mj_footer endRefreshing];
    
    NSString *url = @"http://api.budejie.com/api/api_open.php";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(self.params != params) return;
        
        self.topics = [FGTopics mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
        self.page = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(self.params != params) return;
        
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    // 结束下拉刷新
    [self.tableView.mj_header endRefreshing];
    
    self.page++;
    
    NSString *url = @"http://api.budejie.com/api/api_open.php";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"page"] = @(self.page);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(self.params != params) return;
        
        NSArray *topics = [FGTopics mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:topics];
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 刷新数据
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        // 加载失败时页码还原
        self.page--;
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FGTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:FGTopicCellId];
    
    cell.topics = self.topics[indexPath.row];
    
    return cell;
}

#pragma mark - tableview代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取出模型数据
    FGTopics *topics = self.topics[indexPath.row];
    
    return topics.cellHeight;
}

@end


