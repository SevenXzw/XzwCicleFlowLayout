//
//  XzwCicleFlowLayout.m
//  SlowCollectionView
//
//  Created by Vilson on 16/5/11.
//  Copyright © 2016年 demo. All rights reserved.
//

#import "XzwCicleFlowLayout.h"
#import "XzwCollectionViewCell.h"

#define radius 300 // 整体圆的弧度
#define cellRowHeight  IPHONE6WH(200) // 整体圆距离原点的高度

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define IPHONE6WH(x) (([UIScreen mainScreen].bounds.size.width/375.0)*(x))
#define StringObj(objString) [NSString stringWithFormat:@"%@",objString]
@interface XzwCicleFlowLayout ()
///CV大小尺寸
@property (assign,nonatomic)CGSize    cvSize;
///CV距离原点的坐标
@property (assign,nonatomic)CGPoint   cvOrigin;
///CV绝对坐标的中心点
@property (assign,nonatomic)CGPoint   cvCenter;
///取最短边的半径
@property (assign,nonatomic)CGFloat   myRadius;
///第一个区cell的个数
@property (assign,nonatomic)NSInteger cellCount;
@end
@implementation XzwCicleFlowLayout
#pragma mark 最开始调用的方法 (首步调用)
- (void)prepareLayout
{
    [super prepareLayout];
    // 设置一个区所有cell的整体位置（内边距）
    CGFloat insetGap = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, insetGap, 0, insetGap);
    //取CV大小尺寸
    _cvSize = self.collectionView.frame.size;
    //取CV距离原点的坐标
    _cvOrigin = self.collectionView.frame.origin;
    //取CV绝对坐标的中心点
    _cvCenter = CGPointMake(ABS((_cvSize.width-_cvOrigin.x)/2),ABS((_cvSize.height-_cvOrigin.y)/2));
    //取最短边的半径
    _myRadius = MIN(_cvSize.width, _cvSize.height) / 2.5;
    //取第一个区cell的个数
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    //注册DecorationView
    [self registerClass:[XzwCollectionViewCell class] forDecorationViewOfKind:@"ForDecorationViewOfKind"];
}

