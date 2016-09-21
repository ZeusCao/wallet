//
//  ViewController.m
//  MembershipCard
//
//  Created by Meetclass on 16/8/12.
//  Copyright © 2016年 Zeus. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>
#define WEMARTBUNDLE_NAME   @"Card.bundle"
#define WEMARTBUNDLE_PATH   [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: WEMARTBUNDLE_NAME]
#define WEMARTBUNDLE        [NSBundle bundleWithPath: WEMARTBUNDLE_PATH]

@interface ViewController ()<PKAddPassesViewControllerDelegate>

@property (nonatomic, strong)PKPass *pass; // 票据
@property (nonatomic, strong)PKAddPassesViewController *addPassesController;// 票据添加控制器

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark --- 添加按钮点击事件 ---
- (IBAction)addPassClick:(id)sender
{
    // 确保pass合法，否则无法添加
    [self addPass];
}


#pragma mark - 属性
/**
 *  创建Pass对象
 *
 *  @return Pass对象
 */
- (PKPass *)pass
{
    if (!_pass) {
        //NSString *passPath = [WEMARTBUNDLE pathForResource:@"memberShipCard" ofType:@"pkpass"];
        //NSString *passPath = [[NSBundle mainBundle]pathForResource:@"Card" ofType:@"bundle"];
        NSString *passPath = [[NSBundle mainBundle]pathForResource:@"memberShipCard" ofType:@"pkpass"];
        NSData *passData = [NSData dataWithContentsOfFile:passPath];
        NSError *error = nil;
        _pass = [[PKPass alloc]initWithData:passData error:&error];
        if (error) {
            NSLog(@"创建Pass过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _pass;
}

/**
 *  创建添加Pass的控制器
 *
 *  @return <#return value description#>
 */
- (PKAddPassesViewController *)addPassesController
{
    if (!_addPassesController) {
        _addPassesController = [[PKAddPassesViewController alloc]initWithPass:self.pass];
        _addPassesController.delegate = self;
    }
    return _addPassesController;
}

#pragma mark --- 私有方法 ---
- (void)addPass
{
    if (![PKAddPassesViewController canAddPasses]) {
        NSLog(@"无法添加Pass.");
        return;
    }
    [self presentViewController:self.addPassesController animated:YES completion:nil];
}


#pragma mark - PKAddPassesViewController代理方法-
- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller
{
    NSLog(@"添加成功");
    [self.addPassesController dismissViewControllerAnimated:YES completion:nil];
    // 添加成功后转到Passbook应用并展示添加的pass
    NSLog(@"%@",self.pass.passURL);
    [[UIApplication sharedApplication]openURL:self.pass.passURL];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
