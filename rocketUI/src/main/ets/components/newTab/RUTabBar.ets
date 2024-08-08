/**
 * Author:fanlilin
 * Date:2024/7/17
 * Descrobe:
 */

import { ComponentUtils, curves, uiObserver } from '@kit.ArkUI'
import { RUTabsController } from './RUTabs'
import { RUTabBarIndicatorLineBottomBuilder } from './RUTabBarIndicatorLine'

export interface RUTabBarItemInterface {
  // 默认tab类别
  title: string
  // 唯一标识，可以用下标
  id?: number | string | undefined
  // 是否选中
  selected?: boolean
  // 默认tab颜色
  titleColor?: ResourceStr
  // 默认tab字体
  titleFont?: Font
  // tab选中颜色
  titleSelectedColor?: ResourceStr
  // tab选中字体
  titleSelectedFont?: Font
  // 边框
  border?: BorderOptions
  // 选中边框
  selectedBorder?: BorderOptions
  // 内边距
  padding?: Padding | Length | LocalizedPadding
  // 圆角值
  borderRadius?: number
}

/**
 * TabBar子项
 */
export class RUTabBarItem implements RUTabBarItemInterface {
  // 默认tab类别
  title: string
  // 唯一标识，可以用下标
  id?: number | string | undefined = undefined
  // 是否选中
  selected: boolean = false
  // 默认tab颜色
  titleColor: ResourceStr = '#FFF5F5F5'
  // 默认tab字体
  titleFont: Font = { size: 15, weight: FontWeight.Regular }
  // tab选中颜色
  titleSelectedColor: ResourceStr = '#FFFFFFFF'
  // tab选中字体
  titleSelectedFont: Font = { size: 16, weight: FontWeight.Medium }
  // 边框
  border?: BorderOptions
  // 选中边框
  selectedBorder?: BorderOptions
  // 内边距
  padding?: Padding | Length | LocalizedPadding = 0
  // 圆角值
  borderRadius?: number = 0

  constructor(item: RUTabBarItemInterface) {
    this.title = item.title
    this.id = item.id ?? this.id
    this.titleColor = item.titleColor ?? this.titleColor
    this.titleFont = item.titleFont ?? this.titleFont
    this.titleSelectedColor = item.titleSelectedColor ?? this.titleSelectedColor
    this.titleSelectedFont = item.titleSelectedFont ?? this.titleSelectedFont
    this.border = item.border ?? this.border
    this.selectedBorder = item.selectedBorder ?? this.selectedBorder
    this.padding = item.padding ?? this.padding
    this.borderRadius = item.borderRadius ?? this.borderRadius
  }
}

/**
 * 指示器类型
 */
export enum RUTabBarIndicatorType {
  // 没有
  None,
  // 下划线
  Underline,
  // 自定义，使用 indicator 参考内部`Underline`实现
  Custom
}

/**
 * 接入容器组件RUTabs手势滚动事件
 */
export interface RUTabBarIndexChangeEvent {
  // 当前 index
  currentIndex: number
  // 当前 index 对应的`item`的位置
  currentRect: RectResult
  // 即将滚动到下一个 index
  targetIndex: number
  // 即将滚动到下一个 index 对应的`item`的位置
  targetRect: RectResult
  // 手势滑动百分比率，如果 = 0，说明没有用手势操作
  swipeRatio: number
  // 父组件区域信息
  area?: Area
  // 两个过渡的item相对屏幕的左视觉位置
  leftRect: RectResult
  // 两个过渡的item相对屏幕的右视觉位置
  rightRect: RectResult
  // 过渡方向是否从左→右，反之从右→左
  isLeftToRight: boolean
}

/**
 * 指示器协议（由于struct不能直接实现遵守协议的模式，这里采用class + block的方式）
 */
export class RUTabBarIndicatorDelegate {
  /**
   * 组件布局区域更新回调（父组件大小、选中TabBar的子项item、contentSize发生变化都会触发），以便重新校正子组件位置。
   *
   * @param area - 父组件区域信息
   * @param selectedRect - 选中的item坐标
   * @param contentSize - 整个子组件内容大小
   */
  onLayoutAreaChange: (area: Area, selectedRect: RectResult, contentSize: Size) => void = () => {}

  /**
   * 点击某一个item回调
   *
   *  @param index - Index to select to.
   */
  onClickItem: (index: number) => void = () => {}

  /**
   * 在容器视图上手势滚动操作（当接入了RUTabs才有此回调触发）
   *
   * @param event - 容器组件滚动信息
   */
  onContentViewDidScroll: (event: RUTabBarIndexChangeEvent) => void = () => {}

