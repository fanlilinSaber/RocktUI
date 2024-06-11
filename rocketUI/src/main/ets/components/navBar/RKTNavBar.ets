/**
 * Author:fanlilin
 * Date:2024/1/22
 * Descrobe:
 */
import router from '@ohos.router'

/**
 * 导航栏菜单
 */
export interface RKTNavBarMenuItem {
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
  // 新的ArkTS语法上不支持bind函数了，要用新的action: (): void => { this.xxAction() }
  action: (tag?: string) => void
  // 标签；当共用一个`action`的时候可以传入tag来区分不同的事件
  tag?: string
}

/**
 * 通用导航栏
 */
@Component
export struct RKTNavBar {

  // 导航栏标题
  @Prop title: string = ''
  titleColor: ResourceColor = Color.White
  titleSize?: number | string = 17
  titleWeight?: number | FontWeight | string = FontWeight.Medium

  // 背景色（因无法获取组件默认的backgroundColor属性作为条件判断值，单独提供一个来设置默认色，不用在外面设置 backgroundColor）
  barColor?: ResourceColor = $r("app.color.ru_main_color")
  // 返回按钮
  backIcon?: string | PixelMap | Resource = $r("app.media.ru_navbar_back")
  // 是否隐藏返回按钮
  hideBack: boolean = false

  // 左右常规菜单
  leftMemus?: RKTNavBarMenuItem[] = undefined
  rightMemus?: RKTNavBarMenuItem[] = undefined

  @Builder doNothingBuilder() {}

  // 自定义title（自定义title的视图会处于最顶层位置且不受内部约束影响）
  @BuilderParam customTitle: CustomBuilder = this.doNothingBuilder
  // 自定义左菜单（受内部约束影响，不想被约束就使用`customTitle`）
  @BuilderParam customLeftMemus: CustomBuilder = this.doNothingBuilder
  // 自定义右菜单（受内部约束影响，不想被约束就使用`customTitle`）
  @BuilderParam customRightMemus: CustomBuilder = this.doNothingBuilder

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
      .height($r('app.float.ru_navBar_height')).width('100%')
    }
    .width('100%')
    .backgroundColor(this.barColor ?? $r("app.color.ru_main_color"))
    // 设置顶部绘制延伸到状态栏
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  // 是否有返回按钮
  private isBackButton(): boolean {
    console.log('routerLength' + router.getLength())
    if (router.getLength() == '1') {
      return false
    }
    return !this.hideBack
  }

  // 左侧菜单栏
  @Builder leftMemuBar() {
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
  }

  // 中间标题栏
  @Builder titleBar() {
    if (this.customTitle && this.customTitle != this.doNothingBuilder) {
      Column() {
        this.customTitle()
      }
      .justifyContent(FlexAlign.Center)
      .height('100%')
      .alignRules({
        center: {anchor: "__container__", align: VerticalAlign.Center},
        middle: {anchor: "__container__", align: HorizontalAlign.Center}
      })
      .id("__titleBar1")
      .zIndex(1)
    } else  {
      Column() {
        Text(this.title)
          .align(Alignment.Center)
          .fontSize(this.titleSize).fontWeight(this.titleWeight).fontColor(this.titleColor)
          .textOverflow({ overflow: TextOverflow.Ellipsis }) // 限制为一行 ellipses
          .maxLines(1)
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .height('100%')
      .alignRules({
        center: {anchor: "__container__", align: VerticalAlign.Center},
        middle: {anchor: "__container__", align: HorizontalAlign.Center},
        left: {anchor: 'leftMemuBar', align: HorizontalAlign.End},
        right: {anchor: 'rightMemuBar', align: HorizontalAlign.Start}
      })
      .displayPriority(99)
      .id("__titleBar2")
    }
  }

  // 右侧菜单栏
  @Builder rightMemuBar() {
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
      right: {anchor: "__container__", align: HorizontalAlign.End}
    })
    .displayPriority(100)
    .id("__rightMemuBar")
  }

  // 默认返回按钮
  @Builder leftBackBar() {
    Row(){
      Image(this.backIcon)
        .width(10).height(20)
        .margin({ left: 15 })
    }
    .width('44').height('44')
    .justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Center)
    .onClick(() => {
      router.back()
    })
  }

  /**
   * 默认菜单UI样式
   * @param items 数据源
   * @param padding 内边距
   */
  @Builder normalMemus(items: Array<RKTNavBarMenuItem> | undefined, padding: Padding) {
    Row({ space: 10 }) {
      if (Array.isArray(items)) {
        ForEach(items, (item: RKTNavBarMenuItem)  => {
          if (item.title) {
            Text(item.title)
              .align(Alignment.Center)
              .fontSize(item.titleSize ? item.titleSize : 15).fontWeight(item.titleWeight ? item.titleWeight : FontWeight.Medium).fontColor(item.titleColor ? item.titleColor : Color.White)
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
}
