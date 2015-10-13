//
//  SankeViewController.m
//  snake test
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//
#define KfirstViewX _firstView.frame.origin.x
#define KfirstViewY _firstView.frame.origin.y
#import "SankeViewController.h"

@interface SankeViewController ()
{
    NSMutableArray *_allViews; //存储所有的视图
    NSMutableArray *_newViews;//存储新创建出来的视图
    NSTimer *_timer;
    BOOL _isDid;  //判断是否是第一次点击 开始按钮
    
    NSUInteger _num; //纪录当前是第几块方块
    UIView *_view1;
    UIView *_view2;
    UIView *_view3;
}
@property (weak, nonatomic) IBOutlet UIView *buttomView; //游戏运行界面视图
@property (weak, nonatomic) IBOutlet UIView *firstView;  //贪吃蛇 蛇头
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet UIButton *upButton;  //上 按钮
@property (weak, nonatomic) IBOutlet UIButton *downButton;// 下 按钮
@property (weak, nonatomic) IBOutlet UIButton *leftButton;// 左 按钮
@property (weak, nonatomic) IBOutlet UIButton *rightButton;// 右 按钮
@property (weak, nonatomic) IBOutlet UIButton *startButton;// 开始 按钮
@property (weak, nonatomic) IBOutlet UIButton *replay;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation SankeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _num = 0;
    _downButton.enabled = NO;
    _upButton.enabled = NO;
    _leftButton.enabled = NO;
    _rightButton.enabled = NO;
    
    _newViews = [[NSMutableArray alloc] init];
    _allViews = [[NSMutableArray alloc] init];
    [_allViews addObject:_firstView];
    [_allViews addObject:_secondView];
    [_allViews addObject:_thirdView];
    

}

//状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return 1;
}



//创建方块
- (void)_creatView
{
    
    int x = (arc4random()%20);
    int y = (arc4random()%25);
    CGFloat red = (CGFloat)(arc4random()%255)/255;
    CGFloat green = (CGFloat)(arc4random()%255)/255;
    CGFloat blue = (CGFloat)(arc4random()%255)/255;
    //获取随机值 创建 方块
    UIView *otherView = [[UIView alloc] init];
    otherView.frame = CGRectMake(x*15, y*15, 15, 15);
    otherView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    //如果 创建的方块和贪吃蛇重叠了 重新创建
    for (int i = 0; i < _allViews.count ; i++) {
        UIView *view = _allViews[i];
        if (otherView.frame.origin.y == view.frame.origin.y && otherView.frame.origin.x == view.frame.origin.x) {
            [self _creatView];
        }
    }
    //将方块添加到 游戏视图
    [_buttomView addSubview:otherView];
    //将新创建的方块加入到 一个数组中
    [_newViews addObject:otherView];
    //[_allViews addObject:otherView];
    _num ++;
    
    
}




