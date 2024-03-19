/**
 * Author:fanlilin
 * Date:2024/1/10
 * Descrobe:
 */
import lottie from '@ohos/lottie'
import { AnimationItem } from '@ohos/lottie'
import util from '@ohos.util'
import common from '@ohos.app.ability.common'
import router from '@ohos.router'
import hilog from '@ohos.hilog'
import RKTEventBus, { RKTEventData } from '../utils/RKTEventBus'
import thermal from '@ohos.thermal'

/**
 * 样式
 */
export enum RKTProgressStyle {
  // 转圈
  rotate = 0,
  // 沙漏效果
  sandClock,
  // '经营帮'字跳舞
  wordDance,
  // 前进进度条 - 预留的 暂不支持
  forward
}

/**
 * RKTProgress 组件快速调用接口（需要配合RKTPage使用）
 */
export class RKTProgressUtil {
  /**
   * 加载loding
   * @param style 样式
   * @param message 文本
   */
  public static showLoading(style: RKTProgressStyle = RKTProgressStyle.rotate, message?: string) {
    let data = {
      "style": style,
      "message": message
    }
    RKTEventBus.emit("showLoading", data)
  }

  /**
   * 隐藏当前loding
   */
  public static hideLoading() {
    RKTEventBus.emit("hideLoading")
  }

  /**
   * 隐藏所有loding
   */
  public static hideAllLoading() {
    RKTEventBus.emit("hideAllLoading")
  }
}

@Component
@CustomDialog
export struct RKTProgress {
  controller: CustomDialogController
  message?: string = ''
  style: RKTProgressStyle = RKTProgressStyle.rotate

