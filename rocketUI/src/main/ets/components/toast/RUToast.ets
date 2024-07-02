/**
 * Author:fanlilin
 * Date:2024/3/28
 * Descrobe:
 */

import router from '@ohos.router'
import hilog from '@ohos.hilog'
import RUEventBus, { RUEventData } from '../../utils/RUEventBus'

// show Toast event name
const EVENT_SHOW_TOAST: string = "showToast"

/**
 * RUToast 组件快速调用接口（需要配合RUPage使用）
 */
export namespace RUToastUtil {

  interface RUToastOptions {
    // 显示文本
    message: string
    // 延时消失时间
    duration?: number
    // 显示在屏幕的位置
    position?: RUToastPosition
  }

  /**
   * 显示一个消息提示
   * @param message 文本 | 可选参数
   */
  export function show(message: string | RUToastOptions) {
    let data: Record<string, string | number> = {}
    if (typeof message === 'string') {
      data['message'] = message
      data['duration'] = 2000
      data['position'] = RUToastPosition.center
    } else {
      data['message'] = message.message
      data['duration'] = message.duration ?? 2000
      data['position'] = message.position ?? RUToastPosition.center
    }
    RUEventBus.emit(EVENT_SHOW_TOAST, data)
  }
}

/**
 * 显示位置
 */
export enum RUToastPosition {
  // 居中
  center = 0,
  // 顶部
  top,
  // 底部
  bottom
}

@Component
export struct RUToast {
  // 消息文本
  @State message: string = ''
  // 显示位置
  @State @Watch('onShowPositionUpdated') showPosition: RUToastPosition = RUToastPosition.center
  // 延时消失时间 2s
  duration?: number = 2000
  // 文本字体颜色
  fontColor: ResourceColor = `#FFFFFFFF`
  // 文本字体大小
  fontSize: number | string = 16
  // 赋予组件快速能力
  fastAbility: boolean = false
  // 绑定父组件id（想要赋予快速能力需要绑定父组件的UniqueId）
  parentUniqueId: number = -1
  // 是否显示
  @State show: boolean = true
  @State showPositionY: string = '50%'
  private timeID: number = 0

  // MARK: - 组件即将出现时
  aboutToAppear(){
    this.registerEvent()
  }

  // MARK: - 组件即将销毁
  aboutToDisappear(){
    this.unregisterEvent()
  }

  build() {
    Column() {
      Column() {
        Text(this.message)
          .fontColor(this.fontColor).fontSize(this.fontSize).fontWeight(FontWeight.Regular)
          .textAlign(TextAlign.Center)
      }
      .align(Alignment.Center).alignItems(HorizontalAlign.Center).alignSelf(ItemAlign.Center)
      .constraintSize({ maxWidth:345, minHeight:45 })
      .padding({ left:20, right:20, top:12, bottom:12 })
      .borderRadius(7)
      .backgroundColor(`#99000000`)
    }
    .hitTestBehavior(HitTestMode.Transparent)
    .width('100%')
    .align(Alignment.Center).alignItems(HorizontalAlign.Center)
    .position({ x: 0, y: this.showPositionY })
    .zIndex(999)
    .visibility(this.show ? Visibility.Visible : Visibility.Hidden)
    .transition({ type: TransitionType.Insert, opacity: 1 })
  }

  // MARK: - 显示位置更新变化
  onShowPositionUpdated() {
    switch (this.showPosition) {
      case RUToastPosition.top:
        this.showPositionY = '15%'
        break;
      case RUToastPosition.bottom:
        this.showPositionY = '85%'
        break;
      default:
        this.showPositionY = '50%'
        break;
    }
  }

  timeoutClose() {
    if (this.timeID) {
      clearTimeout(this.timeID)
      this.timeID = 0
    }

    this.timeID = setTimeout(() => {
      this.show = false
      this.timeID = 0
    }, this.duration)
  }

  // MARK: - 注册事件
  registerEvent() {
    try {
      let routerState = router.getState();
      let currentPagePath = routerState.path + routerState.name

      if (!this.fastAbility) { return }

      // 注册显示事件
      RUEventBus.on({
        eventName: EVENT_SHOW_TOAST,
        target: this, callback: (next: RUEventData) => {
          // 不是当前页面发来的不处理
          if (next.pathName != currentPagePath) { return }
          if (next.pathId != -1 && next.pathId != this.parentUniqueId) { return }
          if (!next.data) { return }

          let message = next.data["message"] as string
          if (message && message.length > 0) {
            this.message = message
          } else {
            // 没有文字,不展示
            return
          }

          this.showPosition = next.data["position"] as RUToastPosition
          this.duration = next.data["duration"] as number ?? 2000

          animateTo({ duration: 200, curve: Curve.EaseIn}, () => {
            this.show = true
          })
          this.timeoutClose()
        }
      })

    } catch (error) {
      hilog.info(0xFFFF00 , `RocketUI`, "RUToast registerEvent" + error)
    }
  }

  // MARK: - 注销事件
  unregisterEvent() {
    RUEventBus.off(EVENT_SHOW_TOAST, this)
  }
}