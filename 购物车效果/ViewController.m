//
//  ViewController.m
//  购物车效果
//
//  Created by MrWu on 16/4/18.
//  Copyright © 2016年 MrWu. All rights reserved.
//

#import "ViewController.h"
#import "shopCartCell.h"
#import "goodModel.h"
//判断版本信息
#define IS_IOS7 ([UIDevice currentDevice].systemVersion.floatValue > 7.0 ? YES : NO)
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define NavColor ([UIColor colorWithRed:237/255.0 green:20/255.0f blue:91/255.0f alpha:1.0f])
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIBezierPath *path;
@end

@implementation ViewController {
    CALayer *_layer;
    UITableView *_tableView;
    UIButton *_sopCartBtn;
    CALayer *_sharpLayer;
    UILabel *_cntLabel;
    UIButton *_btn;
    NSMutableArray *_dataSource;
    NSInteger _cnt;
}
static NSString *const ID = @"shop";
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];
    [self data];

    [self customNavgationBar];
    [self creatTableView];
    [self bottomBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
//手动加载数据
- (void)data {
    for (int i = 0; i < 10; i ++) {
        NSInteger index = arc4random() % 5 + 1;
        goodModel *model = [goodModel new];
        model.shoppingName = [NSString stringWithFormat:@"第%d个商品",i];
        model.shoppingIcon = [NSString stringWithFormat:@"test%02ld",index];
        [_dataSource addObject:model];
    }
}

//自定义导航栏
- (void)customNavgationBar {
    //如果有，隐藏
    self.navigationController.navigationBarHidden = YES;
    CGFloat h = IS_IOS7 ? 64 : 44;
    CGFloat subH = IS_IOS7 ? 20 : 0;
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, h)];
    navView.backgroundColor = NavColor;
    [self.view addSubview:navView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, subH, SCREEN_W, 44)];
    if (!IS_IOS7) titleLabel.backgroundColor = NavColor;
    titleLabel.text = @"shopCart";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:21];
    [navView addSubview:titleLabel];
}
//加载tableView
- (void)creatTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64 - 49) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"shopCartCell" bundle:nil]   forCellReuseIdentifier:ID];
    _tableView.rowHeight = 90;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
//自定义底部栏
- (void)bottomBar {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 49, SCREEN_W, 49)];
    [self.view addSubview:bottomView];
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 49)];
    coverView.alpha = 0.8;
    coverView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bottomView addSubview:coverView];
    
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 60, 0, 50, 50)];
    [_btn setImage:[UIImage imageNamed:@"TabCartSelected"] forState:UIControlStateNormal];
    [bottomView addSubview:_btn];
    
    _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W - 60, 10, 13, 13)];
    UIColor *customColor  = [UIColor colorWithRed:237/255.0 green:20/255.0 blue:91/255.0 alpha:1.0f];
    _cntLabel.textColor = customColor;
    _cntLabel.textAlignment = NSTextAlignmentCenter;
    _cntLabel.font = [UIFont systemFontOfSize:11];
    _cntLabel.backgroundColor = [UIColor whiteColor];
    _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds) * 0.5;
    _cntLabel.layer.masksToBounds = YES;
    _cntLabel.layer.borderWidth = 0.5f;
    _cntLabel.layer.borderColor = customColor.CGColor;
    [bottomView addSubview:_cntLabel];
    if (!_cnt) {
        _cntLabel.hidden = YES;
    }
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    shopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
  
    cell.model = _dataSource[indexPath.row];
    
    cell.shopCart = ^(UIImageView *headerImageView) {
        CGRect rect = [_tableView rectForRowAtIndexPath:indexPath];
        rect.origin.y = rect.origin.y - _tableView.contentOffset.y;
        CGRect imageViewRect = headerImageView.frame;
        imageViewRect.origin.y = rect.origin.y + imageViewRect.origin.y;
        [self startAnimationWithRect:imageViewRect ImageView:headerImageView];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)startAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView {
    if (!_layer) {
        _layer = [CALayer layer];
        _layer.contents = imageView.layer.contents;
        _layer.contentsGravity = kCAGravityResizeAspectFill;
        _layer.bounds = rect;
        
        _layer.cornerRadius = CGRectGetHeight(_layer.bounds) * 0.5;
        _layer.masksToBounds = YES;
        
        _layer.position = CGPointMake(imageView.center.x, CGRectGetMidY(rect) + 64);
        [self.view.layer addSublayer:_layer];
        
        _path = [UIBezierPath bezierPath];
        [_path moveToPoint:_layer.position];
        [_path addQuadCurveToPoint:CGPointMake(SCREEN_W - 40, SCREEN_H - 40) controlPoint:CGPointMake(SCREEN_W * 0.5, rect.origin.y - 80)];
    }
    [self groupAnimation];
}

- (void)groupAnimation {
    _tableView.userInteractionEnabled = NO;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.duration = 1.5f;
    narrowAnimation.beginTime = 0.5f;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.3f];
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,expandAnimation,narrowAnimation];
    group.duration = 2.0f;
    group.removedOnCompletion = NO;
    group.delegate = self;
    //layer会保持动画之后的状态
    group.fillMode = kCAFillModeForwards;
    [_layer addAnimation:group forKey:@"group"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (anim == [_layer animationForKey:@"group"]) {
        _tableView.userInteractionEnabled = YES;
        
        [_layer removeFromSuperlayer];
        _layer = nil;
        
        _cnt++;
        if (_cnt) {
            _cntLabel.hidden = NO;
        }
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25f;
        _cntLabel.text = [NSString stringWithFormat:@"%ld",_cnt];
        [_cntLabel.layer addAnimation:animation forKey:nil];
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5.0f];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5.0f];
        //回到最初位置 autoreverses
        shakeAnimation.autoreverses = YES;
        [_btn.layer addAnimation:shakeAnimation forKey:nil];
    }
}
@end
