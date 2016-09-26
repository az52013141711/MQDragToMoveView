//
//  MQDragToMoveItemView.m
//
//  Created by 杨孟强 on 16/6/16.
//  Copyright © 2016年 杨孟强. All rights reserved.
//

#import "MQDragToMoveItemView.h"

@interface MQDragToMoveItemView ()<UIGestureRecognizerDelegate>

/**长按手势是否触发*/
@property (nonatomic) BOOL longPress;

/**单击手势*/
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
/**长按手势*/
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
/**滑动手势*/
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end


@implementation MQDragToMoveItemView

#pragma mark - 类方法创建Item
+ (instancetype)createMQDragToMoveItemWithFrame:(CGRect)frame MQDragToMoveItemDelegate:(id<MQDragToMoveItemDelegate>)delegate index:(NSInteger)index userInfo:(id)userInfo
{
    MQDragToMoveItemView *item = [[MQDragToMoveItemView alloc] initWithFrame:frame];
    item.delegate = delegate;
    item.index = index;
    item.userInfo = userInfo;
    return item;
}

#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
        
        [self MQDragToMoveItemViewinit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self MQDragToMoveItemViewinit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self MQDragToMoveItemViewinit];
    }
    return self;
}

#pragma mark - 初始化数据
- (void)MQDragToMoveItemViewinit
{
    self.longPress = NO;
    self.userInteractionEnabled = YES;
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    self.tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    self.panGestureRecognizer.delegate = self;
    
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    self.longPressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.longPressGestureRecognizer];
}

#pragma mark - 手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return (otherGestureRecognizer.view == self);
}
#pragma mark 单击手势事件
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded &&
               self.longPress == YES) {
        
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(MQDragToMoveItemPanGestureRecognizer:)]) {
            [self.delegate MQDragToMoveItemPanGestureRecognizer:(UIPanGestureRecognizer *)tap];
        }
    } else {
        
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(MQDragToMoveItemTapGestureRecognizer:)]) {
            [self.delegate MQDragToMoveItemTapGestureRecognizer:tap];
        }
    }
}
#pragma mark 长按手势
- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.longPress = YES;
        
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(MQDragToMoveItemLongPressSelected:)]) {
            [self.delegate MQDragToMoveItemLongPressSelected:longPress];
        }
    } else if (longPress.state == UIGestureRecognizerStateEnded &&
               self.longPress == YES) {
        
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(MQDragToMoveItemPanGestureRecognizer:)]) {
            [self.delegate MQDragToMoveItemPanGestureRecognizer:(UIPanGestureRecognizer *)longPress];
        }
    }
}
#pragma mark 滑动手势事件
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture
{
    if (self.longPress) {
        
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(MQDragToMoveItemPanGestureRecognizer:)]) {
            [self.delegate MQDragToMoveItemPanGestureRecognizer:panGesture];
        }
        
        if (panGesture.state == UIGestureRecognizerStateEnded) {
            self.longPress = NO;
        }
    }
    
}

#pragma mark - set
- (void)setUserInfo:(id)userInfo
{
    _userInfo = ((userInfo == nil) ? MQDragToMoveUserInfoNil() : userInfo);
}

@end
