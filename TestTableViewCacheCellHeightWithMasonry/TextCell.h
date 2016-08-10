//
//  TextCell.h
//  TestTableViewCacheCellHeightWithMasonry
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 Happy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextModel;

typedef void(^LXFExpandBlock)(BOOL isExpand);

@interface TextCell : UITableViewCell

@property (nonatomic,copy)LXFExpandBlock expandBlock;

-(void)configCellWithModel:(TextModel *)model;


@end
