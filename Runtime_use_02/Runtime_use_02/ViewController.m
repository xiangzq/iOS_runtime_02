//
//  ViewController.m
//  Runtime_use_02
//
//  Created by 项正强 on 2018/11/12.
//  Copyright © 2018 项正强. All rights reserved.
//

#import "ViewController.h"
#import "UIControl+Limit.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createButton];
    
}

-(void)createButton{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.backgroundColor = [UIColor redColor];
    
    btn.frame = CGRectMake(self.view.bounds.size.width/2 - 50, self.view.bounds.size.height/2 - 50, 100, 100);
    
//    btn.acceptEventInterval = 3;
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)btnAction{
    
    NSLog(@"点击了");
    
}

@end
