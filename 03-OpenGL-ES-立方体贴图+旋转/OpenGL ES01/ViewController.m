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

@interface ViewController () {
    
    EAGLContext *context;
    GLKBaseEffect *cEffect;
    int _angle;
    int _time;
    bool _flag;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _time =3;
    _flag=true;
    
    //1. OpenGL ES 相关初始化
    [self setUpConfig];
    
    //2. 加载顶点/纹理坐标数据
    [self setUpVertexData];
    
    //3.纹理读取数据
    [self setupTexture];
}

//1.
-(void)setUpConfig{
    
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
    view.context = context;
    
    //配置视图创建的渲染缓冲区
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    //设置背景颜色
    glClearColor(1, 0, 0, 1);
}

//2.
-(void)setUpVertexData {
    
    //设置顶点数组（顶点坐标，纹理坐标）
    /*
    纹理坐标系取值范围[0,1];原点是左下角(0,0);
    故而(0,0)是纹理图像的左下角, 点(1,1)是右上角.
    */
   GLfloat vertexData[] = {
       -0.5f, -0.5f, -0.5f, 0.0f, 0.0f,
       0.5f, -0.5f, -0.5f, 1.0f, 0.0f,
       0.5f, 0.5f, -0.5f, 1.0f, 1.0f,
       0.5f, 0.5f, -0.5f, 1.0f, 1.0f,
       -0.5f, 0.5f, -0.5f, 0.0f, 1.0f,
       -0.5f, -0.5f, -0.5f, 0.0f, 0.0f,
       
       -0.5f, -0.5f, 0.5f, 0.0f, 0.0f,
       0.5f, -0.5f, 0.5f, 1.0f, 0.0f,
       0.5f, 0.5f, 0.5f, 1.0f, 1.0f,
       0.5f, 0.5f, 0.5f, 1.0f, 1.0f,
       -0.5f, 0.5f, 0.5f, 0.0f, 1.0f,
       -0.5f, -0.5f, 0.5f, 0.0f, 0.0f,
       
       -0.5f, 0.5f, 0.5f, 1.0f, 0.0f,
       -0.5f, 0.5f, -0.5f, 1.0f, 1.0f,
       -0.5f, -0.5f, -0.5f, 0.0f, 1.0f,
       -0.5f, -0.5f, -0.5f, 0.0f, 1.0f,
       -0.5f, -0.5f, 0.5f, 0.0f, 0.0f,
       -0.5f, 0.5f, 0.5f, 1.0f, 0.0f,
       
       0.5f, 0.5f, 0.5f, 1.0f, 0.0f,
       0.5f, 0.5f, -0.5f, 1.0f, 1.0f,
       0.5f, -0.5f, -0.5f, 0.0f, 1.0f,
       0.5f, -0.5f, -0.5f, 0.0f, 1.0f,
       0.5f, -0.5f, 0.5f, 0.0f, 0.0f,
       0.5f, 0.5f, 0.5f, 1.0f, 0.0f,
       
       -0.5f, -0.5f, -0.5f, 0.0f, 1.0f,
       0.5f, -0.5f, -0.5f, 1.0f, 1.0f,
       0.5f, -0.5f, 0.5f, 1.0f, 0.0f,
       0.5f, -0.5f, 0.5f, 1.0f, 0.0f,
       -0.5f, -0.5f, 0.5f, 0.0f, 0.0f,
       -0.5f, -0.5f, -0.5f, 0.0f, 1.0f,
       
       -0.5f, 0.5f, -0.5f, 0.0f, 1.0f,
       0.5f, 0.5f, -0.5f, 1.0f, 1.0f,
       0.5f, 0.5f, 0.5f, 1.0f, 0.0f,
       0.5f, 0.5f, 0.5f, 1.0f, 0.0f,
       -0.5f, 0.5f, 0.5f, 0.0f, 0.0f,
       -0.5f, 0.5f, -0.5f, 0.0f, 1.0f
   };
    
    /*
    顶点数组: 开发者可以选择设定函数指针，在调用绘制方法的时候，直接由内存传入顶点数据，也就是说这部分数据之前是存储在内存当中的，被称为顶点数组
    
    顶点缓存区: 性能更高的做法是，提前分配一块显存，将顶点数据预先传入到显存当中。这部分的显存，就被称为顶点缓冲区
    */
    
    //开辟顶点缓存区
    //1.创建顶点缓存区标识符ID
    GLuint bufferID;

    glGenBuffers(1, &bufferID);
    
    //2. 绑定顶点缓存区（明确作用）
    glBindBuffer(GL_ARRAY_BUFFER, bufferID);

    //。将顶点数组数据copy到顶点缓存区（gpu显存）
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    
    //顶点坐标数据
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    
    //纹理坐标数据
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
    
    
}

//3.
-(void)setupTexture{
    //图片路径
    NSString *filePath =[[NSBundle mainBundle]pathForResource:@"james" ofType:@"jpeg"];
    
    //设置纹理参数
    //纹理坐标原点是左下角，但图片显示原点是左上角
    NSDictionary *options =[NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    
    GLKTextureInfo *textureInfo =[GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    //使用苹果GLKit提供的GLKBaseEffect 完成着色器工作（顶点/片元）
    cEffect =[[GLKBaseEffect alloc]init];
    cEffect.texture2d0.enabled=GL_TRUE;
    cEffect.texture2d0.name=textureInfo.name;
    
    // 透视投影矩阵
    CGFloat aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(55), aspect, 0.1, 100.0);
    cEffect.transform.projectionMatrix = projectionMatrix;
        
    GLKMatrix4 modelviewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, -4.0);
    cEffect.transform.modelviewMatrix = modelviewMatrix;
    
}

//4.
-(void)updateEffect{

    /*
     //立方体旋转先快后慢
    if (_time < 100 ||_time >0){
        if (_flag){
            _time++;
        }else{
            _time--;
        }
    }
    if (_time == 100 || _time == 0){
        _flag = !_flag;
    }
     */
        
    _angle =(_angle +_time)%360;
    GLKMatrix4 modelViewMatrix =GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, -4.0);
    modelViewMatrix =GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_angle), 0.5, 0.5, 0.5);
    cEffect.transform.modelviewMatrix =modelViewMatrix;
}

#pragma mark --GLKViewDelegate
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_DEPTH_TEST);
    
    //旋转
    [self updateEffect];
    
    [cEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 48);
    
}

@end
