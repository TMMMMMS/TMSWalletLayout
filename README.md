# TMSWalletLayout
UICollectionView实现重叠的Wallet效果

![](https://upload-images.jianshu.io/upload_images/2172432-010735cbba193730.gif?imageMogr2/auto-orient/strip)

1.重叠cell的效果即是布局方式的直接反应

2.可展开可收缩的效果也是对origin属性的直接控制

3.一个collectionView使用多个layout也是间接的在指明各个分区特定的布局方式到底是怎样的

其实自定义layout主要还是在计算每个item在collectionView中的布局，通过类`UICollectionViewLayoutAttributes`记录每个cell具体的布局信息，并存放于一个数组中。包括实现类似于tableView中的分区头、尾试图，也是基于此。

