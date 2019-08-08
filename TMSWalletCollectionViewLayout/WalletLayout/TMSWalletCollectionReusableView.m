//
//  TMSWalletCollectionReusableView.m
//  TMSWalletCollectionViewLayout
//
//  Created by TmmmS on 2019/8/8.
//  Copyright © 2019 TMS. All rights reserved.
//

#import "TMSWalletCollectionReusableView.h"
#import "Masonry.h"

@interface TMSWalletCollectionReusableView ()
@property(nonatomic, strong) UILabel *label;
@end

@implementation TMSWalletCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
        
        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (void)setReusableViewTitle:(NSString *)title {
    
    self.label.text = title;
}

@end
