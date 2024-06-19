/**
 * Author:fanlilin
 * Date:2024/1/19
 * Descrobe:
 */

import { RKTProgress, RKTProgressFastAbility } from '../components/progress/RKTProgress'
import { RKTNavBar, RKTNavBarAppearance,
  RKTNavBarAppearanceMode,
  RKTNavBarMenuItem } from '../components/navBar/RKTNavBar'
import { RKTAlertComponent } from '../components/dialog/RKTAlertComponent';
import { RKTToast } from '../components/toast/RKTToast';
import { NAVBAR_HEIGHT } from '../constants/Constants'

@Builder
function empty() {
}

/**
 * 作为页面基础容器，自定义页面的容器，提供了常规的基础能力，即加载数据loading功能、toast功能、顶部导航栏（一个页面保证只有一个RKTPage）
 * 注意：因自定义组件内有且仅有一个使用@BuilderParam装饰的属性才可尾随闭包初始化组件，这里为了保持组件的使用简洁性不直接关联更多@BuilderParam，如果使用到了自定义项请关闭默认`navBar` 属性，直接使用组件`RKTNavBar`即可
 * 使用：在@Entry装饰的页面，需要用build(){}函数里用系统的根容器组件（Row、Column）包一层；Column() { RKTPage(){} }.height('100%')，如果只用@Component修饰过的组件，直接用RKTPage(){}即可
 */

@Component
export struct RKTPage {
  // 导航栏
  navBar: boolean = true
  // 导航栏title
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

  // 外观属性集中配置（外面可以直接实现接口如：ANavBarAppearance implements RKTNavBarAppearance，BNavBarAppearance implements RKTNavBarAppearance 来集中配置）
  appearance?: RKTNavBarAppearance
  // 外观默认模板（appearance、appearanceMode、barColor...等属性互斥，自定义 appearance 优先级最高）
  appearanceMode: RKTNavBarAppearanceMode = RKTNavBarAppearanceMode.RedMode

  // 如果是基于Navigation的路由管理，必须外部传进来用来做自动显示返回按钮和back操作
  navPathStack?: NavPathStack

  // 左右常规菜单
  leftMemus?: RKTNavBarMenuItem[] = undefined
  rightMemus?: RKTNavBarMenuItem[] = undefined

  // loading能力；默认 = true
  loadingAbility: boolean = true
  // toast能力；默认 = true
  toastAbility: boolean = true
  // 常用提示弹窗能力；默认 = true
  alertAbility: boolean = true
  // 任务进度能力；默认 = true
  progressAbility: boolean = true

  // 尾随闭包初始化 (此场景下自定义组件内有且仅有一个使用@BuilderParam装饰的属性。)
  @BuilderParam closer: () => void

  // 准备好了，可以在这里下一步操作，比如一进页面要显示快速显示loading：RKTProgressUtil.showLoading()（因鸿蒙特性，凡是跟UI相关组件都必须build函数里面，所以想要进入页面就调用快速能力，在这个回调时机最合适）
  private onReady?: () => void

  // MARK: -布局UI
  build() {
    Column() {
      if (this.navBar) {
        RKTNavBar({
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
          appearanceMode: this.appearanceMode })
      }
      this.closer()

      if (this.loadingAbility) {
        RKTProgress({ show: false, fastAbility: RKTProgressFastAbility.Loading, offsetY: this.navBar ? NAVBAR_HEIGHT : 0 })
      }

      if (this.toastAbility) {
        RKTToast({ show: false, fastAbility: true })
      }

      if (this.alertAbility) {
        RKTAlertComponent()
      }

      if (this.progressAbility) {
        RKTProgress({ show: false, fastAbility: RKTProgressFastAbility.Progress })
      }
    }
    .width('100%').height('100%')
    .backgroundColor(this.bgcolor)
    .onAppear(this.onReady)
  }
}
