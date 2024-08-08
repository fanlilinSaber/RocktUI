/**
 * Author:fanlilin
 * Date:2024/8/8
 * Descrobe:
 */

/**
 * 指示器位置
 */
export enum RUTabBarIndicatorPosition {
  Top,
  Bottom
}

export const RUTabBarAutomaticDimension: number = -1

/**
 * 指示器属性
 */
export interface RUTabBarIndicator {
  // 指示器的宽度， 默认值 = -1表示与item的长度相等
  width: number
  // 指示器的高度，默认 = 3
  height: number
  // 指示器的颜色, 默认= '#FFFFFFFF'
  color?: ResourceColor
  // 指示器在垂直方向的偏移量，默认 = 0
  verticalMargin?: number
  // 指示器的位置
  position?: RUTabBarIndicatorPosition
  // 指示器的宽度增量(例如：需求是指示器宽度比 item 宽度多 10。就可以将该属性赋值为 10, 最终指示器的宽度 = indicatorWidth + indicatorWidthIncrement。)
  indicatorWidthIncrement?: number
  // 指示器的 BorderRadius 圆角半径
  indicatorBorderRadius?: number
}
