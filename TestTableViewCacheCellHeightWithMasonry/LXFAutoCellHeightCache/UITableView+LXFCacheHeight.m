

//
//  UITableView+LXFCacheHeight.m
//  TestTableViewCacheCellHeightWithMasonry
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 Happy. All rights reserved.
//

#import "UITableView+LXFCacheHeight.h"
#import <objc/runtime.h>

static const void *__lxf_tableview_cacheCellHeightKey = "__lxf_tableviewcellheightkey";

@implementation UITableView (LXFCacheHeight)

-(NSMutableDictionary *)LXF_cacheCellHeightsDict
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, __lxf_tableview_cacheCellHeightKey);
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, __lxf_tableview_cacheCellHeightKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

@end
