//
//  UITableViewCell+LXFAutoCellHeight.m
//  TestTableViewCacheCellHeightWithMasonry
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 Happy. All rights reserved.
//

#import "UITableViewCell+LXFAutoCellHeight.h"
#import <objc/runtime.h>



NSString *const kLXFCacheUniqueKey = @"LXFCacheUniqueKey";
NSString *const kLXFCacheStateKey  = @"LXFCacheStateKey";
NSString *const kLXFRecalculateForStateKey = @"LXFRecalculateForStateKey";
NSString *const kLXFCacheForTableViewKey = @"LXFCacheForTableViewKey";

const void *s_lxf_lastViewInCellKey = "s_lxf_lastViewInCell";
const void *s_lxf_bottomOffsetKey   = "s_lxf_bottomOffset";


@implementation UITableViewCell (LXFAutoCellHeight)

#pragma mark - public

+(CGFloat)lxf_heightForIndexPath:(NSIndexPath *)indexPath config:(LXFCellBlock)config
{
    UITableViewCell *cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (config) {
        config(cell);
    }
    return [cell private_lxf_heightForIndexPath:indexPath];
}

+(CGFloat)lxf_heightForIndexPath:(NSIndexPath *)indexPath config:(LXFCellBlock)config cache:(LXFCacheHeight)cache
{
    if (cache) {
        NSDictionary *cahceKeys = cache();
        UITableView *tableView = cahceKeys[kLXFCacheForTableViewKey];
        
        NSString *key = cahceKeys[kLXFCacheUniqueKey];
        NSString *stateKey = cahceKeys[kLXFCacheStateKey];
        NSString *shouldUpdate = cahceKeys[kLXFRecalculateForStateKey];
        
        NSMutableDictionary *stateDict = tableView.LXF_cacheCellHeightsDict[key];
        NSString *cacheHeight = stateDict[stateKey];
        
        if (tableView == nil
            || tableView.LXF_cacheCellHeightsDict.count == 0
            || shouldUpdate.boolValue
            || cacheHeight == nil) {
            CGFloat height = [self lxf_heightForIndexPath:indexPath config:config];
            
            if (stateDict == nil) {
                stateDict = [[NSMutableDictionary alloc] init];
                tableView.LXF_cacheCellHeightsDict[key] = stateDict;
            }
            [stateDict setObject:[NSString stringWithFormat:@"%lf", height] forKey:stateKey];
            return height;
        } else if (tableView.LXF_cacheCellHeightsDict.count != 0
                   && cacheHeight != nil
                   && cacheHeight.integerValue != 0) {
            return cacheHeight.floatValue;
        }
    }
    return [self lxf_heightForIndexPath:indexPath config:config];}


-(void)setLxf_bottomOffsetToCell:(CGFloat)lxf_bottomOffsetToCell
{
    objc_setAssociatedObject(self,
                             s_lxf_bottomOffsetKey,
                             @(lxf_bottomOffsetToCell),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CGFloat)lxf_bottomOffsetToCell
{
    NSNumber *valueObject = objc_getAssociatedObject(self, s_lxf_bottomOffsetKey);
    if ([valueObject respondsToSelector:@selector(floatValue)]) {
        return valueObject.floatValue;
    }
    return 0.0;
}
-(void)setLxf_lastViewInCell:(UIView *)lxf_lastViewInCell
{
    objc_setAssociatedObject(self,
                             s_lxf_lastViewInCellKey,
                             lxf_lastViewInCell,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIView *)lxf_lastViewInCell
{
    return objc_getAssociatedObject(self, s_lxf_lastViewInCellKey);
}

#pragma mark - private

- (CGFloat)private_lxf_heightForIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.lxf_lastViewInCell != nil, @"您未指定cell排列中最后一个视图对象，无法计算cell的高度");
    
    [self layoutIfNeeded];
    
    CGFloat rowHeight = self.lxf_lastViewInCell.frame.size.height + self.lxf_lastViewInCell.frame.origin.y;
    rowHeight += self.lxf_bottomOffsetToCell;
    
    return rowHeight;
}




@end