  /**
   * 在容器视图上手势取消的那一刻开始动画减速（当接入了RUTabs才有此回调触发）
   *
   * @param index - 即将更新到对应的index
   * @param rect - 对应index的item坐标信息
   */
  onContentViewWillBeginAnimation:(index: number, rect: RectResult) => void = () => {}

  /**
   * 在容器视图上手势取消之后完成了动画减速（当接入了RUTabs才有此回调触发）
   *
   * @param index - 对应的index
   * @param rect - 对应index的item坐标信息
   */
  onContentViewDidEndAnimation:(index: number, rect: RectResult) => void = () => {}
}

export class RUTabBarController {

  /**
   * 滚到到指定的索引
   *
   * @param value - Index to jump to.
   */
  scrollToIndex: (value: number) => void = () => {}
}

@Component
export default struct RUTabBar {
  // 数据源
  items?: RUTabBarItem[]
  // item之间的间距
  spacing: number = 20
  // 和组件Tabs进行联动需要设置
  tabsController?: TabsController | RUTabsController
  // 操控RUTabBar
  tabBarController?: RUTabBarController
  // 提供默认支持的指示器样式
  indicatorType: RUTabBarIndicatorType = RUTabBarIndicatorType.Underline
  // 滚动视图内边距调整
  scrollPadding: Padding | Length | LocalizedPadding = 0
  // 下标回调
  onClickIndex?: (value: number) => void
  // 自定义指示器
  @BuilderParam indicator?: (delegate: RUTabBarIndicatorDelegate) => void
  @State selectedIndex: number = 0
  private listController: ListScroller = new ListScroller()
  private scrollController: Scroller = new Scroller()
  private contentSize: Size | undefined = undefined
  private scrollArea: Area | undefined = undefined
  private indicatorDelegate?: RUTabBarIndicatorDelegate
  private tabsWidth: number = 0

  aboutToAppear() {
    if (this.indicatorType != RUTabBarIndicatorType.None) {
      this.indicatorDelegate = new RUTabBarIndicatorDelegate()
    }
    if (this.indicatorType === RUTabBarIndicatorType.Underline) {
      this.indicator = RUTabBarIndicatorLineBottomBuilder
    }

    if (this.tabBarController) {
      this.tabBarController.scrollToIndex = (value: number) => {
        if (this.selectedIndex === value) { return }
        this.scrollToIndex(value)
      }
    }

    // 如果是 RUTabsController 可以进行更丰富的交互联动效果
    if (this.tabsController instanceof RUTabsController) {
      this.tabsController.onAreaChange = (oldValue: Area, newValue: Area) => {
        this.tabsWidth = newValue.width as number
      }

      // 页面切换
      this.tabsController.onChange = (index: number) => {
        if (this.selectedIndex === index) { return }
        this.scrollToIndex(index)
      }

      // 当滑动手势取消的那一刻开始动画减速
      this.tabsController.onAnimationStart = (index: number, targetIndex: number, event: TabsAnimationEvent) => {
        this.selectedIndex = targetIndex
        this.updateScrollOffset(true)
        let rect = this.listController.getItemRect(targetIndex)
        this.indicatorDelegate?.onContentViewWillBeginAnimation(targetIndex, rect)
      }

      // 当滑动手势之后完成动画减速
      this.tabsController.onAnimationEnd = (index: number, event: TabsAnimationEvent) => {
        this.selectedIndex = index
        this.updateScrollOffset(false)
        let rect = this.listController.getItemRect(index)
        this.indicatorDelegate?.onContentViewDidEndAnimation(index, rect)
      }

      // 手势滑动
      this.tabsController.onGestureSwipe = (index: number, event: TabsAnimationEvent) => {
        let count = this.items?.length ?? 0
        // 数据源为空，不处理
        if (count === 0) { return }
        // 向右滑，滚动到了最左边，且已经选中了第一个,不处理
        if (event.currentOffset > 0 && this.scrollController.currentOffset().xOffset === 0 && this.selectedIndex === 0) { return }
        // 向左滑，滚动到了最右边，且已经选中了最后一个,不处理
        if (event.currentOffset < 0 && this.scrollController.isAtEnd() && this.selectedIndex === count - 1) { return }

        let swipeRatio = Math.abs(event.currentOffset / this.tabsWidth)

        let nextIndex = index
        if (index > 0 && event.currentOffset > 0) {
          nextIndex--
        } else if (index < count - 1 && event.currentOffset < 0) {
          nextIndex++
        }

        let currentRect = this.listController.getItemRect(index)
        let targetRect = this.listController.getItemRect(nextIndex)

        let currentIndex = swipeRatio > 0.5 ? nextIndex : index
        let isLeftToRight = event.currentOffset < 0

        let info: RUTabBarIndexChangeEvent = {
          currentIndex: currentIndex,
          currentRect: currentRect,
          targetIndex: nextIndex,
          targetRect: targetRect,
          swipeRatio: swipeRatio,
          leftRect: isLeftToRight ? currentRect : targetRect,
          rightRect: isLeftToRight ? targetRect : currentRect,
          isLeftToRight: isLeftToRight
        }

        this.indicatorDelegate?.onContentViewDidScroll(info)
      }
    }
  }

