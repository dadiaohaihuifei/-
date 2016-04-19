//
//  shopCartCell.h
//  购物车效果
//
//  Created by MrWu on 16/4/18.
//  Copyright © 2016年 MrWu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class goodModel;

@interface shopCartCell : UITableViewCell

@property (nonatomic, strong) goodModel *model;
@property (nonatomic, copy) void (^shopCart)(UIImageView *headerImageView);
@end