# pragma mark - 按钮事件
//上按钮
- (IBAction)upButton:(UIButton *)sender {
    //[self viewMeet];
    [self frameChange];
    _firstView.frame = CGRectMake(KfirstViewX, KfirstViewY-15, 15, 15);
    _upButton.selected = YES;
    _downButton.selected = NO;
    _leftButton.selected = NO;
    _rightButton.selected = NO;
    _upButton.enabled = NO;
    _downButton.enabled = NO;
    _leftButton.enabled = YES;
    _rightButton.enabled = YES;

    
    [self viewMeetButtonUp];
    [self viewOtherMeet];
}
//下按钮
- (IBAction)downButton:(UIButton *)sender {
    //[self viewMeet];
    [self frameChange];
    _firstView.frame = CGRectMake(KfirstViewX, KfirstViewY+15, 15, 15);
    _upButton.selected = NO;
    _downButton.selected = YES;
    _leftButton.selected = NO;
    _rightButton.selected = NO;
    
    _upButton.enabled = NO;
    _downButton.enabled = NO;
    _leftButton.enabled = YES;
    _rightButton.enabled = YES;
    
    [self viewMeetButtonDown];
    [self viewOtherMeet];
}
//左按钮
- (IBAction)leftButton:(UIButton *)sender {
    //[self viewMeet];
    [self frameChange];
    _firstView.frame = CGRectMake(KfirstViewX-15, KfirstViewY, 15, 15);
    _upButton.selected = NO;
    _downButton.selected = NO;
    _leftButton.selected = YES;
    _rightButton.selected = NO;
    
    _upButton.enabled = YES;
    _downButton.enabled = YES;
    _leftButton.enabled = NO;
    _rightButton.enabled = NO;
   
    [self viewMeetButtonLeft];
    [self viewOtherMeet];
}
//右按钮
- (IBAction)rightButton:(UIButton *)sender {
    //[self viewMeet];
    [self frameChange];
    _firstView.frame = CGRectMake(KfirstViewX+15, KfirstViewY, 15, 15);
    _upButton.selected = NO;
    _downButton.selected = NO;
    _leftButton.selected = NO;
    _rightButton.selected = YES;
    
    _upButton.enabled = YES;
    _downButton.enabled = YES;
    _leftButton.enabled = NO;
    _rightButton.enabled = NO;

    [self viewMeetButtonRight];
    [self viewOtherMeet];
}
//开始按钮
- (IBAction)startButton:(UIButton *)sender {
    //如果第一点开始按钮 创建一个方块
    if(_isDid == NO)
    {
        _leftButton.enabled = NO;
        _rightButton.enabled = NO;
        _upButton.enabled = YES;
        _downButton.enabled = YES;
        [self _creatView];
        _isDid = YES;
    }
    //开始按钮被选中 开启定时器
    if (sender.selected==NO) {
    
        _timer=[NSTimer scheduledTimerWithTimeInterval:1
                
                                                target:self
                                              selector:@selector(viewAction:)
                                              userInfo:nil
                                               repeats:YES];
    }
    //否则 关闭定时器
    else
    {
        [_timer invalidate];
    }
    sender.selected = !sender.selected;
}
//重新开始按钮
- (IBAction)replayButton:(UIButton *)sender {
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
   /*
    NSArray *ary = [[NSBundle mainBundle] loadNibNamed:@"SankeViewController" owner:nil options:nil];
    UIView *view = [ary lastObject];
    [self.view addSubview:view];
    */
    [self loadView];
    [_timer invalidate];
    _isDid = NO;
    _startButton.selected = NO;
    
    _num = 0;
    _downButton.enabled = NO;
    _upButton.enabled = NO;
    _leftButton.enabled = NO;
    _rightButton.enabled = NO;
    
    _newViews = [[NSMutableArray alloc] init];
    _allViews = [[NSMutableArray alloc] init];
    [_allViews addObject:_firstView];
    [_allViews addObject:_secondView];
    [_allViews addObject:_thirdView];
    
    
    
    
    
    
    
}




