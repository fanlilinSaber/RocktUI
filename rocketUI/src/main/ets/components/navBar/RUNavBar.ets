/**
 * Author:fanlilin
 * Date:2024/1/22
 * Descrobe:
 */
import router from '@ohos.router'
import { NAVBAR_HEIGHT } from '../../constants/RUConstants'
import RUConfig from '../../config/RUConfig'
import RUEventBus, { RUEventData } from '../../utils/RUEventBus'
import RUNavBarModifier, { RUNavBarAttribute } from './RUNavBarAttribute'

/**
 * 导航栏菜单
 */
export interface RUNavBarMenuItem {
  // 名称
  title?: string
  titleColor?: ResourceColor
  titleSize?: number | string
  titleWeight?: number | FontWeight | string
  // 图标
  icon?: Resource
  // 自定义图标大小 不设置默认 = {20，20}
  iconSize?: SizeOptions
  // 点击事件；注意：外部需要通过bind绑定，是为了在对应的函数里this指向self（例： {title: '删除', action: this.deleteAction.bind(this)}
  // 新的ARUS语法上不支持bind函数了，要用新的action: (): void => { this.xxAction() }
  action?: (tag?: string) => void
  // 标签；当共用一个`action`的时候可以传入tag来区分不同的事件
  tag?: string
}

/**
 * 外观属性
 */
export interface RUNavBarAppearance {
  // 标题颜色
  titleColor?: ResourceColor
  // 标题字体大小
  titleSize?: number | string
  // 标题字体字重
  titleWeight?: number | FontWeight | string
  // 背景色
  barColor?: ResourceColor
  // 返回按钮
  backIcon?
  // 返回按钮颜色（svg）
  backFillColor?: ResourceColor
}

/**
 * 外观样式快捷模板
 */
export enum RUNavBarAppearanceMode {
  // 红底+白色辅助
  RedMode,
  // 白底+黑色辅助
  WhiteMode
}

/**
 * 通用导航栏
 */
@Component
export struct RUNavBar {
  // 导航栏标题（会根据左右两边菜单占用的宽度控制是否居中显示，如果居中显示有重叠就不相对屏幕居中显示了；自定义WrappedBuilder视图区域受左右两边菜单自适应大小）
  @Prop title: string | WrappedBuilder<[]> = ''
  titleColor: ResourceColor = Color.White
  titleSize?: number | string = 17
  titleWeight?: number | FontWeight | string = FontWeight.Medium

  // 背景色（因无法获取组件默认的backgroundColor属性作为条件判断值，单独提供一个来设置默认色，不用在外面设置 backgroundColor）
  barColor?: ResourceColor = $r("app.color.ru_main_color")
  // 返回按钮
  backIcon?: string | PixelMap | Resource = $r("app.media.ru_navbar_back_svg")
  // 返回按钮颜色（svg）
  backFillColor: ResourceColor = Color.White
  // 是否隐藏返回按钮
  hideBack: boolean = false
  // 返回按钮拦截事件
  onClickBack?: () => boolean

  // 外观属性集中配置（外面可以直接实现接口如：ANavBarAppearance implements RUNavBarAppearance，BNavBarAppearance implements RUNavBarAppearance 来集中配置）
  appearance?: RUNavBarAppearance
  // 外观默认模板（appearance、appearanceMode、barColor...等属性互斥，自定义 appearance 优先级最高）
  appearanceMode: RUNavBarAppearanceMode = RUNavBarAppearanceMode.RedMode
  // 自定义Title部分是否强制居中显示（如果有自定义Title想保持居中模式，可设置为true，注意自己控制左右区域重叠部分，鸿蒙坑就在不能对布局设置优先级）
  forceCenter: boolean = false

  // 如果是基于Navigation的路由管理，默认内部做了自动获取，如果有单独的navPathStack可以外部传进来（用来做自动显示返回按钮和back操作）
  navPathStack?: NavPathStack

  // 左右常规菜单
  leftMemus?: RUNavBarMenuItem[] = undefined
  rightMemus?: RUNavBarMenuItem[] = undefined

  @Builder doNothingBuilder() {}

