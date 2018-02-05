//
//  KKFlowLayout.m
//  minsu
//
//  Created by 竹叶 on 2017/12/5.
//  Copyright © 2017年 郑州竹叶网络科技有限公司. All rights reserved.
//

#import "KKFlowLayout.h"

@implementation KKFlowLayout
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    // 获取当前滚动区域
    CGFloat offsetX = self.collectionView.contentOffset.x;
    // collection宽度
    CGFloat collectionW = self.collectionView.bounds.size.width;
    
    // 获取当前显示区域
    CGRect visableRect = CGRectMake(offsetX, 0, collectionW, self.collectionView.bounds.size.height);
    
    // 获取当前显示区域的所有cell
    NSArray *visableAtt = [super layoutAttributesForElementsInRect:visableRect];
    
    // 遍历显示cell布局，判断与中心点的距离
    for (UICollectionViewLayoutAttributes *attrs in visableAtt) {
        
        CGFloat delta = fabs((attrs.center.x - offsetX) - collectionW * 0.5) ;
        
        CGFloat scale = 1 - delta /collectionW * 0.1;
        
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
        
    }
    
    return visableAtt;
}

// Invalidate:刷新
// 是否允许刷新布局，当bounds改变的时候
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}



// 调用时刻：拖动完成时候
// 方法：拖动完成时候的滚动区域
// 控制最终显示区域
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    
    // collection宽度
    CGFloat collectionW = self.collectionView.bounds.size.width;
    
    CGFloat offsetX = proposedContentOffset.x;
    
    // 获取显示的cell布局
    // 获取当前显示区域
    CGRect visableRect = CGRectMake(offsetX, 0, collectionW, self.collectionView.bounds.size.height);
    
    // 获取当前显示区域的所有cell
    NSArray *visableAtt = [super layoutAttributesForElementsInRect:visableRect];
    
    // 记录最小中心点位置
    CGFloat minDelta = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attrs in visableAtt) {
        
        // 计算离中心点的距离
        CGFloat delta = fabs((attrs.center.x - offsetX) - collectionW * 0.5) ;
        
        // 获取上一个
        if (delta < fabs(minDelta)) { // 比较不需要关心负数
            
            // 有比较小间距的cell
            // 赋值需要
            minDelta = (attrs.center.x - offsetX) - collectionW * 0.5;
            
        }
    }
    
    proposedContentOffset.x += minDelta;
    // -0，就不会移动
    // 恢复为0
    
    if (proposedContentOffset.x <= 0) {
        proposedContentOffset.x = 0;
    }
    
    return proposedContentOffset;
}
@end