#pragma mark - 定时器事件
- (void)viewAction:(NSTimer *)timer
{
    
    
    //NSLog(@"%i %i %i %i",_upButton.selected,_downButton.selected,_leftButton.selected,_rightButton.selected);
    
    //判断有没有死亡
    [self viewMeet];
    // 运行动画
    [UIView animateWithDuration:0.5 animations:^{
        //如果 上 按钮被选中 执行以下操作
        if (_upButton.selected == YES) {
            [self frameChange];
            _firstView.frame=CGRectMake(KfirstViewX, KfirstViewY-15, 15, 15);
            [self viewRunEachOther];
            //[self viewMeetBottom];
            [self viewMeetButtonUp];
            //[self viewMeetButtonLeft];
            //[self viewMeetButtonRight];
            
            _scoreLabel.text = [NSString stringWithFormat:@"%li", _num-1];
            return ;
        }
        //如果 下 按钮被选中 执行以下操作
        else if (_downButton.selected == YES) {
            [self frameChange];
            _firstView.frame=CGRectMake(KfirstViewX, KfirstViewY+15, 15, 15);
            [self viewRunEachOther];
            //[self viewMeetTop];
            //[self viewMeetButtonLeft];
            //[self viewMeetButtonRight];
            [self viewMeetButtonDown];
            _scoreLabel.text = [NSString stringWithFormat:@"%li", _num-1];

            return;
        }
        //如果 左 按钮被选中 执行以下操作
        else if (_leftButton.selected == YES){
            [self frameChange];
            _firstView.frame=CGRectMake(KfirstViewX-15, KfirstViewY, 15, 15);
            [self viewRunEachOther];
            //[self viewMeetLetf];
            //[self viewMeetButtonUp];
            [self viewMeetButtonLeft];
            //[self viewMeetButtonDown];
            _scoreLabel.text = [NSString stringWithFormat:@"%li", _num-1];

            return;
        }
        //如果 右 按钮被选中 执行以下操作
        else if (_rightButton.selected == YES){
            [self frameChange];
            _firstView.frame=CGRectMake(KfirstViewX+15, KfirstViewY, 15, 15);
            [self viewRunEachOther];
            //[self viewMeetRight];
            //[self viewMeetButtonUp];
            [self viewMeetButtonRight];
            //[self viewMeetButtonDown];
            _scoreLabel.text = [NSString stringWithFormat:@"%li", _num-1];

            return;
        }
        [self frameChange];
        _firstView.frame=CGRectMake(KfirstViewX+15, KfirstViewY, 15, 15);

    }];
}


#pragma mark - 贪吃蛇事件
//创建一个方法 使后一个view的frame为前一个view的frame
- (void)frameChange
{

    
    for (int i =(int) _allViews.count-1; i>=1; i--) {
        
        UIView *view = _allViews[i];
        UIView *lastView = _allViews[i-1];
       
        view.frame = lastView.frame;
    }
    
}

//方块撞墙
- (void)viewMeet
{
//    UIView *view = _newViews[_num - 1];
//    CGPoint presentViewPoint = view.frame.origin;
//    CGPoint firstUpPoint = {KfirstViewX,KfirstViewY};
    //判断是否撞墙
    if ((KfirstViewX+15<=315 & KfirstViewX>=0)&&(KfirstViewY+15>0 & KfirstViewY+15<=390)) {
        
 
    }
    else
    {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 100, 320, 190);
        label.backgroundColor = [UIColor magentaColor];
        [_buttomView addSubview:label];
        label.text = @"游戏结束";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:50];
        _startButton.enabled = NO;
        _leftButton.enabled = NO;
        _rightButton.enabled = NO;
        _upButton.enabled = NO;
        _downButton.enabled = NO;
        [_timer invalidate];
    }

    
}

//方块相遇
- (void)viewRunEachOther
{
    for (int i = 1; i < _allViews.count; i ++) {
        UIView *view = _allViews[i];
        if (KfirstViewX == view.frame.origin.x && KfirstViewY == view
            .frame.origin.y) {
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(0, 100, 320, 190);
            label.backgroundColor = [UIColor magentaColor];
            [_buttomView addSubview:label];
            label.text = @"游戏结束";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:50];
            _startButton.enabled = NO;
            _leftButton.enabled = NO;
            _rightButton.enabled = NO;
            _upButton.enabled = NO;
            _downButton.enabled = NO;
            [_timer invalidate];
        }
    }
}


#pragma mark - 吃
//方块相邻按 上 按钮
- (void)viewMeetButtonUp
{
    UIView *view = _newViews[_num - 1];
    CGPoint presentViewPoint = view.frame.origin;
    CGPoint firstUpPoint = {KfirstViewX,KfirstViewY};
    if (firstUpPoint.x == presentViewPoint.x && firstUpPoint.y - 15 == presentViewPoint.y) {
        [_allViews addObject: _newViews[_num - 1]];
        [self performSelector:@selector(_creatView) withObject:nil afterDelay:1];
    }
}