  // 自定义title（自定义title视图区域受左右两边菜单自适应大小）
  @BuilderParam customTitle: CustomBuilder = this.doNothingBuilder
  // 自定义左菜单
  @BuilderParam customLeftMemus: CustomBuilder = this.doNothingBuilder
  // 自定义右菜单
  @BuilderParam customRightMemus: CustomBuilder = this.doNothingBuilder

  private attribute?: RUNavBarAttribute
  @State containerModifier: RUNavBarModifier = new RUNavBarModifier()
  @State leftMemuBarModifier: RUNavBarModifier = new RUNavBarModifier()
  @State rightMemuBarModifier: RUNavBarModifier = new RUNavBarModifier()
  @State titleBarModifier: RUNavBarModifier = new RUNavBarModifier()
  @State textBarModifier: RUNavBarModifier = new RUNavBarModifier()

  aboutToAppear() {
    if (!this.navPathStack) {
      // this指代MyComponent自定义节点，并从该节点向上查找其最近的一个类型为Navigation的父亲节点
      this.navPathStack = this.queryNavigationInfo()?.pathStack
    }
    this.attribute = new RUNavBarAttribute(this.containerModifier, this.leftMemuBarModifier, this.rightMemuBarModifier, this.titleBarModifier, this.textBarModifier)
    this.configAppearance()
  }

  // MARK: - 布局UI
  build() {
    Column() {
      // 这是留个占位；可能要适配 挖孔屏、刘海屏、瀑布屏等不可用屏幕区域信息

      // 导航栏布局
      RelativeContainer() {
        // 左侧菜单栏
        this.leftMemuBar()

        // 中间标题栏
        this.titleBar()

        // 右侧菜单栏
        this.rightMemuBar()
      }
      .height(NAVBAR_HEIGHT).width('100%')
    }
    .width('100%')
    .backgroundColor(this.appearance?.barColor ?? this.barColor)
    // 设置顶部绘制延伸到状态栏
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .padding({ top: `${ RUConfig.statusBarHeight}px` })
    .attributeModifier(this.containerModifier as RUNavBarModifier)
  }

  // 是否有返回按钮
  private isBackButton(): boolean {
    if (this.navPathStack) {
      if (this.navPathStack.size() < 1) { return false }
      return !this.hideBack
    } else if (router.getState().index <= 1) {
      return false
    }
    return !this.hideBack
  }

