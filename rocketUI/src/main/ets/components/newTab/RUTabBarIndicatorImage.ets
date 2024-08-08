/**
 * Author:fanlilin
 * Date:2024/8/8
 * Descrobe:
 */
import { RUTabBarIndexChangeEvent, RUTabBarIndicatorDelegate } from './RUTabBar'
import { RUTabBarAutomaticDimension, RUTabBarIndicator, RUTabBarIndicatorPosition } from './RUTabBarIndicator'

@Builder
export function RUTabBarIndicatorImageBuilder(controller: RUTabBarIndicatorDelegate) {
  RUTabBarIndicatorImage({ delegate: controller, options: { width: 20, height: 20, color: Color.Transparent, indicatorBorderRadius: RUTabBarAutomaticDimension, position: RUTabBarIndicatorPosition.Bottom, verticalMargin: 3 } })
}

@Component
export struct RUTabBarIndicatorImage {
  @Require delegate: RUTabBarIndicatorDelegate = new RUTabBarIndicatorDelegate()
  options: RUTabBarIndicator = { width: RUTabBarAutomaticDimension, height: RUTabBarAutomaticDimension, color: '#fa696262', verticalMargin: 10, position: RUTabBarIndicatorPosition.Bottom }
  image?: Resource = $r('app.media.ru_ic_boat')

  @State private positionValue: Position = { x: 0, y: 0 }
  @State private opacityValue: number = 0
  @State private indicatorWidth: number = 0
  @State private indicatorHeight: number = 0
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

      aboutX = this.getMoveAlgorithmValue(leftX, rightX, ratio)
      aboutWidth = this.getMoveAlgorithmValue(leftIndicatorWidth, rightIndicatorWidth, ratio)

      this.positionValue = { x: aboutX, y: this.positionValue.y }
      this.indicatorWidth = aboutWidth
    }
  }

  build() {
    Image(this.image)
      .height(this.indicatorHeight)
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
    let indicatorHeight = this.getIndicatorHeight(rect)
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
    this.indicatorHeight = indicatorHeight
  }

  getIndicatorWidth(rect: RectResult): number {
    let indicatorWidth = this.options.width === RUTabBarAutomaticDimension ? rect.width : this.options.width
    let indicatorWidthIncrement = this.options.indicatorWidthIncrement ?? 0
    return indicatorWidth + indicatorWidthIncrement
  }

  getIndicatorHeight(rect: RectResult): number {
    let indicatorHeight = this.options.height === RUTabBarAutomaticDimension ? rect.height : this.options.height
    return indicatorHeight
  }

  getIndicatorBorderRadius(rect: RectResult): number {
    let indicatorBorderRadius = this.options.indicatorBorderRadius === RUTabBarAutomaticDimension ? rect.height / 2 : this.options.height
    return indicatorBorderRadius
  }

  getMoveAlgorithmValue(from: number, to: number, ratio: number): number {
    let value = from + (to - from) * ratio
    return value
  }
}