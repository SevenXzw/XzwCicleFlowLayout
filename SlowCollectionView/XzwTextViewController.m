//
//  XzwTextViewController.m
//  SlowCollectionView
//
//  Created by Vilson on 16/5/11.
//  Copyright © 2016年 demo. All rights reserved.
//
#import "XzwFlowLayout.h"
#import "XzwCicleFlowLayout.h"
#import "XzwTextViewController.h"
#import "XzwCollectionViewCell.h"
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
@interface XzwTextViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *cycleCV;
@property (nonatomic,strong)UICollectionView *lineCV;
@end

@implementation XzwTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.lineCV];
    [self.view addSubview:self.cycleCV];
}
#pragma mark 懒加载
-(UICollectionView *)lineCV{
    if(!_lineCV){
        XzwFlowLayout *CVFL = [[XzwFlowLayout alloc]init];
        CVFL.minimumLineSpacing = -30;
        CVFL.minimumInteritemSpacing = 0;
        CVFL.itemSize = CGSizeMake(160, 160);
        
        _lineCV = [[UICollectionView alloc]initWithFrame:(CGRect){0,0,SCREEN_WIDTH,(SCREEN_HEIGHT-49)/2} collectionViewLayout:CVFL];
        _lineCV.showsVerticalScrollIndicator = YES;
        _lineCV.showsHorizontalScrollIndicator = YES;
        _lineCV.backgroundColor = [UIColor blackColor];
        _lineCV.delegate = self;
        _lineCV.dataSource = self;
        [_lineCV registerClass:[XzwCollectionViewCell class] forCellWithReuseIdentifier:@"LineCVItem"];
    }return _lineCV;
}
-(UICollectionView *)cycleCV{//注意控制好 itemSize 防止缺省
    if(!_cycleCV){
        //UICollectionViewFlowLayout *  CircularRollingLayout *
        XzwCicleFlowLayout *CVFL = [[XzwCicleFlowLayout alloc]init];
        //每个item间的相邻距离
        CVFL.minimumLineSpacing = -15.0f;
        CVFL.minimumInteritemSpacing = 0.0f;
        //方向
        CVFL.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        /*
         UICollectionViewScrollDirectionVertical,垂直方向
         UICollectionViewScrollDirectionHorizontal,水平方向
         */
        CVFL.itemSize = CGSizeMake(160, 160);
        
        _cycleCV = [[UICollectionView alloc]initWithFrame:(CGRect){0,(SCREEN_HEIGHT-49)/2 + 10,SCREEN_WIDTH,(SCREEN_HEIGHT-49)/2 - 10} collectionViewLayout:CVFL];
        _cycleCV.showsVerticalScrollIndicator = YES;
        _cycleCV.showsHorizontalScrollIndicator = YES;
        _cycleCV.backgroundColor = [UIColor whiteColor];
        _cycleCV.delegate = self;
        _cycleCV.dataSource = self;
        [_cycleCV registerClass:[XzwCollectionViewCell class] forCellWithReuseIdentifier:@"SlowCVItem"];
    }return _cycleCV;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *item;
    if(collectionView == _lineCV){
        XzwCollectionViewCell *lineItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"LineCVItem" forIndexPath:indexPath];
        lineItem.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.item + 1]];
        item = lineItem;
    }else{
        XzwCollectionViewCell *slowItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"SlowCVItem" forIndexPath:indexPath];
        slowItem.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.item + 1]];
        item = slowItem;
    }
    return item;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger coco;
    if(collectionView == _lineCV){
        coco = 20;
    }else
        coco = 20;
    return coco;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint newPoint = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    _cycleCV.contentOffset = _lineCV.contentOffset = newPoint;
}

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