  build() {
    Scroll(this.scrollController) {
      Stack() {
        if (this.indicator && this.indicatorDelegate) {
          this.indicator(this.indicatorDelegate)
        }

        List({ space: this.spacing, scroller: this.listController }) {
          ForEach(this.items, (item: RUTabBarItem, index: number) => {
            ListItem() {
              this.tabBuilder(item, index);
            }
          }, (item: RUTabBarItem, index: number) => item.title + index)
        }
        .listDirection(Axis.Horizontal)
        .alignListItem(ListItemAlign.Center)
        .scrollBar(BarState.Off)
        .enableScrollInteraction(false)
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          // 如果设置了默认和选中的字体不一样时，会发生宽度变化，点击的偏移量需要重新校正
          this.contentSize = { width: newValue.width as number, height: newValue.height as number}
          this.scrollToIndex(this.selectedIndex)
        })
        .padding(this.scrollPadding)
      }
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .width('100%')
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area) => {
      console.info(`List: on area change, newValue value is ${JSON.stringify(newValue)}`)
      this.scrollArea = newValue
      this.scrollToIndex(this.selectedIndex, false)
      this.tabsController?.changeIndex(this.selectedIndex)
    })
  }

  @Builder
  tabBuilder(item: RUTabBarItem, index: number) {
    Column() {
      Text(item.title)
        .fontSize(this.selectedIndex === index ? item.titleSelectedFont.size : item.titleFont.size)
        .fontWeight(this.selectedIndex === index ? item.titleSelectedFont.weight : item.titleFont.weight)
        .fontColor(this.selectedIndex === index ? item.titleSelectedColor : item.titleColor)
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          // 如果设置了默认和选中的字体不一样时，会发生宽度变化，偏移量需要重新校正
          if (this.selectedIndex != index) { return }
          this.scrollToIndex(this.selectedIndex)
        })
        .id(index.toString())
        .border(this.selectedIndex === index ? item.selectedBorder : item.border)
        .borderRadius(item.borderRadius)
        .padding(item.padding)
    }
    .align(Alignment.Center)
    .onClick(() => {
      this.scrollToIndex(index)
      this.indicatorDelegate?.onClickItem(index)
      this.tabsController?.changeIndex(index)
      this.onClickIndex && this.onClickIndex(index)
    })
  }

  scrollToIndex(value: number, animation: boolean = true) {
    this.selectedIndex = value

    if (!this.scrollArea || !this.contentSize) { return }
    let rect = this.listController.getItemRect(value)

    let xOffset = this.getCenterXOffset()
    // 定位到当前选中的位置
    this.scrollController.scrollTo({ xOffset: xOffset, yOffset: 0 , animation: animation })
    // 更新指示器位置
    this.indicatorDelegate?.onLayoutAreaChange(this.scrollArea, rect, this.contentSize)
  }

  updateScrollOffset(animation: boolean = true) {
    if (!this.scrollArea || !this.contentSize) { return }
    let xOffset = this.getCenterXOffset()
    // 定位到当前选中的位置
    this.scrollController.scrollTo({ xOffset: xOffset, yOffset: 0 , animation: animation })
  }

  private getCenterXOffset(): number {
    if (!this.scrollArea || !this.contentSize) { return 0 }
    let rect = this.listController.getItemRect(this.selectedIndex)
    let scrollWidth = this.scrollArea?.width as number
    // 最小偏移量
    let minX = 0
    // 最大偏移量
    let maxX = (this.contentSize?.width as number) - scrollWidth
    // 相对父视图宽度的一半保持显示区域
    let targetX = rect.x - scrollWidth / 2 + rect.width / 2
    let xOffset = Math.max(Math.min(maxX, targetX), minX)
    return xOffset
  }
}


