//
//  MQDragToMoveUserInfoNil.m
//  slideBut_demo
//
//  Created by yoka_mobile_cm on 16/6/17.
//  Copyright © 2016年 yoka_mobile_cm. All rights reserved.
//

#import "MQUserInfoNil.h"

@implementation MQUserInfoNil

MQUserInfoNil *MQDragToMoveUserInfoNil()
{
    return [[MQUserInfoNil alloc] init];
}

+ (BOOL)isMQUserInfoNil:(id)userInfo
{
    return [userInfo isKindOfClass:[MQUserInfoNil class]];
}

@end
