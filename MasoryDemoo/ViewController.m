//
//  ViewController.m
//  MasoryDemoo
//
//  Created by Start on 2017/7/25.
//  Copyright © 2017年 het. All rights reserved.
//
// 定义这个常量，就可以不用在开发过程中使用"mas_"前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>
#define  screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
/**label*/
@property(nonatomic,strong)UILabel *testLabel;
/**1.定义一个约束*/
@property(nonatomic,strong)MASConstraint *constranit;
/**textFiled*/
@property(nonatomic,strong)UITextField *textFiled;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     Masonry是基于NSLayoutConstraint等类的封装,也正是我们调用我们在调用- (NSArray *)mas_updateConstraints:(void(^)(MASConstraintMaker *))block的时候也只能更新NSLayoutConstraint中的@property CGFloat constant。
     */
    [self test];
    [self test2];
}
-(void)test
{
    
    //问题1 mas_updateConstraints 自动更新布局约束的是已经存在的约束 满足相同对象,相同约束 不同值。
    //make.size.equalTo(testButton).priority(250);
    //make.size.mas_equalTo(CGSizeMake(200, 200)).priority(300);
    //上面的设置都是设置label的大小，但是这两条不同的约束,因为对象不同。前者是label和button 后者是label所以相当于有两条不同的约束作用于label，显然这两条约束是相互冲突的。
    //https://github.com/BaiduHiDeviOS/iOS-puzzles/issues/5
    //1解决方法: 通过设置优先级来解决这个问题。 priority最高1000默认。
    /*
     原因是，lbl创建时其size约束是make.size.equalTo(self.btn)，但btn被点击时，企图去update size约束为make.size.mas_equalTo(CGSizeMake(200, 100))，然而无法找到existingConstraint，因此实际上是额外添加了一个约束make.size.mas_equalTo(CGSizeMake(200, 100))出现了布局冲突。
    问题2:
       http://www.tuicool.com/articles/JfUVjqm
       被Masonry布局的View一定要与比较view有共同的祖先View;
     
     问题3：
     - (void)updateConstraints方法是用来更新view约束的，它有一个常见的使用场景——批量更新约束。比如你的多个约束是由多个不同的property决定，每次设置property都会直接更新局部约束。这样效率不高。不如直接override- (void)updateConstraints方法，在方面里面对property进行判断，每次设置property的时候调用一下- (void)setNeedsUpdateConstraints。
    
     multipler属性表示约束值为约束对象的乘因数, dividedBy属性表示约束值为约束对象的除因数，可用于设置view的宽高比
     
     
     
     动画属性讲解: http://www.jianshu.com/p/1d1a1165bb04
       1.setNeedsLayout:告知页面需要更新，但是不会立刻开始更新，执行后立刻调用layoutSubViews
       2.layoutIfNeed:告知页面布局立刻更新。所以一般都会和setNeedsLayout一起使用。如果希望立刻生成新的frame需要调用此方法。利用这点
         一般布局动画可以在更新布局后直接使用这个方法让动画生效。
       3. layoutSubViews:系统重写布局。
       4.setNeedUpdateConstraints:告知需要更新约束，但是不会立刻开始
       5.updateConstraints:系统更新约束。
       6 updateConstraintsIfNeeded 立即更新约束,以执行动态变化。
     
     CGAffineTransform介绍:
         CGAffineTransform是一个处理形变的类。其可以控制控件的平移、缩放、旋转,其坐标系统采用的是二维坐标系。
         CGAffineTransformIdentity 特殊地transform属性默认值，可以在形变之后设置该值以还原到最初的状态。
     */
    
   //设置约束的时候 注意事项： 1.先全部设置好约束，2.根据需要进行判断需要将哪个约束需要进行update
    UIButton *testButton = [[UIButton alloc] init];
    [testButton addTarget:self
                   action:@selector(onClick:)
         forControlEvents:UIControlEventTouchUpInside];
    [testButton setTitle:@"点击" forState:UIControlStateNormal];
    [testButton setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:testButton];
    
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(100);
       make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    _testLabel = [[UILabel alloc] init];
    _testLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_testLabel];
    [_testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(testButton.mas_bottom).offset(10);
       self.constranit =  make.size.equalTo(testButton).priority(250);
    }];
    
   

 
    

}



//更新约束
- (void)onClick:(id)sender
{
    /*
     * 另外，masonry提供了三种方法设置约束：
     mas_makeConstraints：新增
     mas_remakeConstraints：移除原来的，增加新的
     mas_updateConstraints：更新
     */
    //第一种方式 通过设置优先级
    /*[self.testLabel setNeedsLayout];
    [UIView animateWithDuration:5 animations:^{
        
        [_testLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 200)).priority(300);
        }];
        [self.testLabel layoutIfNeeded];
    }];*/
    //第二种方式：
    //[self changeConstaints];
    
    
    
}

