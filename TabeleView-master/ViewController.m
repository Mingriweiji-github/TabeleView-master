//
//  ViewController.m
//  TabeleView-master
//
//  Created by Mr.Li on 16/4/25.
//  Copyright © 2016年 Mr.Li. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

{
    UITableViewCellEditingStyle    _editingStyle;
    NSMutableArray *_titleArray;
    NSMutableArray *_icoArray;
    NSInteger _index;
}
//设备物理大小
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define IOS_VERSION   [[UIDevice currentDevice].systemVersion floatValue]
@end

@implementation ViewController
//#define kIcoArray @"[@消息,@账号,@版权]"
//#define kTitleArray @[@听筒模式,@播放,@清除缓存]


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    _tableView.delegate =self;
    _tableView.dataSource = self;
    
    
    _tableView.allowsSelectionDuringEditing = YES;//编辑状态可选中
    [self.view addSubview:_tableView];
    NSArray *kIcoArray= @[@"消息",@"账号",@"版权"];
    NSArray *ktitleArr =@[@"听筒模式",@"播放",@"清楚缓存"];
    
    _titleArray = [NSMutableArray arrayWithArray:ktitleArr];
    
    _icoArray = [NSMutableArray arrayWithArray:kIcoArray];
    
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
    add.frame = CGRectMake(kScreenWidth / 2 -50, kScreenHeight / 2 , 50, 20);
    
    add.backgroundColor=[ UIColor orangeColor];
    [add addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:add];
    
    
}
- (void)editBtnClick:(UIButton *)btn
{
    [self addData];
//    [self deleteData];
    
}
#pragma mark dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return _titleArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

 static   NSString *identifier = @"wedfjaslkfd";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.textLabel.text = [NSString stringWithFormat:@"随机值：%u",arc4random() / 2 ];
    }

    
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20+25;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//选中的cell
    
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {//UITableViewCellAccessoryType  cell样式
        //取消前一个的选中，就是单选
        NSIndexPath *_lastIndex = [NSIndexPath indexPathForItem:_index inSection:0];
    
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:_lastIndex];
        
        lastCell.accessoryType = UITableViewCellAccessoryNone;
        
        
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        _index = indexPath.row;//最后保存标记上一个的indexPath
        
    }else{
    
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }


    
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
    
    
}



#pragma mark ---deit delete 可编辑状态---

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [_tableView setEditing:YES animated:YES];
    
}

// 指定哪一行可以编辑 哪行不能编辑

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
#pragma mark 测试cell移动 如不需要请注销
    _editingStyle = UITableViewCellEditingStyleInsert;//测试cell移动
    
    return _editingStyle;
}
// 判断点击按钮的样式 来去做添加 或删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_titleArray removeObjectAtIndex:indexPath.row];
        [_icoArray removeObjectAtIndex:indexPath.row];
        
        
        NSArray *indexPaths = @[indexPath]; // 构建 索引处的行数 的数组
        
        
        // 删除 索引的方法 后面是动画样式
        [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
        
    }
    
    // 添加的操作
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        NSArray *insertIndexPath = @[indexPath];
        
        [_titleArray addObject:insertIndexPath];//操作数据
        
        [_tableView insertRowsAtIndexPaths:insertIndexPath withRowAnimation:(UITableViewRowAnimationRight)];
        
    }
    
}

#pragma mark 删除数据
- (void)deleteData
{
    _editingStyle = UITableViewCellEditingStyleDelete;
    
    BOOL isEditing = self.tableView.isEditing;
    
    [self.tableView setEditing:!isEditing animated:YES];
}

- (void)addData
{
    _editingStyle = UITableViewCellEditingStyleInsert;
    
    BOOL isEditing = self.tableView.isEditing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    [self.tableView reloadData];
}


#pragma mark 移动cell
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark 移动的操作
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    NSUInteger from = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    
    id object = [_titleArray objectAtIndex:from];
    
    [_titleArray removeObjectAtIndex:from];
    
    [_titleArray insertObject:object atIndex:toRow];
    
    
}


@end
