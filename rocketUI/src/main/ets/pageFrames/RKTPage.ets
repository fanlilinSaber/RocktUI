/**
 * Author:fanlilin
 * Date:2024/1/19
 * Descrobe:
 */

import { RKTProgress } from '../components/progress/RKTProgress'
import { RKTNavBar, RKTNavBarMenuItem } from '../components/navBar/RKTNavBar'
import promptAction from '@ohos.promptAction';
import RKTUtil from '../utils/RKTUtil';
import { RKTAlertComponent } from '../components/dialog/RKTAlertComponent';
import { RKTToast } from '../components/toast/RKTToast';

@Builder
function empty() {
}

/**
 * 作为页面基础架子，自定义页面的容器，提供了常规的基础能力，即加载数据loading功能、toast功能、顶部导航栏
 * 注意：因自定义组件内有且仅有一个使用@BuilderParam装饰的属性才可尾随闭包初始化组件，这里为了保持组件的使用简洁性不直接关联更多@BuilderParam，如果使用到了自定义项请关闭默认`navBar` 属性，直接使用组件`RKTNavBar`即可
 */

@Component
export struct RKTPage {
  // 导航栏
  navBar: boolean = true
  // 导航栏title
  @Prop title: string
  titleColor: ResourceColor = Color.White
  titleFont?: number | string = 17
  titleWeight?: number | FontWeight | string = FontWeight.Medium

  // 背景色（因无法获取组件默认的backgroundColor属性作为条件判断值，单独提供一个来设置默认色，不用在外面设置 backgroundColor）
  barColor?: ResourceColor = '#FFEF4033'
  // 返回按钮
  backIcon?: string | PixelMap | Resource = $r("app.media.navbar_back")
  // 是否隐藏返回按钮
  hideBack: boolean = false

  // 左右常规菜单
  leftMemus?: RKTNavBarMenuItem[] = null
  rightMemus?: RKTNavBarMenuItem[] = null

  // loading能力；默认 = true
  loadingAbility: boolean = true
  // toast能力；默认 = true
  toastAbility: boolean = true
  // 常用提示弹窗
  alertAbility: boolean = true

  // 尾随闭包初始化 (此场景下自定义组件内有且仅有一个使用@BuilderParam装饰的属性。)
  @BuilderParam closer: () => void

  // MARK: -布局UI
  build() {
    Column() {
      if (this.navBar) {
        RKTNavBar({
          title: this.title,
          titleColor: this.titleColor,
          titleFont: this.titleFont,
          titleWeight: this.titleWeight,
          barColor: this.barColor,
          backIcon: this.backIcon,
          hideBack: this.hideBack,
          leftMemus: this.leftMemus,
          rightMemus: this.rightMemus, })
      }
      this.closer()

      if (this.loadingAbility) {
        RKTProgress({ show: false })
      }

      if (this.toastAbility) {

      }

      if (this.alertAbility) {
        RKTAlertComponent()
      }

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}
