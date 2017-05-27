//
//  ViewController.m
//  YBMultistageScrollView
//
//  Created by cqdingwei@163.com on 2017/5/27.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#import "ViewController.h"
#import "GoodsDetailsVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickButton:(UIButton *)sender {
    [self presentViewController:[GoodsDetailsVC new] animated:NO completion:nil];
}


@end
