//
//  TMSCollectionViewLayout.m
//  TestTTT
//
//  Created by TmmmS on 2019/8/8.
//  Copyright © 2019 TMS. All rights reserved.
//

#import "TMSCollectionViewLayout.h"

NSString * const TMSCollectionViewSectionHeader = @"NTCollectionViewSectionHeader";
NSString * const TMSCollectionViewSectionFooter = @"NTCollectionViewSectionFooter";

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

static CGFloat const itemH = 150; // cell高度
static CGFloat const itemInnerInset = 65; // 被遮盖的cell头部留出的距离

@interface TMSCollectionViewLayout ()

@property (strong, nonatomic) NSMutableArray <UICollectionViewLayoutAttributes *>* attrubutesArray;

/** 点击的item */
@property(nonatomic, strong) NSIndexPath *clickIndexPath;
/** 是否展开 */
@property(nonatomic, assign) BOOL isExpand;
@end

@implementation TMSCollectionViewLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    
    self.attrubutesArray = [NSMutableArray array];
    
    NSInteger section = [self.collectionView numberOfSections];
    
    for (NSInteger i = 0; i < section; i++) {
        
        NSInteger itemsCount = [self.collectionView numberOfItemsInSection:i];
        
        UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:TMSCollectionViewSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        
        if (headerAttributes) {
            [self.attrubutesArray addObject:headerAttributes];
        }
        
        for (NSInteger j = 0; j < itemsCount; j++) {
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            UICollectionViewLayoutAttributes * attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrubutesArray addObject:attributes];
        }
        
        UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:TMSCollectionViewSectionFooter atIndexPath:[NSIndexPath indexPathForRow:itemsCount - 1 inSection:i]];
        
        if (footerAttributes) {
            [self.attrubutesArray addObject:footerAttributes];
        }
    }
    
}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return YES;
//}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    UICollectionViewLayoutAttributes *lastAttributes = self.attrubutesArray.lastObject;
    
    attribute.zIndex = indexPath.item * 2;
    
    CGRect frame;
    frame.size = CGSizeMake(ScreenWidth - 2*self.padding, itemH);
    
    CGFloat offfsetY = indexPath.item == 0 ? 0 : itemInnerInset;
    CGFloat expandH = (self.isExpand && self.clickIndexPath && self.clickIndexPath.section == indexPath.section && self.clickIndexPath.item + 1 == indexPath.item) ? -10 : offfsetY;
    
    frame.origin = CGPointMake(self.padding, CGRectGetMaxY(lastAttributes.frame) - expandH);
    
    attribute.frame = frame;
    
    return attribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    UICollectionViewLayoutAttributes *lastAttributes = self.attrubutesArray.lastObject;
    
    CGRect frame;
    
    if([elementKind isEqual:TMSCollectionViewSectionHeader]){
        
        CGFloat headerViewH = [self.layout_delegate collectionView:self.collectionView resuableHeaderViewHeightForIndexPath:indexPath];
        
        if (headerViewH <= 0) {
            return nil;
        }
        
        frame.size = CGSizeMake(ScreenWidth, headerViewH);
        
    } else {
        
        CGFloat footerViewH = [self.layout_delegate collectionView:self.collectionView resuableFooterViewHeightForIndexPath:indexPath];
        
        if (footerViewH <= 0) {
            return nil;
        }
        
        frame.size = CGSizeMake(ScreenWidth, footerViewH);
        
    }
    frame.origin = CGPointMake(0, CGRectGetMaxY(lastAttributes.frame));
    
    attributes.frame = frame;
    
    return attributes;
}

- (CGSize)collectionViewContentSize {
    
    UICollectionViewLayoutAttributes *attribute = self.attrubutesArray.lastObject;
    
    CGFloat safeAreaBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeAreaBottom = self.collectionView.safeAreaInsets.bottom;
    }
    
    return CGSizeMake(ScreenWidth, CGRectGetMaxY(attribute.frame) + 5 + safeAreaBottom);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attrubutesArray;
}

- (void)didClickWithIndexPath:(NSIndexPath *)clickIndexPath isExpand:(BOOL)isExpand {
    
    self.isExpand = isExpand;
    self.clickIndexPath = self.isExpand ? clickIndexPath : nil;
    
    [UIView transitionWithView:self.collectionView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self invalidateLayout];
    } completion:nil];
    
    // 使用该方法，最底部的item会闪动
//        [UIView animateWithDuration:2 animations:^{
//            [self invalidateLayout];
//        }];
    
    
}

@end
