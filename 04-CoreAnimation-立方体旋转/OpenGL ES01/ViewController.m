//
//  ViewController.m
//  OpenGL ES01
//
//  Created by plz on 2020/7/24.
//  Copyright © 2020 plz. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface ViewController ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation ViewController

#pragma mark - life cyle 1、控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView =[[UIView alloc]initWithFrame:self.view.bounds];
    self.contentView.backgroundColor =UIColor.redColor;
    [self.view addSubview:self.contentView];
    
    //添加立方体各个面
    CATransform3D tranform =CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 tranform:tranform];
    
    tranform =CATransform3DMakeTranslation(100, 0, 0);
    tranform =CATransform3DRotate(tranform, M_PI_2, 0, 1, 0);
    [self addFace:1 tranform:tranform];
    
    tranform =CATransform3DMakeTranslation(0, -100, 0);
    tranform =CATransform3DRotate(tranform, M_PI_2, 1, 0, 0);
    [self addFace:2 tranform:tranform];
    
    tranform =CATransform3DMakeTranslation(0, 100, 0);
    tranform =CATransform3DRotate(tranform, -M_PI_2, 1, 0, 0);
    [self addFace:3 tranform:tranform];
    
    tranform =CATransform3DMakeTranslation(-100, 0, 0);
    tranform =CATransform3DRotate(tranform, -M_PI_2, 0, 1, 0);
    [self addFace:4 tranform:tranform];
    
    tranform =CATransform3DMakeTranslation(0, 0, -100);
    tranform =CATransform3DRotate(tranform, M_PI, 0, 1, 0);
    [self addFace:5 tranform:tranform];
    
    __block NSInteger angle =0;
    
    NSTimer *timer =[NSTimer scheduledTimerWithTimeInterval:1.0/60.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        angle =(angle + 2)%360;
        self.contentView.layer.sublayerTransform =CATransform3DMakeRotation(M_PI/180.0f * angle, 0.4, 0.5, 0.6);
    }];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark - 2、不同业务处理之间的方法以
-(void)addFace:(NSInteger)index tranform:(CATransform3D)tranform{
    NSString *filePath =[[NSBundle mainBundle]pathForResource:@"james" ofType:@"jpeg"];
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.image =[UIImage imageWithContentsOfFile:filePath];
    [self.contentView addSubview:imageView];
    imageView.center=self.contentView.center;
    imageView.layer.transform =tranform;
}

#pragma mark - Network 3、网络请求

#pragma mark - Action Event 4、响应事件

#pragma mark - Call back 5、回调事件

#pragma mark - Delegate 6、代理、数据源

#pragma mark - interface 7、UI处理

#pragma mark - lazy loading 8、懒加载

@end
