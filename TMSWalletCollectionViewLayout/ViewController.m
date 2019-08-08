//
//  ViewController.m
//  TMSWalletCollectionViewLayout
//
//  Created by TmmmS on 2019/8/8.
//  Copyright © 2019 TMS. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "TMSCollectionViewLayout.h"
#import "TMSWalletCollectionViewCell.h"
#import "TMSWalletCollectionReusableView.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, TMSCollectionViewLayoutDelegate>
@property(nonatomic, strong) TMSCollectionViewLayout *tms_layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view);
        }
    }];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self handleDatas];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView resuableHeaderViewHeightForIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section == 0 ? 30 : 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView resuableFooterViewHeightForIndexPath:(NSIndexPath *)indexPath {
    
    return 30;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.dataSource[section];
    return sectionArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    TMSWalletCollectionReusableView *reusableView = nil;
    
    reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(TMSWalletCollectionReusableView.class) forIndexPath:indexPath];
    
    if (kind == TMSCollectionViewSectionHeader) {
        
        [reusableView setReusableViewTitle:[NSString stringWithFormat:@"Section Header:%zd-%zd", indexPath.section, indexPath.item]];
    }
    
    if (kind == TMSCollectionViewSectionFooter) {
        
        [reusableView setReusableViewTitle:[NSString stringWithFormat:@"Section Footer:%zd-%zd", indexPath.section, indexPath.item]];
    }
    
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TMSWalletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(TMSWalletCollectionViewCell.class) forIndexPath:indexPath];
    
    TMSWalletModel *model = self.dataSource[indexPath.section][indexPath.item];
    cell.titleLabel.text = [NSString stringWithFormat:@"indexPath:%zd--%zd selected:%@", indexPath.section, indexPath.row , model.isSelected ? @"YES" : @"NO"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.dataSource enumerateObjectsUsingBlock:^(NSArray *sectionArray, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [sectionArray enumerateObjectsUsingBlock:^(TMSWalletModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (indexPath.item != idx) {
                model.isSelected = NO;
            } else {
                model.isSelected = !model.isSelected;
                if (indexPath.item != sectionArray.count - 1) {
                    [self.tms_layout didClickWithIndexPath:indexPath isExpand:model.isSelected];
                } else {
                    [self.tms_layout didClickWithIndexPath:indexPath isExpand:NO];
                }
            }
        }];
    }];
    
    [collectionView reloadData];
    
}

- (void)handleDatas {
    
    self.dataSource = [NSMutableArray array];
    for (NSInteger i = 0; i < 2; i ++) {
        
        NSMutableArray *tempDataSource = [NSMutableArray array];
        
        NSInteger maxCount = i == 0 ? 20 : 6;
        for (NSInteger j = 0 ; j < maxCount; j++) {
            TMSWalletModel *model = [[TMSWalletModel alloc] init];
            [tempDataSource addObject:model];
        }
        [self.dataSource addObject:tempDataSource.copy];
    }
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        self.tms_layout = [[TMSCollectionViewLayout alloc] init];
        self.tms_layout.padding = 15;
        self.tms_layout.layout_delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.tms_layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[TMSWalletCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(TMSWalletCollectionViewCell.class)];
        [_collectionView registerClass:[TMSWalletCollectionReusableView class] forSupplementaryViewOfKind:TMSCollectionViewSectionHeader withReuseIdentifier:NSStringFromClass(TMSWalletCollectionReusableView.class)];
        [_collectionView registerClass:[TMSWalletCollectionReusableView class] forSupplementaryViewOfKind:TMSCollectionViewSectionFooter withReuseIdentifier:NSStringFromClass(TMSWalletCollectionReusableView.class)];
        
    }
    return _collectionView;
}

@end
