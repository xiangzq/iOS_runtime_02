//
//  UIControl+Limit.m
//  Runtime_use_01
//
//  Created by 项正强 on 2018/11/12.
//  Copyright © 2018 项正强. All rights reserved.
//

#import "UIControl+Limit.h"

#import <objc/runtime.h>

static const void *xzq_ignoreEvent            = @"xzq_ignoreEvent";

static const void *xzq_acceptEventInterval    = @"xzq_acceptEventInterval";

@implementation UIControl (Limit)

#pragma mark - 重写set get方法
-(void)setIgnoreEvent:(BOOL)ignoreEvent{
    
    /**
     参数一：要set哪个类的属性
     参数二：key，用作get方法中d唯一查询条件
     参数三：当前set的属性
     参数四：根据你属性的定义来传递，有以下几种
     
     OBJC_ASSOCIATION_ASSIGN = 0,
     
     OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1
     
     OBJC_ASSOCIATION_COPY_NONATOMIC = 3,
     
     OBJC_ASSOCIATION_RETAIN = 01401,
     
     OBJC_ASSOCIATION_COPY = 01403
     
     看后缀就知道了，跟你定义属性的关键属性是相关的
     */
    
    objc_setAssociatedObject(self, xzq_ignoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_ASSIGN);
    
}

-(BOOL)ignoreEvent{
    
    /**
     根据setx方法中的key就可以拿到value了
     */
    return [objc_getAssociatedObject(self, xzq_ignoreEvent) boolValue];
    
}

-(void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval{
    
    objc_setAssociatedObject(self, xzq_acceptEventInterval, @(acceptEventInterval), OBJC_ASSOCIATION_ASSIGN);
    
}

-(NSTimeInterval)acceptEventInterval{
    
    return [objc_getAssociatedObject(self, xzq_acceptEventInterval) doubleValue];
    
}

/**
 本身只加载一次
 当类加载进内存的时候调用，而且不管有没有子类，都只会调用一次
 在main函数之前就调用了，不需要我们手动调用
 用途：可以新建类，在该类中实现一些配置
 runtime交换方法的时候，因为只需要交换一次方法，所以可以在该方法中实现交换方法的代码，用于只实现一次的代码
 */
+(void)load{
    //这里主要是防止该方法会被手动调用，所以再加一次保障
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /**
         拿到系统的方法
         参数一：获取哪个类的方法
         参数二：SEL 获取要交换的方法
         */
        Method m1 = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
        //拿到自定义的方法
        Method m2 = class_getInstanceMethod(self, @selector(xzq_sendAction:to:forEvent:));
        //进行方法的交换，其实质就是交换方法地址
        method_exchangeImplementations(m1, m2);
        
    });
    
}

#pragma mark - 交换方法
-(void)xzq_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    NSLog(@"调用了%@的点击事件",NSStringFromClass([self class]));
    
    if (self.acceptEventInterval == 0) {
        self.acceptEventInterval = 1;
    }
    
    //如果当前忽略属性为truez，则直接return
    if (self.ignoreEvent) {
        
        NSLog(@"忽略此次点击\n还需等待%.2fs",self.acceptEventInterval);
        
        return;
    }
    
    //判断两次点击的间隔时间是否大于0
    if (self.acceptEventInterval > 0) {
        //激活忽略属性
        self.ignoreEvent = true;
        //x秒后（self.acceptEventInterval的值）关闭self.ignoreEvent属性
        [self performSelector:@selector(changeIgnoreEvent) withObject:nil afterDelay:self.acceptEventInterval];
        
    }
    
    //调用系统点击事件（由于事件已交换，所以调用的是系统方法）
    [self xzq_sendAction:action to:target forEvent:event];
    
}

-(void)changeIgnoreEvent{
    
    self.ignoreEvent = false;
    
}


@end
