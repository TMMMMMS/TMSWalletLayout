//
//  TMSCollectionViewLayout.h
//  TestTTT
//
//  Created by TmmmS on 2019/8/8.
//  Copyright © 2019 TMS. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * _Nonnull const TMSCollectionViewSectionHeader;
UIKIT_EXTERN NSString * _Nonnull const TMSCollectionViewSectionFooter;

NS_ASSUME_NONNULL_BEGIN

@protocol TMSCollectionViewLayoutDelegate <NSObject>

@required
/** section header */
- (CGFloat)collectionView:(UICollectionView *)collectionView resuableHeaderViewHeightForIndexPath:(NSIndexPath *)indexPath;
/** section footer */
- (CGFloat)collectionView:(UICollectionView *)collectionView resuableFooterViewHeightForIndexPath:(NSIndexPath *)indexPath;

@end

@interface TMSCollectionViewLayout : UICollectionViewLayout

@property(nonatomic, weak) id<TMSCollectionViewLayoutDelegate> layout_delegate;
/** 左右边距 */
@property(nonatomic, assign) CGFloat padding;
/** 点击item */
- (void)didClickWithIndexPath:(NSIndexPath *)clickIndexPath isExpand:(BOOL)isExpand;
@end

NS_ASSUME_NONNULL_END

