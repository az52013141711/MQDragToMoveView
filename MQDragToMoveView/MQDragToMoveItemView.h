//
//  MQDragToMoveItemView.h
//
//  Created by 杨孟强 on 16/6/16.
//  Copyright © 2016年 杨孟强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQUserInfoNil.h"

@protocol MQDragToMoveItemDelegate <NSObject>

@optional

- (void)MQDragToMoveItemTapGestureRecognizer:(UITapGestureRecognizer *)tap;
- (void)MQDragToMoveItemLongPressSelected:(UILongPressGestureRecognizer *)longPress;
- (void)MQDragToMoveItemPanGestureRecognizer:(UIPanGestureRecognizer *)panGesture;

@end


/**可以拖拽移动ItemView*/
@interface MQDragToMoveItemView : UIView

/**代理*/
@property (nonatomic, weak) id<MQDragToMoveItemDelegate> delegate;
/**当前位置*/
@property (nonatomic) NSInteger index;
/**附带用户信息*/
@property (nonatomic, strong) id userInfo;

/**类方法创建Item*/
+ (instancetype)createMQDragToMoveItemWithFrame:(CGRect)frame MQDragToMoveItemDelegate:(id<MQDragToMoveItemDelegate>)delegate index:(NSInteger)index userInfo:(id)userInfo;

@end
