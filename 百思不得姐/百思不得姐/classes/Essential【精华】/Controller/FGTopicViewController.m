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
#import "FGCommentViewController.h"
#import "ZFPlayer.h"

@interface FGTopicViewController ()<ZFPlayerDelegate>

/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;


@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation FGTopicViewController
- (NSMutableArray *)topics
{
    if(!_topics){
        _topics = [NSMutableArray array];
    }
    return _topics;
}

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    if (ZFPlayerShared.isLandscape) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;
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
    
    FGTopics *topics = self.topics[indexPath.row];
    
    // 赋值model
    cell.topics = topics;
    __block NSIndexPath *weakIndexPath = indexPath;
    __weak typeof(self)  weakSelf      = self;
    cell.playBlock = ^(UIButton *btn) {
        // 取出字典中的第一视频URL
        NSURL *videoURL = [NSURL URLWithString:topics.videouri];
        
        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
//        playerModel.title            = @"返回";
        playerModel.videoURL         = videoURL;
        playerModel.placeholderImageURLString = topics.large_image;
        playerModel.scrollView       = weakSelf.tableView;
        playerModel.indexPath        = weakIndexPath;
        // player的父视图tag
//        playerModel.fatherViewTag    = weakCell.videoView.tag;
        playerModel.fatherViewTag    = 101;
        
        // 设置播放控制层和model
        [weakSelf.playerView playerControlView:nil playerModel:playerModel];
        // 下载功能
        weakSelf.playerView.hasDownload = YES;
        // 自动播放
        [weakSelf.playerView autoPlayTheVideo];
    };
    return cell;
}

#pragma mark - tableview代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取出模型数据
    FGTopics *topics = self.topics[indexPath.row];
    
    return topics.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FGCommentViewController *commentVC = [[FGCommentViewController alloc] init];
    [self.navigationController pushViewController:commentVC animated:YES];
}


- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
        // 移除屏幕移除player
        // _playerView.stopPlayWhileCellNotVisable = YES;
        
        _playerView.forcePortrait = NO;
        
        ZFPlayerShared.isLockScreen = YES;
        ZFPlayerShared.isStatusBarHidden = NO;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
//    NSString *name = [url lastPathComponent];
//    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
//    // 设置最多同时下载个数（默认是3）
//    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
}

@end


