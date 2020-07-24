//
//  ViewController.m
//  OpenGL ES01
//
//  Created by plz on 2020/7/24.
//  Copyright © 2020 plz. All rights reserved.
//
// 使用OpenGLES改变试图背景颜色

#import "ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface ViewController () {
    
    EAGLContext *context;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化上下文
    /*
    EAGLContext 是苹果iOS平台下实现OpenGLES 渲染层.
    kEAGLRenderingAPIOpenGLES1 = 1, 固定管线
    kEAGLRenderingAPIOpenGLES2 = 2,
    kEAGLRenderingAPIOpenGLES3 = 3,
    */
    context =[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    //判断context是否创建成功
    if (!context) {
        NSLog(@"Create ES context fialed");
    }
    
    //设置当前上下文 可以创建多个上下文，但当前上下文只有一个
    [EAGLContext setCurrentContext:context];
    
    //获取GLKView
    GLKView *view =(GLKView *)self.view;
    //设置context
    view.context = context;
    
    //设置背景颜色
    glClearColor(1, 0, 0, 1);
    
}


#pragma mark --GLKViewDelegate
//绘制视图的内容
/*
 GLKView对象使其OpenGL ES上下文成为当前上下文，并将其framebuffer绑定为OpenGL ES呈现命令的目标。然后，委托方法应该绘制视图的内容。
*/
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClear(GL_COLOR_BUFFER_BIT);
}

@end
