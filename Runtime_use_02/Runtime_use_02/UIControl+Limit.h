//
//  UIControl+Limit.h
//  Runtime_use_01
//
//  Created by 项正强 on 2018/11/12.
//  Copyright © 2018 项正强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (Limit)

#pragma mark - 给类别扩充属性
/**
 
 点击事件的间隔
 保证项目中的点击事件短时间内重复点击
 
 */
@property(nonatomic,assign)NSTimeInterval acceptEventInterval;

/**
 
 是否忽略此次点击事件
 
 */
@property(nonatomic,assign)BOOL ignoreEvent;

@end

NS_ASSUME_NONNULL_END
