//
//  FHXFloatingButton.h
//  Frame
//
//  Created by imac on 2026/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FHXFloatingButton;
@protocol FHXFloatingButtonDelegate <NSObject>
// 点击悬浮按键触发
- (void)fhxFloatingButton:(FHXFloatingButton *)view btnClick:(NSString *)name;
// “悬浮按钮当前的位置变化”实时回调给外部
- (void)fhxFloatingButton:(FHXFloatingButton *)view btnFrame:(CGRect)rect;

@end

@interface FHXFloatingButton : UIView

@property (nonatomic, weak) id<FHXFloatingButtonDelegate> delegate;

/// 当前是否在左侧（给 Manager 用）
@property (nonatomic, assign, readonly) BOOL isLeft;

/// 拖拽按键贴边动画时间
@property (nonatomic, assign) CGFloat moveAnimationDuration;

/// 吸边
- (void)moveToEdge;

/// 滑出屏幕（隐藏）
- (void)hideToEdgeWithDuration:(CGFloat)duration;

/// 滑入屏幕（显示）
- (void)showFromEdgeWithDuration:(CGFloat)duration;

- (instancetype)initWithImage:(NSString *)name top:(CGFloat)top bottom:(CGFloat)bottom frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
