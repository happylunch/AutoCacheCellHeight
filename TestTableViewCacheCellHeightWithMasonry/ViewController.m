//
//  ViewController.m
//  TestTableViewCacheCellHeightWithMasonry
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 Happy. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "UITableViewCell+LXFAutoCellHeight.h"
#import "TextModel.h"
#import "TextCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        
        int titleTotalLength = (int)[[self titleAll] length];
        int descTotalLength = (int)[[self descAll] length];
        for (NSUInteger i = 0; i < 40; ++i) {
            int titleLength = rand() % titleTotalLength + 15;
            if (titleLength > titleTotalLength - 1) {
                titleLength = titleTotalLength;
            }
            
            TextModel *model = [[TextModel alloc] init];
            model.title = [[self titleAll] substringToIndex:titleLength];
            model.uid = (int)i + 1;
            model.isExpand = YES;
            
            int descLength = rand() % descTotalLength + 20;
            if (descLength >= descTotalLength) {
                descLength = descTotalLength;
            }
            model.desc = [[self descAll] substringToIndex:descLength];
            
            [_dataSource addObject:model];
        }
    }
    
    return _dataSource;
}

- (NSString *)titleAll {
    return @"池塘边的榕树上\n知了在声声叫着夏天操场边的秋千上\n只有蝴蝶停在上面\n黑板上老师地粉笔\n还在拼命唧唧喳喳写个不停\n等待着下课\n等待着放学\n等待游戏的童年";
}

- (NSString *)descAll {
    return @"池塘边的榕树上\n知了在声声叫着夏天操场边的秋千上\n只有蝴蝶停在上面\n黑板上老师地粉笔\n还在拼命唧唧喳喳写个不停\n等待着下课\n等待着放学\n等待游戏的童年\n\n福利社里面什么都有\n就是口袋里没有半毛钱\n诸葛四郎和魔鬼党";
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[TextCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TextModel *model = nil;
    if (indexPath.row < self.dataSource.count) {
        model = [self.dataSource objectAtIndex:indexPath.row];
    }
    [cell configCellWithModel:model];
    
    cell.expandBlock = ^(BOOL isExpand) {
        model.isExpand = isExpand;
        [tableView reloadRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    };
    return cell;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TextModel *model = nil;
    if (indexPath.row < self.dataSource.count) {
        model = [self.dataSource objectAtIndex:indexPath.row];
    }
    NSString *stateKey = nil;
    if (model.isExpand) {
        stateKey = @"expanded";
    } else {
        stateKey = @"unexpanded";
    }
    return [TextCell lxf_heightForIndexPath:indexPath config:^(UITableViewCell *sourceCell) {
        TextCell *cell = (TextCell *)sourceCell;
        [cell configCellWithModel:model];
    } cache:^NSDictionary *{
        NSDictionary *dict = @{kLXFCacheUniqueKey: [NSString stringWithFormat:@"%d", model.uid],
                               kLXFCacheForTableViewKey: tableView,
                               kLXFCacheStateKey: @"1",
                               kLXFRecalculateForStateKey:  @(YES)};
        return dict;
    }];
}


@end
