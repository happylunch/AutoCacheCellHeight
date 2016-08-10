//
//  UITableView+LXFCacheHeight.h
//  TestTableViewCacheCellHeightWithMasonry
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 Happy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LXFCacheHeight)

//存储cell的行高
@property (nonatomic,strong,readonly) NSMutableDictionary *LXF_cacheCellHeightsDict;


@end
