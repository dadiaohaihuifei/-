//
//  shopCartCell.m
//  购物车效果
//
//  Created by MrWu on 16/4/18.
//  Copyright © 2016年 MrWu. All rights reserved.
//

#import "shopCartCell.h"
#import "goodModel.h"
@interface shopCartCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation shopCartCell


- (IBAction)purchaseClick:(UIButton *)sender {
    self.shopCart(_headerImageView);
}

- (void)setModel:(goodModel *)model {
    _model = model;
    _headerImageView.image = [UIImage imageNamed:model.shoppingIcon];
    _nameLabel.text = model.shoppingName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//试图创建修改圆形头像
- (void)awakeFromNib {
    _headerImageView.layer.cornerRadius = CGRectGetHeight(_headerImageView.bounds) * 0.5;
    _headerImageView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:_btn];
    [self.contentView addSubview:_headerImageView];
    [self.contentView addSubview:_nameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
