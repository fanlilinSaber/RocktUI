/**
 * Author:fanlilin
 * Date:2024/1/10
 * Descrobe:用于显示加载动效和进度条组件
 */
import lottie from '@ohos/lottie'
import { AnimationItem } from '@ohos/lottie'
import util from '@ohos.util'
import common from '@ohos.app.ability.common'
import router from '@ohos.router'
import hilog from '@ohos.hilog'
import RKTEventBus, { RKTEventData } from '../../utils/RKTEventBus'


// show loading event name
const EVENT_SHOW_LOADING: string = "showLoading"
// hide current loading event name
const EVENT_HIDE_LOADING: string = "hideLoading"
// hide all loading event name
const EVENT_HIDE_All_LOADING: string = "hideAllLoading"
// show progress event name
const RKT_EVENT_SHOW_PROGRESS: string = "showProgress"

/**
 * RKTProgress 组件快速调用接口（需要配合RKTPage使用）
 */
export namespace RKTProgressUtil {

  export interface RKTProgressOptions {
    style?: RKTProgressStyle
    message?: string
  }

  /**
   * 加载loding
   * @param value 样式 | 可选参数 | 自定义动画参数
   */
  export function showLoading(value?: RKTProgressStyle | RKTProgressOptions | RKTProgressElement) {
    var data = {"style": RKTProgressStyle.rotate}
    if (typeof value === 'number') {
      data['style'] = value
    } else if (typeof value === 'object') {
      let options = value as RKTProgressOptions
      if (options.style === undefined) {
        data['style'] = RKTProgressStyle.custom
        data['progressItem'] = value
      } else {
        data['style'] = options.style
        data['message'] = options.message
      }
    }
    RKTEventBus.emit(EVENT_SHOW_LOADING, data)
  }

  /**
   * 显示进度器（用于下载或者需要操作处理进度的）
   * @param value 当前进度；总的为1
   */
  export function showProgress(value: number) {

  }


  /**
   * 隐藏当前loding
   */
  export function hideLoading() {
    RKTEventBus.emit(EVENT_HIDE_LOADING)
  }

  /**
   * 隐藏所有loding
   */
  export function hideAllLoading() {
    RKTEventBus.emit(EVENT_HIDE_All_LOADING)
  }
}

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
  forward,
  // 自定义动画样式
  custom
}

/**
 * 配置动画参数
 */
export interface RKTProgressElement {
  // 动画大小
  animateSize?: SizeOptions
  // 画布大小
  boxBorderSize?: SizeOptions
  // 画布圆角
  boxBorderRadius?: Length
  // 画布背景色
  boxBackgroundColor?: ResourceColor
  // json格式的动画数据, 仅限json格式（配合 style = custom 可以自定义动画）
  lottieData?: object | null
  // 显示文本
  message?: string
}

/**
 * 动画配置
 */
@Observed
export class RKTProgressItem implements RKTProgressElement {
  animateSize: SizeOptions = { width: 50, height: 50 }
  boxBorderSize: SizeOptions = { width: 80, height: 80 }
  boxBorderRadius: Length = 10
  boxBackgroundColor: ResourceColor = `#80000000`
  lottieData: object | null
  message?: string

  constructor(t?: RKTProgressElement) {
    this.animateSize = t?.animateSize
    this.boxBorderSize = t?.boxBorderSize
    this.boxBorderRadius = t?.boxBorderRadius
    this.boxBackgroundColor = t?.boxBackgroundColor
    this.lottieData = t?.lottieData
    this.message = t?.message
  }

  /**
   * 重载动画默认样式相关配置
   * @param 样式
   */
  public reload(style: RKTProgressStyle, message?: string) {
    switch (style) {
      case RKTProgressStyle.custom:
        // 自定义动画在外面配置
        break;
      case RKTProgressStyle.sandClock:
        this.animateSize = { width: 62, height: 62 }
        this.boxBorderSize = { width: 100, height: 100 }
        this.boxBorderRadius = 10
        this.boxBackgroundColor = '#80000000'
        this.message = message
        break;
      case RKTProgressStyle.wordDance:
        this.animateSize = { width: 200, height: 200 }
        this.boxBorderSize = { width: 220, height: 220 }
        this.boxBorderRadius = 0
        this.boxBackgroundColor = Color.Transparent
        this.message = message
        break;
      case RKTProgressStyle.rotate:
      default:
        this.animateSize = { width: 80, height: 80 }
        this.boxBorderSize = { width: 80, height: 80 } // 因动画属性有内动画边距这里保持一致
        this.boxBorderRadius = 10
        this.boxBackgroundColor = '#80000000'
        this.message = message
        break;
    }
  }
}

