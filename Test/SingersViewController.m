//
//  SingersViewController.m
//  Test
//
//  Created by admin on 16/1/10.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "SingersViewController.h"
#import "UIImageView+WebCache.h"
#import "SingerModel.h"
#import "SingerViewModel.h"
#import "MJRefresh.h"
#import "UIView+Reload.h"


@interface SingersViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)  UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataArr;

@end

@implementation SingersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, 667-49) style:UITableViewStylePlain];
    
    [self.view addSubview:_tableView];
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"singer"];
    
    [self initData];
    
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarButtonClick) name:@"TabbarButtonClickDidRepeatNotification" object:nil];
}

- (void)tabbarButtonClick{
    
    //判断window是否在窗口上
    if (self.view.window == nil) return;
    //判断当前的view是否与窗口重合
    if (![self.view hu_intersectsWithAnotherView:nil]) return;
    //实现界面的回滚
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(void)initData
{
    self.area = @"6";
    self.sex  = @"1";
    self.group = @"热门";
    self.offset = 0;
    _dataArr = [NSMutableArray array];

    _viewModel = [[SingerViewModel alloc]init];
    __weak  typeof(self) weakSelf=self;
    [_viewModel setBlockWithSuccessBlock:^(id result) {
        if (weakSelf.offset==0) {
            weakSelf.dataArr=result;
            [weakSelf.tableView.header endRefreshing];
        }else{
            [weakSelf.dataArr addObjectsFromArray:result];
            [weakSelf.tableView.footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
    } FailBlock:^{
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
    } ErrorBlock:^(id error) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
    }];
    
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.offset=0;
        [weakSelf getData];
    }];
    [self.tableView.header beginRefreshing];
    self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^(){
        weakSelf.offset+=20;
        [weakSelf getData];
    }];
}
-(void)getData
{
    [_viewModel getSingersFromArea:self.area Sex:self.sex Group:self.group Offset:self.offset];
}
//delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"singer"];
    
    SingerModel *model=_dataArr[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_mini] placeholderImage:nil];
    cell.textLabel.text=model.name;
    return cell;
}
//headerView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UITableViewHeaderFooterView *view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
    UIView *view  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    view.backgroundColor=[UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 40)];
    label.text=[NSString stringWithFormat:@"华语男歌手"];
    label.font=[UIFont systemFontOfSize:22.0];
    [view addSubview:label];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了SingerViewController的单元格");
}



@end