  // 是否显示
  @State show: boolean = true
  @State refreshFlag: boolean = true

  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings)
  private animateItem: AnimationItem | null = null
  private mLottieData: object | null = null
  private animateName: string = "rocketProgress"

  private animateSize: SizeOptions = { width: 50, height: 50 }
  private boxBorderSize: SizeOptions = { width: 80, height: 80 }
  private boxBorderRadius: Length = 10
  private boxBackgroundColor: ResourceColor = '0x88000000'

  // 当前是否已经加载
  private isLoaded: boolean = false
  private onReady: boolean = false
  // 当前页面路径, 只有当前页面中的loading才会响应,其他页面的事件不响应
  private currentPagePath: string = ""

  // MARK: - 组件即将出现时
  async aboutToAppear() {
    this.registerEvent()
    this.reloadConfig()
  }

  // MARK: - 组件即将消失
  aboutToDisappear(){
    lottie.destroy(this.animateName)
    RKTEventBus.off('showLoading', this)
    RKTEventBus.off('hideLoading', this)
    RKTEventBus.off('hideAllLoading', this)
    hilog.info(0xFFFF00 , `RocketUI`, "RKTProgress lottie动画销毁了" )
  }

  // MARK: -布局UI
  build() {
    Column() {
      if (this.show) {
        Column() {
          Canvas(this.canvasRenderingContext)
            .size(this.animateSize)
            .alignSelf(ItemAlign.Center).align(Alignment.Center)
            .onReady(() => {
              this.onReady = true
              // 在此生命回调周期中加载动画，可以保证动画尺寸正确
              this.startAnimation()
              hilog.info(0xFFFF00 , `RocketUI`, "RKTProgress onReady")
            })
            .onDisAppear(() => {
              lottie.destroy(this.animateName);
            })
          if (this.message && this.message.length > 0) {
            Text(this.message)
              .fontColor('#FFFFFFFF').fontSize(11).fontWeight(FontWeight.Regular)
              .textAlign(TextAlign.Center)
              .margin({ top: 5, bottom: 5 })
              .constraintSize({ maxWidth: 71 })
          }
        }
        .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center).align(Alignment.Center)
        .backgroundColor(this.boxBackgroundColor)
        .borderRadius(this.boxBorderRadius)
        .width(this.boxBorderSize.width)
        .constraintSize({ minHeight: this.boxBorderSize.height })
      }
    }
    .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center).align(Alignment.Center)
    .backgroundColor(Color.Transparent)
    .width('100%').height('100%')
    .position({
      x: 0,
      y: 0,
    })
    .zIndex(9999)
    .visibility(this.show ? Visibility.Visible : Visibility.None)
  }

  // MARK: - 加载配置
  async reloadConfig() {
    this.mLottieData = null
    let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true })
    let context = getContext(this).createModuleContext('rocketUI') as common.UIAbilityContext

    let animatePath = '';
    switch (this.style) {
      case RKTProgressStyle.sandClock:
        animatePath = 'loading_shalou.json'
        this.animateSize = { width: 62, height: 62 }
        this.boxBorderSize = { width: 100, height: 100 }
        this.boxBorderRadius = 10
        this.boxBackgroundColor = '#80000000'
        break;
      case RKTProgressStyle.wordDance:
        animatePath = 'loading_7.json'
        this.animateSize = { width: 200, height: 200 }
        this.boxBorderSize = { width: 220, height: 220 }
        this.boxBorderRadius = 0
        this.boxBackgroundColor = Color.Transparent
        break;
      case RKTProgressStyle.rotate:
      default:
        animatePath = 'loading_2.json'
        this.animateSize = { width: 80, height: 80 }
        this.boxBorderSize = { width: 80, height: 80 } // 因动画属性有内动画边距这里保持一致
        this.boxBorderRadius = 10
        this.boxBackgroundColor = '#80000000'
        break;
    }

    // 这里是一个异步方法，可能在build - Canvas - onReady会先执行
    let buffer = await context.resourceManager.getRawFileContent(animatePath)
    if(buffer === null || buffer === undefined){ return }

    let lottieStr = resStr.decodeWithStream(new Uint8Array(buffer))
    this.mLottieData = JSON.parse(lottieStr);
    if (!this.isLoaded) {
      this.startAnimation()
    }
  }

  // MARK: - 开始动画
  startAnimation() {
    if (!this.onReady) { return }
    if (this.animateItem == null && this.mLottieData != null) {
      let contexts = getContext(this).createModuleContext('rocketUI') as common.UIAbilityContext
      if (contexts == null) { return }
      this.animateItem = lottie.loadAnimation({
        container: this.canvasRenderingContext,
        renderer: 'canvas', // canvas 渲染模式
        loop: true,
        autoplay: true,
        context: contexts,
        name: this.animateName,
        animationData: this.mLottieData,
      })
      this.isLoaded = true
    } else if (this.animateItem) {
      this.animateItem.play(this.animateName)
    }
  }

  // 销毁当前动画
  destroyAnimation() {
    lottie.destroy(this.animateName)
    this.animateItem = null
    this.isLoaded = false
    this.onReady = false
    this.refreshFlag = false
  }

  // MARK: - 注册事件
  registerEvent() {
    try {
      let routerState = router.getState();
      this.currentPagePath = routerState.path + routerState.name

      // 注册显示事件
      RKTEventBus.on({
        eventName: "showLoading",
        target: this, callback: (next: RKTEventData) => {
          // 不是当前页面发来的不处理
          if (next.pathName != this.currentPagePath) { return }

          let message = next.data["message"] as string
          if (typeof message != 'undefined' && message.length > 0) {
            this.message = message
          } else {
            this.message = null
          }

          let style = next.data["style"] as RKTProgressStyle
          if (style != this.style) {
            this.style = style
            this.destroyAnimation()
            this.reloadConfig()
          } else {
            this.startAnimation()
          }

          this.show = true
          this.refreshFlag = true
        }
      })

      // 注册隐藏事件
      RKTEventBus.on({
        eventName: "hideLoading",
        target: this, callback: (next: RKTEventData) => {
          // 不是当前页面发来的不处理
          if (next.pathName != this.currentPagePath) { return }

          this.show = false
          this.destroyAnimation()
        }
      })

      // 注册隐藏事件
      RKTEventBus.on({
        eventName: "hideAllLoading",
        target: this, callback: (next: RKTEventData) => {

          this.show = false
          this.destroyAnimation()
        }
      })

    } catch (error) {
      hilog.info(0xFFFF00 , `RocketUI`, "RKTProgress registerEvent" + error)
    }
  }
}