//
//  YLCollectionView.h
//  macos-demo
//
//  Created by 魏宇龙 on 2023/5/12.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@class YLCollectionView;

// dataSource

typedef NSInteger (^YLCollectionViewNumberOfSectionsHandler)(NSCollectionView *collectionView);
typedef NSInteger (^YLCollectionViewNumberOfItemsInSectionHandler)(NSCollectionView *collectionView, NSInteger section);
typedef NSCollectionViewItem * _Nonnull (^YLCollectionViewItemHandler)(NSCollectionView *collectionView, NSIndexPath *indexPath);
typedef NSView * _Nullable (^YLCollectionViewSupplementaryElementHandler)(NSCollectionView *collectionView, NSCollectionViewSupplementaryElementKind kind, NSIndexPath *indexPath);

// delegate

typedef NSSet<NSIndexPath *> * _Nonnull (^YLCollectionViewShouldSelectItemsHandler)(NSCollectionView *collectionView, NSSet<NSIndexPath *> *indexPaths);
typedef void (^YLCollectionViewDidSelectItemsHandler)(NSCollectionView *collectionView, NSSet<NSIndexPath *> *indexPaths);
typedef NSSet<NSIndexPath *> * _Nonnull (^YLCollectionViewShouldDeselectItemsHandler)(NSCollectionView *collectionView, NSSet<NSIndexPath *> *indexPaths);
typedef void (^YLCollectionViewDidDeselectItemsHandler)(NSCollectionView *collectionView, NSSet<NSIndexPath *> *indexPaths);
typedef void (^YLCollectionViewScrollHandler)(NSScrollView *scrollView, NSCollectionView *collectionView);

// drag

typedef BOOL (^YLCollectionViewCanDragItemsHandler)(NSCollectionView *collectionView, NSSet<NSIndexPath *> *indexPaths, NSEvent *event);
typedef id<NSPasteboardWriting> _Nullable (^YLCollectionViewPastedboardWriterForItemHandler)(NSCollectionView *collectionView, NSIndexPath *indexPath);
typedef NSDragOperation (^YLCollectionViewValidateDropHandler)(NSCollectionView *collectionView, id<NSDraggingInfo> draggingInfo, NSIndexPath * _Nonnull __autoreleasing * _Nonnull proposedDropIndexPath, NSCollectionViewDropOperation *proposedDropOperation);
typedef BOOL (^YLCollectionViewAcceptDropHandler)(NSCollectionView *collectionView, id<NSDraggingInfo> draggingInfo, NSIndexPath * indexPath, NSCollectionViewDropOperation dropOperation);


// layout

typedef NSSize (^YLCollectionViewItemSizeHandler)(NSCollectionView *collectionView, NSIndexPath *indexPath);
typedef NSEdgeInsets (^YLCollectionViewSectionInsetHandler)(NSCollectionView *collectionView, NSInteger section);
typedef CGFloat (^YLCollectionViewMinLineSpacingHandler)(NSCollectionView *collectionView, NSInteger section);
typedef CGFloat (^YLCollectionViewMinItemSpacingHandler)(NSCollectionView *collectionView, NSInteger section);
typedef NSSize (^YLCollectionViewHeaderSizeHandler)(NSCollectionView *collectionView, NSInteger section);
typedef NSSize (^YLCollectionViewFooterSizeHandler)(NSCollectionView *collectionView, NSInteger section);

@interface YLCollectionView : NSView

@property (nonatomic, readonly) NSCollectionView *collectionView;
@property (nonatomic, readonly) NSScrollView *scrollView;


#pragma mark - dataSource

/// 返回分组个数，默认1
@property (nonatomic, copy)   YLCollectionViewNumberOfSectionsHandler numberOfSectionsHandler;
/// 返回每个分组item的个数
@property (nonatomic, copy)   YLCollectionViewNumberOfItemsInSectionHandler numberOfItemsHandler;
/// 返回item对象
@property (nonatomic, copy)   YLCollectionViewItemHandler itemHandler;
/// 返回header & footer
@property (nonatomic, copy)   YLCollectionViewSupplementaryElementHandler supplementaryViewHandler;


#pragma mark - delegate

/// 将要选中回调
@property (nonatomic, copy)   YLCollectionViewShouldSelectItemsHandler shouldSelectHandler;
/// 选中回调
@property (nonatomic, copy)   YLCollectionViewDidSelectItemsHandler selectHandler;
/// 将要取消选中回调
@property (nonatomic, copy)   YLCollectionViewShouldDeselectItemsHandler shouldDeselectHandler;
/// 取消选中回调
@property (nonatomic, copy)   YLCollectionViewDidDeselectItemsHandler deselectHandler;
/// 滚动回调
@property (nonatomic, copy)   YLCollectionViewScrollHandler scrollHandler;

#pragma mark - 拖拽操作

/// 是否可以拖拽
@property (nonatomic, copy)   YLCollectionViewCanDragItemsHandler canDragHandler;
/// 写入数据到剪切版
@property (nonatomic, copy)   YLCollectionViewPastedboardWriterForItemHandler pastedboardWriterForItemHandler;
/// 拖拽的操作类型
@property (nonatomic, copy)   YLCollectionViewValidateDropHandler validateDropHandler;
/// 接收拖拽数据
@property (nonatomic, copy)   YLCollectionViewAcceptDropHandler acceptDropHandler;


#pragma mark - layout

/// item 大小
@property (nonatomic, copy)   YLCollectionViewItemSizeHandler itemSizeHandler;
/// 分组 edgeInsets
@property (nonatomic, copy)   YLCollectionViewSectionInsetHandler sectionInsetHandler;
/// 行间距最小值
@property (nonatomic, copy)   YLCollectionViewMinLineSpacingHandler lineSpacingHandler;
/// item间距最小值
@property (nonatomic, copy)   YLCollectionViewMinItemSpacingHandler itemSpacingHandler;
/// header 大小
@property (nonatomic, copy)   YLCollectionViewHeaderSizeHandler headerSizeHandler;
/// footer 大小
@property (nonatomic, copy)   YLCollectionViewFooterSizeHandler footerSizeHandler;

#pragma mark -

/// 构造方法
- (instancetype)initWithLayout:(NSCollectionViewLayout *)layout;

/// 注册item
- (void)registerItemClass:(Class)itemClass withIdentifier:(NSString *)identifier;
/// 注册header, footer
- (void)registerSupplementaryViewClass:(Class)supplementaryViewClass kind:(NSCollectionViewSupplementaryElementKind)kind withIdentifier:(NSString *)identifier;

/// 注册Nib item
- (void)registerItemNib:(NSNib *)nib withIdentifier:(NSString *)identifier;
/// 注册Nib header, footer
- (void)registerSupplementaryViewNib:(NSNib *)nib kind:(NSCollectionViewSupplementaryElementKind)kind withIdentifier:(NSString *)identifier;

/// 注册拖拽类型
- (void)registerForDraggedTypes:(NSArray<NSPasteboardType> *)newTypes;

/// 重新加载数据
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END

