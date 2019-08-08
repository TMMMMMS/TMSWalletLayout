//
//  TMSWalletCollectionViewCell.h
//  TMSWalletCollectionViewLayout
//
//  Created by TmmmS on 2019/8/8.
//  Copyright © 2019 TMS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMSWalletModel : NSObject
@property(nonatomic, assign) BOOL isSelected;
@end

@interface TMSWalletCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong,readonly) TMSWalletModel *model;
- (void)bindModel:(TMSWalletModel *)model;
@end

NS_ASSUME_NONNULL_END
