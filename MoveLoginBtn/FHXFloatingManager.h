//
//  FHXFloatingManager.h
//  Frame
//
//  Created by imac on 2026/4/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHXFloatingManager : NSObject

+ (instancetype)shared;

- (void)show;
- (void)dismiss;

@property (nonatomic, assign, readonly) BOOL isShowing;

/// 点击回调
@property (nonatomic, copy) void(^clickBlock)(void);

/// 图片（推荐用 name）
@property (nonatomic, copy) NSString *imageName;

/// 按钮大小
@property (nonatomic, assign) CGSize size;

/// 边界限制（替代 top/bottom）
@property (nonatomic, assign) UIEdgeInsets edgeInset;

/// 滑动 ScrollerView (TableView, ColoectionView) 隐藏按钮动画时间
@property (nonatomic, assign) CGFloat dragAnimationDuration;

/// 拖拽吸边动画时间（透传给按钮）
@property (nonatomic, assign) CGFloat moveAnimationDuration;

/// 滚动时自动隐藏
@property (nonatomic, assign) BOOL autoHideWhenScroll;

@end

NS_ASSUME_NONNULL_END