  // 左侧菜单栏
  @Builder
  leftMemuBar() {
    Column() {
      Row() {
        // 返回按钮
        if (this.isBackButton()) {
          this.leftBackBar()
        }

        if (this.customLeftMemus && this.customLeftMemus != this.doNothingBuilder) {
          this.customLeftMemus()
        } else {
          this.normalMemus(this.leftMemus, { left: this.hideBack ? 15 : 10, right: 10 })
        }
      }
      .height('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
    }
    .height('100%')
    .alignRules({
      top: {anchor: "__container__", align: VerticalAlign.Top},
      left: {anchor: "__container__", align: HorizontalAlign.Start}
    })
    .displayPriority(100)
    .id("__leftMemuBar")
    .attributeModifier(this.leftMemuBarModifier as RUNavBarModifier)
  }

  // 中间标题栏
  @Builder
  titleBar() {
    if (typeof this.title === 'object' || (this.customTitle && this.customTitle != this.doNothingBuilder)) {
      Column() {
        if (typeof this.title === 'object') {
          this.title.builder()
        } else if (this.customTitle) {
          this.customTitle()
        }
      }
      .justifyContent(FlexAlign.Center)
      .height('100%')
      .alignRules(this.titleBarAlignRule())
      .displayPriority(99)
      .id("__titleBar")
      .attributeModifier(this.titleBarModifier as RUNavBarModifier)
    } else {
      Column() {
        Text(this.title)
          .align(Alignment.Center)
          .fontSize(this.appearance?.titleSize ?? this.titleSize).fontWeight(this.appearance?.titleWeight ?? this.titleWeight).fontColor(this.appearance?.titleColor ?? this.titleColor)
          .textOverflow({ overflow: TextOverflow.Ellipsis }) // 限制为一行 ellipses
          .maxLines(1)
          .id("__textBar")
          .attributeModifier(this.textBarModifier as RUNavBarModifier)
          .onAreaChange(this.textBarModifier._onAreaChange)
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .height('100%')
      .alignRules({
        center: {anchor: "__container__", align: VerticalAlign.Center},
        left: {anchor: '__leftMemuBar', align: HorizontalAlign.End},
        right: {anchor: '__rightMemuBar', align: HorizontalAlign.Start},
      })
      .displayPriority(99)
      .id("__titleBar")
      .attributeModifier(this.titleBarModifier as RUNavBarModifier)
    }
  }

  // 右侧菜单栏
  @Builder
  rightMemuBar() {
    Column() {
      Row() {
        if (this.customRightMemus && this.customRightMemus != this.doNothingBuilder) {
          this.customRightMemus()
        } else {
          this.normalMemus(this.rightMemus, { left: 10, right: 15 })
        }
      }
      .height('100%')
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
    }
    .height('100%')
    .alignRules({
      center: {anchor: "__container__", align: VerticalAlign.Center},
      right: {anchor: "__container__", align: HorizontalAlign.End},
    })
    .displayPriority(100)
    .id("__rightMemuBar")
    .attributeModifier(this.rightMemuBarModifier as RUNavBarModifier)
  }

  // 默认返回按钮
  @Builder
  leftBackBar() {
    Row(){
      Image(this.appearance?.backIcon ?? this.backIcon)
        .width(10).height(20)
        .margin({ left: 15 })
        .fillColor(this.appearance?.backFillColor ?? this.backFillColor)
    }
    .width('44').height('44')
    .justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Center)
    .onClick(() => {
      let next = true
      if (this.onClickBack) {
        next = this.onClickBack()
      }
      if (!next) { return }
      if (this.navPathStack) {
        this.navPathStack.pop()
      } else {
        router.back()
      }
    })
  }

  /**
   * 默认菜单UI样式
   * @param items 数据源
   * @param padding 内边距
   */
  @Builder
  normalMemus(items: Array<RUNavBarMenuItem> | undefined, padding: Padding) {
    Row({ space: 10 }) {
      if (Array.isArray(items)) {
        ForEach(items, (item: RUNavBarMenuItem)  => {
          if (item.title) {
            Text(item.title)
              .align(Alignment.Center)
              .fontSize(item.titleSize ?? 15).fontWeight(item.titleWeight ?? FontWeight.Medium).fontColor(item.titleColor ?? this.titleColor)
              .onClick(() => {
                if (item.action) {
                  item.action(item.tag)
                }
              })
          } else if (item.icon) {
            Image(item.icon)
              .width(item.iconSize ? item.iconSize.width : 20).height(item.iconSize ? item.iconSize.height : 20)
              .objectFit(ImageFit.Auto)
              .onClick(() => {
                if (item.action) {
                  item.action(item.tag)
                }
              })
          }
        })
      }
    }
    .padding(padding)
  }

  /**
   * 外观配置
   */
  configAppearance() {
    switch (this.appearanceMode) {
      case RUNavBarAppearanceMode.WhiteMode:
        this.titleColor = $r('app.color.ru_color_FF000000')
        this.titleSize = 17
        this.titleWeight = FontWeight.Medium
        this.barColor = Color.White
        this.backIcon = $r("app.media.ru_navbar_back_svg")
        this.backFillColor = $r('app.color.ru_color_FF000000')
        this
        break;
      default:
      // redMode 用属性初始化值
        break;
    }
  }

  titleBarAlignRule(): AlignRuleOption {
    if (this.forceCenter) {
      return {
        center: {anchor: "__container__", align: VerticalAlign.Center},
        middle: {anchor: "__container__", align: HorizontalAlign.Center},
        left: {anchor: "__leftMemuBar", align: HorizontalAlign.End},
        right: {anchor: "__rightMemuBar", align: HorizontalAlign.Start},
      }
    }
    return {
      center: {anchor: "__container__", align: VerticalAlign.Center},
      left: {anchor: "__leftMemuBar", align: HorizontalAlign.End},
      right: {anchor: "__rightMemuBar", align: HorizontalAlign.Start},
    }
  }
}