//更新约束第二种方式
//1.保存一个约束 2. 删除约束 3.重新设置约束
-(void)changeConstaints
{
    [self.constranit uninstall];
    [self.testLabel setNeedsLayout];
    
    [UIView animateWithDuration:5 animations:^{
        [self.testLabel makeConstraints:^(MASConstraintMaker *make) {
            self.constranit =  make.size.mas_equalTo(CGSizeMake(200, 200));
        }];
        [self.testLabel layoutIfNeeded];
        
    }];
}

-(void)test1
{
    //CGAffineTrans的实现
    [UIView animateWithDuration:2 animations:^{
        //http://www.jianshu.com/p/ca7f9bc62429
        //实现以初始位置为基准, 当tx为正值时,会向x轴正方向平移,反之,则向x轴负方向平移;当ty为正值时,会向y轴正方向平移,反之,则向y轴负方向平移
        // _testLabel.transform = CGAffineTransformMakeTranslation(0, 200);
        
        //CGAffineTransformTranslate实现以一个已经存在的形变为基准,在x轴方向上平移x单位,在y轴方向上平移y单位
        //_testLabel.transform = CGAffineTransformTranslate(_testLabel.transform, 0, 40);
        
        //缩放
        // 当sx为正值时,会在x轴方向上缩放x倍,反之,则在缩放的基础上沿着竖直线翻转;当sy为正值时,会在y轴方向上缩放y倍,反之,则在缩放的基础上沿着水平线翻转
        // _testLabel.transform = CGAffineTransformMakeScale(-2, 2);
        
        //CGAffineTransformScale实现以一个已经存在的形变为基准,在x轴方向上缩放x倍,在y轴方向上缩放y倍
        //_testLabel.transform = CGAffineTransformScale(_testLabel.transform, 2, 1);
        
        //旋转
        //实现以初始位置为基准,将坐标系统逆时针旋转angle弧度(弧度=π/180×角度,M_PI弧度代表180角度)
        //注1: 当angle为正值时,逆时针旋转坐标系统,反之顺时针旋转坐标系统
        //注2: 逆时针旋转坐标系统的表现形式为对控件进行顺时针旋转
        //_testLabel.transform = CGAffineTransformMakeRotation(-M_PI);
        
        //CGAffineTransformRotate实现以一个已经存在的形变为基准,将坐标系统逆时针旋转angle弧度(弧度=π/180×角度,M_PI弧度代表180角度)
        //_testLabel.transform = CGAffineTransformRotate(_testLabel.transform, M_PI);
        
    }];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [UIView animateWithDuration:0.25 animations:^{
    //            _testLabel.transform = CGAffineTransformIdentity;
    //        }];
    //    });
    

}

-(void)test2
{
    //http://www.jianshu.com/p/4d38889500df
    UITextField *textFiled = [[UITextField alloc]init];
    [self.view addSubview:textFiled];
    [textFiled makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testLabel.bottom).offset(20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(-10);
        make.height.equalTo(44);
        
    }];
    
    textFiled.borderStyle = UITextBorderStyleLine;
    textFiled.placeholder = @"文本输入框";
    //显示删除按钮的模式
    textFiled.clearButtonMode = UITextFieldViewModeAlways;
    //设置开始编辑时是否删除原有的内容
    textFiled.clearsOnBeginEditing = YES;
    //设置return键返回类型
    textFiled.returnKeyType = UIReturnKeyDone;
    //自定义键盘辅助视图
    UIView *keyBoardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    keyBoardView.backgroundColor = [UIColor orangeColor];
    textFiled.inputAccessoryView = keyBoardView;
    
    //自定义键盘
    UIView *keyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    keyView.backgroundColor = [UIColor redColor];
    textFiled.inputView = keyView;
    
    //添加编辑框的左右视图
    textFiled.leftViewMode = UITextFieldViewModeWhileEditing;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftView.backgroundColor = [UIColor grayColor];
    textFiled.leftView = leftView;
    self.textFiled = textFiled;
    //编辑框的代理方法
    textFiled.delegate = self;
    
    [textFiled addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldDidChange
{
    NSLog(@"dd");
}
//限定只能输入一定长度的字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //string指此时输入的那个字符。textFiled表示此时正在输入的那个输入框 返回YES就是可以改变输入框的值。
    NSLog(@"Range: %@  string:%@",NSStringFromRange(range),string);
    NSString *toStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"toStr: %@",toStr);
    
    //限制只能输入特定的字符
//    NSCharacterSet *cs;
//    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    if (textField == self.textFiled) {
        if ([toStr length] > 5) {
            NSLog(@"长度超过了5");
        }
    }
    return YES;
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//使用来更新View的约束,他有一个常见的使用场景批量更新约束
-(void)updateConstraints
{
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