//方块相邻按 下 按钮
- (void)viewMeetButtonDown
{
    UIView *view = _newViews[_num - 1];
    CGPoint presentViewPoint = view.frame.origin;
    CGPoint firstUpPoint = {KfirstViewX,KfirstViewY};
    if (firstUpPoint.x == presentViewPoint.x && firstUpPoint.y + 15 == presentViewPoint.y) {
        [_allViews addObject: _newViews[_num - 1]];
        [self performSelector:@selector(_creatView) withObject:nil afterDelay:1];
    }
}

//方块相邻按 左 按钮
- (void)viewMeetButtonLeft
{
    UIView *view = _newViews[_num - 1];
    CGPoint presentViewPoint = view.frame.origin;
    CGPoint firstUpPoint = {KfirstViewX,KfirstViewY};
    if (firstUpPoint.x - 15 == presentViewPoint.x && firstUpPoint.y == presentViewPoint.y) {
        [_allViews addObject: _newViews[_num - 1]];
        [self performSelector:@selector(_creatView) withObject:nil afterDelay:1];
    }
}

//方块相邻按 右 按钮
- (void)viewMeetButtonRight
{
    UIView *view = _newViews[_num - 1];
    CGPoint presentViewPoint = view.frame.origin;
    CGPoint firstUpPoint = {KfirstViewX,KfirstViewY};
    if (firstUpPoint.x + 15 == presentViewPoint.x && firstUpPoint.y == presentViewPoint.y) {
        [_allViews addObject: _newViews[_num - 1]];
        [self performSelector:@selector(_creatView) withObject:nil afterDelay:1];
    }
}

- (void)viewOtherMeet
{
    UIView *view = _newViews[_num - 1];
    CGPoint presentViewPoint = view.frame.origin;
    CGPoint firstUpPoint = {KfirstViewX,KfirstViewY};
    if (firstUpPoint.x == presentViewPoint.x && firstUpPoint.y == presentViewPoint.y) {
        [_allViews addObject: _newViews[_num - 1]];
        [self performSelector:@selector(_creatView) withObject:nil afterDelay:1];
    }
}






//------------------------------------------------------------
/*
//上相遇
- (void)viewMeetTop
{
    UIView *view = _newViews[_num - 1];
    CGPoint presentViewPoint = view.frame.origin;
    CGPoint firstUpPoint = {KfirstViewX,KfirstViewY};
    if (firstUpPoint.x == presentViewPoint.x && firstUpPoint.y+15 == presentViewPoint.y) {
        [_allViews addObject: _newViews[_num - 1]];
        [self performSelector:@selector(_creatView) withObject:nil afterDelay:1];
    }
}
//下相遇
- (void)viewMeetBottom
{
    UIView *view = _newViews[_num - 1];
    CGPoint presentViewPoint = view.frame.origin;
    CGPoint firstUpPoint = {KfirstViewX,KfirstViewY};
    if (firstUpPoint.x == presentViewPoint.x && firstUpPoint.y ==presentViewPoint.y+15) {
        [_allViews addObject: _newViews[_num - 1]];
        [self performSelector:@selector(_creatView) withObject:nil afterDelay:1];
    }
}
//左相遇
- (void)viewMeetLetf
{
    UIView *view = _newViews[_num - 1];
    CGPoint presentViewPoint = view.frame.origin;
    CGPoint firstUpPoint = {KfirstViewX,KfirstViewY};
    if (firstUpPoint.x - 15 == presentViewPoint.x && firstUpPoint.y == presentViewPoint.y) {
        [_allViews addObject: _newViews[_num - 1]];
        [self performSelector:@selector(_creatView) withObject:nil afterDelay:1];
        return;
    }

}
//右相遇
- (void)viewMeetRight
{
    UIView *view = _newViews[_num - 1];
    CGPoint presentViewPoint = view.frame.origin;
    CGPoint firstUpPoint = {KfirstViewX,KfirstViewY};
    if (firstUpPoint.x + 15 == presentViewPoint.x && firstUpPoint.y == presentViewPoint.y) {
        [_allViews addObject: _newViews[_num - 1]];
        [self performSelector:@selector(_creatView) withObject:nil afterDelay:1];
    }
}
*/
//------------------------------------------------------------
//方块相邻按 上 按钮














- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