//自定义布局必须YES   当collectionView 的 bounds发生改变的时候 是否刷新布局(当边界更改时是否更新布局)
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
#pragma mark 布局属性
#pragma mark返回所有(可见cell)的布局属性
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //拿到所有布局属性
    NSArray *array  =  [super  layoutAttributesForElementsInRect:rect];
    NSMutableArray *datas = [NSMutableArray array];
    //遍历数组 得到每一个布局属性
    for (UICollectionViewLayoutAttributes *attributes in array) {
        //拿到单个的布局属性
        //拿到每个item的位置  算出itemCenterX  和collectionCenterX 的一个距离
        CGFloat mainFloat = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2
        - attributes.center.x;
        //
        long rr1 = ABS(radius*radius - mainFloat*mainFloat);
        //
        double hhh = sqrt(rr1);
        CGFloat frameY =  (radius-hhh);
        CGFloat Scale =  (0.2 + (1-frameY/cellRowHeight)*0.8);
        Scale = Scale*Scale;
        Scale = Scale > 1?1:Scale;
        attributes.center = CGPointMake(attributes.center.x,cellRowHeight - frameY- + 44);
        attributes.transform = CGAffineTransformMakeScale(Scale, Scale);
        [datas addObject:attributes];
    }
    
    UICollectionViewLayoutAttributes *attributes;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    //add decorationView
    attributes = [self layoutAttributesForDecorationViewOfKind:@"ForDecorationViewOfKind" atIndexPath:indexPath];
    [datas addObject:attributes];
    
    //     //add first supplementaryView
    //     attributes = [self layoutAttributesForSupplementaryViewOfKind:@"FirstSupplementary" atIndexPath:indexPath];
    //     [datas addObject:attributes];
    //     //add second supplementaryView
    //     attributes = [self layoutAttributesForSupplementaryViewOfKind:@"SecondSupplementary" atIndexPath:indexPath];
    //     [datas addObject:attributes];
    
    return  datas;
}
#pragma mark 返回对应于indexPath的位置的cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;
    //圆周率计算
    attributes.center = CGPointMake(_cvCenter.x + _myRadius * cosf(2 * indexPath.item * M_PI / _cellCount),_cvCenter.y + _myRadius * sinf(2 * indexPath.item * M_PI / _cellCount));
    return attributes;
}
#pragma mark 转屏时调用
//当一个元素被插入collection view时，返回它的初始布局，这里可以加入一些动画效果。
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    //    if([self.indexPathsToAnimate containsObject:itemIndexPath])
    //    {
    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(10,10),M_PI);
    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMidY(self.collectionView.bounds));
    //        [self.indexPathsToAnimate removeObject:itemIndexPath];
    //    }
    
    return attr;
}
#pragma mark Decoration View的布局
#pragma mark 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    attributes.zIndex=100;//z轴
    attributes.frame=CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
    //attributes.center = CGPointMake(_cvSize.width/2, _cvSize.height/2);
    return attributes;
}
#pragma mark Supplementary View的布局
#pragma mark 返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    attributes.size = self.itemSize;
    if([elementKind isEqual:@"FirstSupplementary"])
    {
        attributes.zIndex = 100;
        attributes.center = CGPointMake(_cvSize.width/2, _cvSize.height/2);
    }
    else
    {
        attributes.zIndex = 100;
        attributes.frame=CGRectMake(0, 200, 320, 125);
    }
    
    return attributes;
}
#pragma mark 返回collectionView的内容的尺寸 (第二步调用)
//-(CGSize)collectionViewContentSize{
//    return self.collectionView.frame.size;//会影响水平方向
//}
//#pragma mark 自动对齐到网格(滑动完成后，会来到此方法)
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
//    CGRect targetRect = (CGRect){proposedContentOffset,self.collectionView.frame.size};
//    //获取停下时，可见cell的所有数据
//    NSArray<UICollectionViewLayoutAttributes *>  *tempArray = [super  layoutAttributesForElementsInRect:targetRect];
//
//    CGFloat  gap = 1000,a = 0;
//    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
//    for (int i = 0; i < tempArray.count; i++) {
//        //判断和中心的距离，得到最小的那个
//        if (gap > ABS([tempArray[i] center].x - proposedContentOffset.x - self.collectionView.frame.size.width * 0.5)) {
//
//            gap =  ABS([tempArray[i] center].x - proposedContentOffset.x - self.collectionView.frame.size.width * 0.5);
//
//            a = [tempArray[i] center].x - proposedContentOffset.x - self.collectionView.frame.size.width * 0.5;
//
//        }
//    }
//    //把希望得到的值返回出去
//    CGPoint  point  =CGPointMake(proposedContentOffset.x + a , proposedContentOffset.y);
//
//    //NSLog(@"%@  -point",NSStringFromCGPoint(point));
//
//    return point;
//}

//通知布局，collection view里有元素即将改变，这里可以收集改变的元素indexPath和action类型。
-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for(UICollectionViewUpdateItem *updateItem in updateItems)
    {
        //UICollectionUpdateActionInsert,
        //UICollectionUpdateActionDelete,
        //UICollectionUpdateActionReload,
        //UICollectionUpdateActionMove,
        //UICollectionUpdateActionNone
        
        NSLog(@"before index:%ld,after index:%ld,action:%ld", updateItem.indexPathBeforeUpdate.row,updateItem.indexPathAfterUpdate.row,(long)updateItem.updateAction);
        
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
    //self.indexPathsToAnimate = indexPaths;
    self.accessibilityCustomActions = indexPaths;
}
//插入前，cell在圆心位置，全透明
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    // attributes.center = CGPointMake(_center.x, _center.y);
    return attributes;
}

//删除时，cell在圆心位置，全透明，且只有原来的1/10大
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    //  attributes.center = CGPointMake(_center.x, _center.y);
    attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    return attributes;
}

@end
