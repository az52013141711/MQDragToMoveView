//
//  ViewController.m
//  MQDragToMoveView_demo
//
//  Created by yoka_mobile_cm on 16/9/26.
//  Copyright © 2016年 杨孟强. All rights reserved.
//

#import "ViewController.h"
#import "MQDragToMoveView.h"

@interface ViewController ()<MQDragToMoveViewDelegate>

@property (nonatomic, strong) MQDragToMoveView *dragTomoveView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dragTomoveView = [MQDragToMoveView
                           createMQDragToMoveViewWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20)
                           delegate:self
                           itemNumberOfColumns:4
                           itemCount:21
                           itemViewHeight:50
                           userInfoArray:nil];
    
    NSArray *itemArray = self.dragTomoveView.items;
    for (int i = 0; i < itemArray.count; ++i) {
        
        NSString *NewsCategoryName = [NSString stringWithFormat:@"%d", i];
        MQDragToMoveItemView *item = itemArray[i];
        item.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        item.userInfo = NewsCategoryName;
        
        [item addSubview:[self createMyChannelsViewWithFrame:CGRectMake(5, 5, item.frame.size.width-5, item.frame.size.height-5) title:NewsCategoryName]];
    }
    
    [self.view addSubview:self.dragTomoveView];
    
}

- (UIView *)createMyChannelsViewWithFrame:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 369;
    return label;
}


#pragma mark - MQDragToMoveItemView 代理
- (void)MQDragToMoveViewItemTapGestureRecognizer:(MQDragToMoveItemView *)itemView
{
    NSLog(@"%@", itemView.userInfo);
    
    if (itemView.index % 2) {
        [_dragTomoveView removeItemsViewAtIndex:itemView.index animated:YES];
    } else {
        
        MQDragToMoveItemView *item = [_dragTomoveView addItemViewAndUserInfo:nil animated:YES];
        
        item.userInfo = [NSString stringWithFormat:@"%d", arc4random()%255];
        item.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        [item addSubview:[self createMyChannelsViewWithFrame:CGRectMake(5, 5, item.frame.size.width-5, item.frame.size.height-5) title:item.userInfo]];
    }
}
- (void)MQDragToMoveViewItemLongPressSelected:(MQDragToMoveItemView *)itemView
{
    UILabel *label = [itemView viewWithTag:369];
    if (label) {
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:18];
    }
}
- (void)MQDragToMoveViewItemGestureRelease:(MQDragToMoveItemView *)itemView
{
    UILabel *label = [itemView viewWithTag:369];
    if (label) {
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
