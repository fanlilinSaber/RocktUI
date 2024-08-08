/**
 * Author:fanlilin
 * Date:2024/8/8
 * Descrobe:
 */
import { RUTabBarIndexChangeEvent, RUTabBarIndicatorDelegate } from './RUTabBar'
import { RUTabBarAutomaticDimension, RUTabBarIndicator, RUTabBarIndicatorPosition } from './RUTabBarIndicator'


@Builder
export function RUTabBarIndicatorLineTopBuilder(controller: RUTabBarIndicatorDelegate) {
  RUTabBarIndicatorLine({ delegate: controller, options: { width: RUTabBarAutomaticDimension, height: 3, color: '#FFFFFFFF', position: RUTabBarIndicatorPosition.Top } })
}

@Builder
export function RUTabBarIndicatorLineBottomBuilder(controller: RUTabBarIndicatorDelegate) {
  RUTabBarIndicatorLine({ delegate: controller, options: { width: RUTabBarAutomaticDimension, height: 3, color: '#FFFFFFFF', position: RUTabBarIndicatorPosition.Bottom } })
}

/**
 * 线条样式
 */
export enum RUTabBarIndicatorLineType {
  // 跟随下一个item宽度过渡
  Normal,
  // 延长
  Lengthen,
}

@Reusable
@Component
export struct RUTabBarIndicatorLine {
  @Require delegate: RUTabBarIndicatorDelegate = new RUTabBarIndicatorDelegate()
  options: RUTabBarIndicator = { width: 20, height: 3, color: '#FFFFFFFF', verticalMargin: 5 }
  lineType: RUTabBarIndicatorLineType = RUTabBarIndicatorLineType.Normal
  @State private positionValue: Position = { x: 0, y: 0 }
  @State private opacityValue: number = 0
  @State private indicatorWidth: number = 0
  @State private indicatorBorderRadius: number = 0

  aboutToAppear(): void {
    this.delegate.onLayoutAreaChange = (area: Area, selectedRect: RectResult) => {
      if (this.opacityValue === 1) {
        this.animateChangePosition(selectedRect)
      } else {
        // 初始化位置不使用动画更新
        this.changePosition(selectedRect)
        this.opacityValue = 1
      }
    }

    // 建议动画效果过渡
    this.delegate.onContentViewWillBeginAnimation = (index: number, rect: RectResult) => {
      this.animateChangePosition(rect)
    }

    // 这个直接更新校正即可
    this.delegate.onContentViewDidEndAnimation = (index: number, rect: RectResult) => {
      this.changePosition(rect)
    }

    this.delegate.onContentViewDidScroll = (event: RUTabBarIndexChangeEvent) => {
      let ratio = event.swipeRatio
      let isLeftToRight = event.isLeftToRight
      // 两个过渡的item相对屏幕的左右视觉位置
      let leftIndicatorWidth = this.getIndicatorWidth(event.leftRect)
      let rightIndicatorWidth = this.getIndicatorWidth(event.rightRect)
      let leftX = event.leftRect.x + (event.leftRect.width - leftIndicatorWidth) / 2
      let rightX = event.rightRect.x + (event.rightRect.width - rightIndicatorWidth) / 2

      let aboutX = leftX
      let aboutWidth = leftIndicatorWidth

      if (!isLeftToRight) { ratio = 1.0 - ratio }
      if (this.lineType === RUTabBarIndicatorLineType.Lengthen) {
        let maxWidth = rightX - leftX + rightIndicatorWidth
        // 前50%，只增加width；后50%，移动x并减小width
        if (ratio <= 0.5) {
          aboutX = leftX
          aboutWidth = this.getMoveAlgorithmValue(leftIndicatorWidth, maxWidth, ratio * 2)
        } else {
          aboutX = this.getMoveAlgorithmValue(leftX, rightX, (ratio - 0.5) * 2)
          aboutWidth = this.getMoveAlgorithmValue(maxWidth, rightIndicatorWidth, (ratio - 0.5) * 2)
        }
      }  else {
        aboutX = this.getMoveAlgorithmValue(leftX, rightX, ratio)
        if (this.options.width === RUTabBarAutomaticDimension) {
          aboutWidth = this.getMoveAlgorithmValue(leftIndicatorWidth, rightIndicatorWidth, ratio)
        }
      }

      this.positionValue = { x: aboutX, y: this.positionValue.y }
      this.indicatorWidth = aboutWidth
    }
  }

  build() {
    Column()
      .height(this.options.height)
      .width(this.indicatorWidth)
      .backgroundColor(this.options.color)
      .position(this.positionValue)
      .opacity(this.opacityValue)
      .borderRadius(this.indicatorBorderRadius)
  }

  animateChangePosition(rect: RectResult) {
    animateTo({ duration: 300, curve: Curve.Linear}, () => {
      this.changePosition(rect)
    })
  }

  /**
   * 变化位置
   * @param rect 当前item的位置信息
   */
  changePosition(rect: RectResult) {
    let indicatorWidth = this.getIndicatorWidth(rect)
    switch (this.options.position) {
      case RUTabBarIndicatorPosition.Top: {
        let offsetX = rect.x + (rect.width - indicatorWidth) / 2
        let offsetY = rect.y - this.options.height - (this.options.verticalMargin ?? 5)
        this.positionValue = { x: offsetX, y: offsetY }
      }
        break;
      case RUTabBarIndicatorPosition.Bottom: {
        let offsetX = rect.x + (rect.width - indicatorWidth) / 2
        let offsetY = rect.y + rect.height + (this.options.verticalMargin ?? 5)
        this.positionValue = { x: offsetX, y: offsetY }
      }
        break;
    }

    this.indicatorWidth = indicatorWidth
  }

  getIndicatorWidth(rect: RectResult): number {
    let indicatorWidth = this.options.width === RUTabBarAutomaticDimension ? rect.width : this.options.width
    return indicatorWidth
  }

  getMoveAlgorithmValue(from: number, to: number, ratio: number): number {
    let value = from + (to - from) * ratio
    return value
  }
}