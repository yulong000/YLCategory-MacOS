//
//  YLCollectionView.m
//  macos-demo
//
//  Created by 魏宇龙 on 2023/5/12.
//

#import "YLCollectionView.h"

#pragma mark - 自定义的clipView, 处理横向滚动时，鼠标滚轮的反馈

@interface YLCollectionClipView : NSClipView

@end

@implementation YLCollectionClipView

- (void)scrollWheel:(NSEvent *)event {
    BOOL isCollectionViewHorizontalScroll = NO;
    if([self.documentView isKindOfClass:[NSCollectionView class]]) {
        NSCollectionView *collectionView = (NSCollectionView *)self.documentView;
        if([collectionView.collectionViewLayout isKindOfClass:[NSCollectionViewFlowLayout class]]) {
            NSCollectionViewFlowLayout *layout = (NSCollectionViewFlowLayout *)collectionView.collectionViewLayout;
            if(layout.scrollDirection == NSCollectionViewScrollDirectionHorizontal) {
                isCollectionViewHorizontalScroll = YES;
                // 横向滚动
                CGFloat add = 0;
                CGFloat x = event.scrollingDeltaX;
                CGFloat y = event.scrollingDeltaY;
                if(fabs(x) > fabs(y)) {
                    // 横向滚动
                    add = -x;
                } else {
                    add = -y;
                }
                NSRect bounds = self.bounds;
                bounds.origin.x += add * (event.hasPreciseScrollingDeltas ? 1 : 20);
                self.bounds = bounds;
                [[NSNotificationCenter defaultCenter] postNotificationName:NSScrollViewDidLiveScrollNotification object:self.superview];
            }
        }
    }
    if(isCollectionViewHorizontalScroll == NO) {
        [super scrollWheel:event];
    }
}

@end

#pragma mark - collectionView

@interface YLCollectionView () <NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSCollectionView *collectionView;
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) YLCollectionClipView *clipView;

@end

@implementation YLCollectionView

- (instancetype)initWithCoder:(NSCoder *)coder {
    if(self = [super initWithCoder:coder]) {
        [self addCollectionView];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if(self = [super initWithFrame:frameRect]) {
        [self addCollectionView];
    }
    return self;
}

- (instancetype)initWithLayout:(NSCollectionViewLayout *)layout {
    if(self = [super initWithFrame:NSZeroRect]) {
        [self addCollectionView];
        self.collectionView.collectionViewLayout = layout;
    }
    return self;
}

- (void)addCollectionView {
    [self addSubview:self.scrollView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clipViewBoundsChanged:) name:NSViewBoundsDidChangeNotification object:self.scrollView.contentView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clipViewBoundsChanged:(NSNotification *)note {
    if(note.object == self.scrollView.contentView) {
        if(self.scrollHandler) {
            self.scrollHandler(self.scrollView, self.collectionView);
        }
    }
}

- (void)registerItemClass:(Class)itemClass withIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:itemClass forItemWithIdentifier:identifier];
}

- (void)registerSupplementaryViewClass:(Class)supplementaryViewClass kind:(NSCollectionViewSupplementaryElementKind)kind withIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:supplementaryViewClass forSupplementaryViewOfKind:kind withIdentifier:identifier];
}

- (void)registerItemNib:(NSNib *)nib withIdentifier:(NSString *)identifier {
    [self.collectionView registerNib:nib forItemWithIdentifier:identifier];
}

- (void)registerSupplementaryViewNib:(NSNib *)nib kind:(NSCollectionViewSupplementaryElementKind)kind withIdentifier:(NSString *)identifier {
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:kind withIdentifier:identifier];
}

- (void)registerForDraggedTypes:(NSArray<NSPasteboardType> *)newTypes {
    [self.collectionView registerForDraggedTypes:newTypes];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)layout {
    [super layout];
    self.scrollView.frame = self.bounds;
}

#pragma mark - dataSource

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    if(self.numberOfSectionsHandler) {
        return self.numberOfSectionsHandler(collectionView);
    }
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.numberOfItemsHandler) {
        return self.numberOfItemsHandler(collectionView, section);
    }
    return 0;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    if(self.itemHandler) {
        return self.itemHandler(collectionView, indexPath);
    }
    return [[NSCollectionViewItem alloc] init];
}

- (NSView *)collectionView:(NSCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSCollectionViewSupplementaryElementKind)kind atIndexPath:(NSIndexPath *)indexPath {
    if(self.supplementaryViewHandler) {
        return self.supplementaryViewHandler(collectionView, kind, indexPath);
    }
    return nil;
}

#pragma mark - delegate

- (NSSet<NSIndexPath *> *)collectionView:(NSCollectionView *)collectionView shouldSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    if(self.shouldSelectHandler) {
        return self.shouldSelectHandler(collectionView, indexPaths);
    }
    return indexPaths;
}


- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    if(self.selectHandler) {
        self.selectHandler(collectionView, indexPaths);
    }
}

- (NSSet<NSIndexPath *> *)collectionView:(NSCollectionView *)collectionView shouldDeselectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    if(self.shouldDeselectHandler) {
        return self.shouldDeselectHandler(collectionView, indexPaths);
    }
    return indexPaths;
}

- (void)collectionView:(NSCollectionView *)collectionView didDeselectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    if(self.deselectHandler) {
        self.deselectHandler(collectionView, indexPaths);
    }
}

#pragma mark - drag

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths withEvent:(NSEvent *)event {
    if(self.canDragHandler) {
        return self.canDragHandler(collectionView, indexPaths, event);
    }
    return YES;
}

- (id<NSPasteboardWriting>)collectionView:(NSCollectionView *)collectionView pasteboardWriterForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.pastedboardWriterForItemHandler) {
        return self.pastedboardWriterForItemHandler(collectionView, indexPath);
    }
    return nil;
}

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)draggingInfo proposedIndexPath:(NSIndexPath * _Nonnull __autoreleasing *)proposedDropIndexPath dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {
    if(self.validateDropHandler) {
        return self.validateDropHandler(collectionView, draggingInfo, proposedDropIndexPath, proposedDropOperation);
    }
    return NSDragOperationNone;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id<NSDraggingInfo>)draggingInfo indexPath:(NSIndexPath *)indexPath dropOperation:(NSCollectionViewDropOperation)dropOperation {
    if(self.acceptDropHandler) {
        return self.acceptDropHandler(collectionView, draggingInfo, indexPath, dropOperation);
    }
    return NO;
}

#pragma mark - flow layout

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.itemSizeHandler) {
        return self.itemSizeHandler(collectionView, indexPath);
    }
    if([collectionViewLayout isKindOfClass:[NSCollectionViewFlowLayout class]]) {
        return ((NSCollectionViewFlowLayout *)collectionViewLayout).itemSize;
    }
    return NSZeroSize;
}

- (NSEdgeInsets)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(self.sectionInsetHandler) {
        return self.sectionInsetHandler(collectionView, section);
    }
    if([collectionViewLayout isKindOfClass:[NSCollectionViewFlowLayout class]]) {
        return ((NSCollectionViewFlowLayout *)collectionViewLayout).sectionInset;
    }
    return NSEdgeInsetsZero;
}

- (CGFloat)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(self.lineSpacingHandler) {
        return self.lineSpacingHandler(collectionView, section);
    }
    if([collectionViewLayout isKindOfClass:[NSCollectionViewFlowLayout class]]) {
        return ((NSCollectionViewFlowLayout *)collectionViewLayout).minimumLineSpacing;
    }
    return 0;
}

- (CGFloat)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if(self.itemSpacingHandler) {
        return self.itemSpacingHandler(collectionView, section);
    }
    if([collectionViewLayout isKindOfClass:[NSCollectionViewFlowLayout class]]) {
        return ((NSCollectionViewFlowLayout *)collectionViewLayout).minimumInteritemSpacing;
    }
    return 0;
}

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(self.headerSizeHandler) {
        return self.headerSizeHandler(collectionView, section);
    }
    if([collectionViewLayout isKindOfClass:[NSCollectionViewFlowLayout class]]) {
        return ((NSCollectionViewFlowLayout *)collectionViewLayout).headerReferenceSize;
    }
    return NSZeroSize;
}

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if(self.footerSizeHandler) {
        return self.footerSizeHandler(collectionView, section);
    }
    if([collectionViewLayout isKindOfClass:[NSCollectionViewFlowLayout class]]) {
        return ((NSCollectionViewFlowLayout *)collectionViewLayout).footerReferenceSize;
    }
    return NSZeroSize;
}


#pragma mark - lazy load

- (NSScrollView *)scrollView {
    if(_scrollView == nil) {
        _scrollView = [[NSScrollView alloc] init];
        _scrollView.contentView = self.clipView;
        _scrollView.documentView = self.collectionView;
        _scrollView.borderType = NSNoBorder;
        _scrollView.contentInsets = NSEdgeInsetsZero;
        _scrollView.drawsBackground = NO;
        [_scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    }
    return _scrollView;
}

- (NSCollectionView *)collectionView {
    if(_collectionView == nil) {
        _collectionView = [[NSCollectionView alloc] init];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.allowsMultipleSelection = NO;
        _collectionView.allowsEmptySelection = YES;
        _collectionView.selectable = YES;
        _collectionView.backgroundColors = @[[NSColor clearColor]];
    }
    return _collectionView;
}

- (YLCollectionClipView *)clipView {
    if(_clipView == nil) {
        _clipView = [[YLCollectionClipView alloc] init];
        [_clipView setPostsBoundsChangedNotifications:YES]; // 发起滚动通知
    }
    return _clipView;
}

@end
