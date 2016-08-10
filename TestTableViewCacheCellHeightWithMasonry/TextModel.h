//
//  TextModel.h
//  TestTableViewCacheCellHeightWithMasonry
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 Happy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) int uid;
@property (nonatomic, assign) BOOL isExpand;

@end
