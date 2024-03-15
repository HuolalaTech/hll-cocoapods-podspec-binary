//
//  ViewController.m
//  BinaryDemo
//
//  Created by 代代朋朋 on 2022/1/6.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view = [UIView new];
    view.frame = CGRectMake(100, 200, 100, 100);
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(100, 300, 200, 200)];
    image.backgroundColor = [UIColor redColor];
    [self.view addSubview:image];
}


@end