@Component
@CustomDialog
export struct RKTProgress {
  controller: CustomDialogController
  message?: string = ''
  // 外部自定义样式配合 progressItem 使用
  style: RKTProgressStyle = RKTProgressStyle.rotate

  // 是否显示
  @State show: boolean = true

  @State progressItem: RKTProgressItem = new RKTProgressItem()

  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings)
  private animateItem: AnimationItem | null = null
  private animateName: string = "rocketProgress"

  // 当前是否已经加载
  private isLoaded: boolean = false
  // 渲染画布是否准备好
  private onReady: boolean = false
  // 当前页面路径, 只有当前页面中的loading才会响应,其他页面的事件不响应
  private currentPagePath: string = ""

  // MARK: - 组件即将出现时
  async aboutToAppear() {
    this.registerEvent()
    this.reloadAnimation()
  }

  // MARK: - 组件即将销毁
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
            .size(this.progressItem.animateSize)
            .alignSelf(ItemAlign.Center).align(Alignment.Center)
            .onReady(() => {
              this.onReady = true
              // 在此生命回调周期中加载动画，可以保证动画尺寸正确
              this.startAnimation()
              hilog.info(0xFFFF00 , `RocketUI`, "RKTProgress Canvas onReady")
            })
            .onDisAppear(() => {
              this.destroyAnimation()
              hilog.info(0xFFFF00 , `RocketUI`, "RKTProgress Canvas onDisAppear")
            })
          if (this.progressItem.message && this.progressItem.message.length > 0) {
            Text(this.progressItem.message)
              .fontColor('#FFFFFFFF').fontSize(11).fontWeight(FontWeight.Regular)
              .textAlign(TextAlign.Center)
              .margin({ top: 5, bottom: 5 })
              .constraintSize({ maxWidth: 71 })
          }
        }
        .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center).align(Alignment.Center)
        .backgroundColor(this.progressItem.boxBackgroundColor)
        .borderRadius(this.progressItem.boxBorderRadius)
        .width(this.progressItem.boxBorderSize.width)
        .constraintSize({ minHeight: this.progressItem.boxBorderSize.height })
      }
    }
    .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center).align(Alignment.Center)
    .backgroundColor(Color.Transparent)
    .width('100%').height('100%')
    .position({ x: 0, y: 0 })
    .zIndex(9999)
    .visibility(this.show ? Visibility.Visible : Visibility.None)
  }

  // MARK: - 重新载入动画和配置
  async reloadAnimation() {
    try {
      this.destroyAnimation()

      // 自定义动画样式需传入json格式的动画数据
      if (this.style == RKTProgressStyle.custom && this.progressItem.lottieData == null) {
        hilog.error(0xFFFF00 , `RocketUI`, "RKTProgress 自定义动画样式需传入json格式的动画数据")
        return
      }

      // 重载动画画布相关配置
      this.progressItem.reload(this.style, this.message)

      if (this.progressItem.lottieData == null) {
        let animatePath = '';
        switch (this.style) {
          case RKTProgressStyle.sandClock:
            animatePath = 'loading_shalou.json'
            break;
          case RKTProgressStyle.wordDance:
            animatePath = 'loading_7.json'
            break;
          case RKTProgressStyle.rotate:
          default:
            animatePath = 'loading_2.json'
            break;
        }

        let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true })
        let context = getContext(this).createModuleContext('rocketUI') as common.UIAbilityContext

        // 这里是一个异步方法，可能在build - Canvas - onReady之后执行
        let buffer = await context.resourceManager.getRawFileContent(animatePath)
        if(buffer === null || buffer === undefined){ return }

        let lottieStr = resStr.decodeWithStream(new Uint8Array(buffer))
        this.progressItem.lottieData = JSON.parse(lottieStr);
      }

      // 默认自动播放动画
      if (!this.isLoaded) {
        this.startAnimation()
      }
    } catch (error) {
      hilog.error(0xFFFF00 , `RocketUI`, "RKTProgress reloadAnimation" + error)
    }
  }

  // MARK: - 开始动画
  startAnimation() {
    if (!this.onReady) { return }
    if (this.animateItem == null && this.progressItem.lottieData != null) {
      let contexts = getContext(this).createModuleContext('rocketUI') as common.UIAbilityContext
      if (contexts == null) { return }
      this.animateItem = lottie.loadAnimation({
        container: this.canvasRenderingContext,
        renderer: 'canvas', // canvas 渲染模式
        loop: true,
        autoplay: true,
        context: contexts,
        name: this.animateName,
        animationData: this.progressItem.lottieData,
      })
      this.isLoaded = true
    } else if (this.animateItem) {
      this.animateItem.play(this.animateName)
    }
  }

  // MARK: - 销毁当前动画
  destroyAnimation() {
    lottie.destroy(this.animateName)
    this.animateItem = null
    this.isLoaded = false
    this.onReady = false
  }

  // MARK: - 注册事件
  registerEvent() {
    try {
      let routerState = router.getState();
      this.currentPagePath = routerState.path + routerState.name
      this.animateName = this.animateName + this.currentPagePath

      // 注册显示Loading事件
      RKTEventBus.on({
        eventName: EVENT_SHOW_LOADING,
        target: this, callback: (next: RKTEventData) => {
          // 不是当前页面发来的不处理
          if (next.pathName != this.currentPagePath) { return }

          // 因为鸿蒙的消息机制限制，这里接收到的对象不具备class能力，需要赋值更新
          let progressItem = next.data["progressItem"] as RKTProgressItem
          if (progressItem) {
            this.style = next.data["style"] as RKTProgressStyle
            this.progressItem.animateSize = progressItem.animateSize
            this.progressItem.boxBorderSize = progressItem.boxBorderSize
            this.progressItem.boxBorderRadius = progressItem.boxBorderRadius
            this.progressItem.boxBackgroundColor = progressItem.boxBackgroundColor
            this.progressItem.lottieData = progressItem.lottieData
            this.progressItem.message = progressItem.message
            this.reloadAnimation()
            this.show = true
          }

          let message = next.data["message"] as string
          if (typeof message != 'undefined' && message.length > 0) {
            this.message = message
          } else {
            this.message = null
          }
          this.progressItem.message = this.message

          // 如果当前动画样式不一致则重新刷新
          let style = next.data["style"] as RKTProgressStyle
          if (style != this.style) {
            this.style = style
            this.progressItem.lottieData = null
            this.reloadAnimation()
          } else {
            // 当前动画已在加载不处理
            if (this.show && this.isLoaded) { return }
            this.startAnimation()
          }
          this.show = true
        }
      })

      // 注册隐藏Loading事件
      RKTEventBus.on({
        eventName: EVENT_HIDE_LOADING,
        target: this, callback: (next: RKTEventData) => {
          // 不是当前页面发来的不处理
          if (next.pathName != this.currentPagePath) { return }

          this.show = false
          this.destroyAnimation()
        }
      })

      // 注册隐藏所有Loading事件
      RKTEventBus.on({
        eventName: EVENT_HIDE_All_LOADING,
        target: this, callback: (next: RKTEventData) => {

          this.show = false
          this.destroyAnimation()
        }
      })

    } catch (error) {
      hilog.info(0xFFFF00 , `RocketUI`, "RKTProgress registerEvent" + error)
    }
  }

  // MARK: - 注销事件
  unregisterEvent() {
    RKTEventBus.off(EVENT_SHOW_LOADING, this)
    RKTEventBus.off(EVENT_HIDE_LOADING, this)
    RKTEventBus.off(EVENT_HIDE_All_LOADING, this)
  }
}