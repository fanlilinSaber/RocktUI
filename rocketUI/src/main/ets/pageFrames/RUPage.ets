/**
 * Author:fanlilin
 * Date:2024/1/19
 * Descrobe:
 */

import { RUProgress, RUProgressFastAbility } from '../components/progress/RUProgress'
import { RUNavBar, RUNavBarAppearance,
  RUNavBarAppearanceMode,
  RUNavBarMenuItem } from '../components/navBar/RUNavBar'
import { RUAlertComponent } from '../components/dialog/RUAlertComponent';
import { RUToast } from '../components/toast/RUToast';
import { NEW_PAGE_TAG, NAVBAR_HEIGHT, OLD_PAGE_TAG, RU_LOG_DOMAIN } from '../constants/RUConstants'
import RUEventBus from '../utils/RUEventBus'
import RUConfig from '../config/RUConfig';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Builder
function empty() {
}

/**
 * 作为页面基础容器，自定义页面的容器，提供了常规的基础能力，即加载数据loading功能、toast功能、顶部导航栏（一个页面保证只有一个RUPage）
 * 注意：因自定义组件内有且仅有一个使用@BuilderParam装饰的属性才可尾随闭包初始化组件，这里为了保持组件的使用简洁性不直接关联更多@BuilderParam，如果使用到了自定义项请关闭默认`navBar` 属性，直接使用组件`RUNavBar`即可
 * 使用：在@Entry装饰的页面，需要用build(){}函数里用系统的根容器组件（Row、Column）包一层；Column() { RUPage(){} }.height('100%')，如果只用@Component修饰过的组件，直接用RUPage(){}即可
 */

@Component
export struct RUPage {
  // 导航栏（如果要自定义title和菜单，请关闭此属性，建议使用`RUNavBar`自定义）
  navBar: boolean = true
  // 导航栏标题（会根据左右两边菜单占用的宽度控制是否居中显示，如果居中显示有重叠就不相对屏幕居中显示了）
  @Prop title: string
  titleColor: ResourceColor = Color.White
  titleSize?: number | string = 17
  titleWeight?: number | FontWeight | string = FontWeight.Medium

  // Page背景色
  bgcolor: ResourceColor = Color.White
  // 导航背景色（因无法获取组件默认的backgroundColor属性作为条件判断值，单独提供一个来设置默认色，不用在外面设置 backgroundColor）
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
  navPathStack?: NavPathStack = undefined

  // 左右常规菜单
  leftMemus?: RUNavBarMenuItem[] = undefined
  rightMemus?: RUNavBarMenuItem[] = undefined

  // loading能力；默认 = true
  loadingAbility: boolean = true
  // toast能力；默认 = true
  toastAbility: boolean = true
  // 常用提示弹窗能力；默认 = true
  alertAbility: boolean = true
  // 任务进度能力；默认 = true
  progressAbility: boolean = true

  @Builder private closerBuilder() {}
  // 尾随闭包初始化 (此场景下自定义组件内有且仅有一个使用@BuilderParam装饰的属性。)
  @BuilderParam closer: () => void

  // 准备好了，可以在这里下一步操作，比如一进页面要显示快速显示loading：RUProgressUtil.showLoading()（因鸿蒙特性，凡是跟UI相关组件都必须build函数里面，所以想要进入页面就调用快速能力，在这个回调时机最合适）
  onReady?: () => void
  // 页面显示回调（用了Navigation的方式才有这个回调）
  onShown?: () => void
  // 页面消失回调，(用了Navigation的方式才有这个回调)
  onHidden?: () => void
  // 自定义title，这里为了保持尾随闭包使用效果使用组件工厂`WrappedBuilder`方式，但是`WrappedBuilder`只能引用全局的@Builder，如还是不满足自己的使用，请直接使用RUNavBar或者自定义
  customTitle?: WrappedBuilder<[]>

  private navOffsetY?: number
  private uniqueId?: number

  // MARK: -aboutToAppear
  aboutToAppear() {
    if (!this.navPathStack) {
      // this指代MyComponent自定义节点，并从该节点向上查找其最近的一个类型为Navigation的父亲节点
      this.navPathStack = this.queryNavigationInfo()?.pathStack
    }
    this.navOffsetY = px2vp(RUConfig.statusBarHeight) + NAVBAR_HEIGHT
    this.uniqueId = this.getUniqueId()
    AppStorage.setOrCreate(NEW_PAGE_TAG, this.uniqueId)
  }

  // MARK: -布局UI
  build() {
    if (this.navPathStack) {
      NavDestination() {
        this.contentView()
      }
      .hideTitleBar(true)
    } else {
      this.contentView()
    }
  }

  @Builder
  private contentView() {
    Column() {
      if (this.navBar) {
        RUNavBar({
          title: this.title,
          titleColor: this.titleColor,
          titleSize: this.titleSize,
          titleWeight: this.titleWeight,
          barColor: this.barColor,
          backIcon: this.backIcon,
          hideBack: this.hideBack,
          leftMemus: this.leftMemus,
          rightMemus: this.rightMemus,
          navPathStack: this.navPathStack,
          backFillColor: this.backFillColor,
          onClickBack: this.onClickBack,
          appearance: this.appearance,
          appearanceMode: this.appearanceMode,
          forceCenter: this.forceCenter,
          customTitle: this.customTitle ? (): void => { this.titleBuilder() } : undefined
        })
      }

      Column(){
        this.closer()
      }.layoutWeight(1)

      if (this.loadingAbility) {
        RUProgress({ show: false, fastAbility: RUProgressFastAbility.Loading, offsetY: this.navBar ? this.navOffsetY : 0, tag: this.uniqueId })
      }

      if (this.toastAbility) {
        RUToast({ show: false, fastAbility: true, tag: this.uniqueId })
      }

      if (this.alertAbility) {
        RUAlertComponent({ tag: this.uniqueId })
      }

      if (this.progressAbility) {
        RUProgress({ show: false, fastAbility: RUProgressFastAbility.Progress, tag: this.uniqueId })
      }
    }
    .width('100%').height('100%')
    .backgroundColor(this.bgcolor)
    .onAppear(this.onReady)
    // 通过设置ratios为[0.0, 1.0]，实现当组件完全显示或完全消失在屏幕中时触发回调（解决作为子组件嵌套(比如：`TabContent()`)不会触发NavDestination的`onShow`回调）
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio >= 0.0 && currentRatio < 1.0) { // 将要出现(bug：不会触发)
        hilog.info(RU_LOG_DOMAIN, `RocketUI`, "RUPage page will show")
      } else if (isVisible && currentRatio >= 1.0) { // 完全出现
        hilog.info(RU_LOG_DOMAIN, `RocketUI`, "RUPage on show")
        AppStorage.setOrCreate(NEW_PAGE_TAG, this.uniqueId)
        this.onShown && this.onShown()
      } else if (!isVisible && currentRatio > 0.0 && currentRatio < 1.0) { // 将要消失
        hilog.info(RU_LOG_DOMAIN, `RocketUI`, "RUPage page will hide")
      } else if (!isVisible && currentRatio <= 0.0) { // 完全消失
        hilog.info(RU_LOG_DOMAIN, `RocketUI`, "RUPage page on hide")
        AppStorage.setOrCreate(OLD_PAGE_TAG, this.uniqueId)
        this.onHidden && this.onHidden()
      }
    })
  }

  @Builder
  titleBuilder() {
    this.customTitle?.builder()
  }
}

