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
import RUEventBus, { RUEventData } from '../../utils/RUEventBus'
import RUConfig from '../../config/RUConfig'
import resourceManager from '@ohos.resourceManager'

// show loading event name
const EVENT_SHOW_LOADING: string = "showLoading"
// hide current loading event name
const EVENT_HIDE_LOADING: string = "hideLoading"
// show progress event name
const EVENT_SHOW_PROGRESS: string = "showProgress"
// hide progress event name
const EVENT_HIDE_PROGRESS: string = "hideProgress"
// hide RUProgress event name
const EVENT_HIDE_RU_PROGRESS: string = "hideRUProgress"

const RU_LOG_DOMAIN = 0x00503;

/**
 * RUProgress 组件快速调用接口（需要配合RUPage使用）
 */
export namespace RUProgressUtil {

  type UAny = string | number | undefined | boolean | object

  export interface RUProgressOptions {
    style?: RUProgressStyle
    message?: string
  }

  /**
   * 加载loding（不影响导航栏返回）
   * @param options 样式 | 可选参数 | 自定义动画参数
   * @param tag 指定组件唯一tag
   * @param extraParams 组件内可额外修改的参数（根据业务需求新增维护）
   */
  export function showLoading(options?: RUProgressStyle | RUProgressOptions | RUProgressElement, tag?: string, extraParams?: Record<string, UAny>) {
    let data: Record<string, string | number | undefined | boolean | RUProgressElement | object> = {
      'style': RUProgressStyle.Rotate,
      'tag': tag,
      'offsetEnable': true,
    }

    if (typeof options === 'number') {
      data['style'] = options
    } else if (typeof options === 'object') {
      let any = options as RUProgressElement
      if (any.animateSize != undefined && any.boxBorderSize != undefined) {
        data['style'] = RUProgressStyle.Custom
        data['progressElement'] = any
      } else {
        let any = options as RUProgressOptions
        data['style'] = any.style ?? RUProgressStyle.Rotate
        data['message'] = any.message
      }
    }

    if (extraParams) {
      Object.entries(extraParams).forEach((object) => {
        let key = object[0]
        data[key] = extraParams[key]
      })
    }
    RUEventBus.emit(EVENT_SHOW_LOADING, data)
  }

  /**
   * 加载全屏loding（忽略组件的偏移量设置）
   * @param options 样式 | 可选参数 | 自定义动画参数
   * @param tag 指定组件唯一tag
   */
  export function showWindowLoading(options?: RUProgressStyle | RUProgressOptions | RUProgressElement, tag?: string) {
    let data: Record<string, boolean> = {}
    data['offsetEnable'] = false
    RUProgressUtil.showLoading(options, tag, data)
  }

  /**
   * 显示进度（用于下载或者需要任务处理进度的）
   * @param value 任务进度0~1
   * @param options 可选参数 | 自定义动画参数
   * @param tag 指定组件唯一tag
   */
  export function showProgress(value: number, options?: RUProgressOptions | RUProgressElement, tag?: string) {
    let data: Record<string, number | string | undefined | RUProgressElement> = { 'progress': value, 'tag': tag }
    if (options === undefined) {
      data['style'] = RUProgressStyle.Forward
    } else if (typeof options === 'object') {
      let any = options as RUProgressElement
      if (any.animateSize != undefined && any.boxBorderSize != undefined) {
        data['style'] = RUProgressStyle.Custom
        data['progressElement'] = any
      } else {
        let any = options as RUProgressOptions
        data['style'] = any.style ?? RUProgressStyle.Forward
        data['message'] = any.message
      }
    }
    RUEventBus.emit(EVENT_SHOW_PROGRESS, data)
  }

  /**
   * @param all all = true 隐藏所有页面的
   * @param tag 指定组件唯一tag
   */
  export function hideLoading(all: boolean = false, tag?: string) {
    let data: Record<string, boolean | string | undefined> = { 'type': all ? 'all' : 'current', 'tag': tag }
    RUEventBus.emit(EVENT_HIDE_LOADING, data)
  }

  /**
   * 隐藏任务进度
   * @param all all = true 隐藏所有页面的
   * @param tag 指定组件唯一tag
   */
  export function hideProgress(all: boolean = false, tag?: string) {
    let data: Record<string, boolean | string | undefined> = { 'type': all ? 'all' : 'current', 'tag': tag }
    RUEventBus.emit(EVENT_HIDE_PROGRESS, data)
  }

  /**
   * 隐藏当前的RUProgress组件（注意：如果同时存在 `Loading` 和 `Progress`显示 会隐藏所有）
   * @param all all = true 隐藏所有页面的
   * @param tag 指定组件唯一tag
   */
  export function hide(all: boolean = false, tag?: string) {
    let data: Record<string, boolean | string | undefined> = { 'type': all ? 'all' : 'current', 'tag': tag }
    RUEventBus.emit(EVENT_HIDE_RU_PROGRESS, data)
  }
}

/**
 * 组件快速能力
 */
export enum RUProgressFastAbility {
  None = 0,
  Loading = 1 << 0,
  Progress = 1 << 1,
  All = Loading | Progress
}

/**
 * 样式
 */
export enum RUProgressStyle {
  // 转圈
  Rotate = 0,
  // 沙漏效果
  SandClock,
  // '经营帮'字跳舞
  WordDance,
  // 线条百分比动画（暂时的）
  Forward,
  // 自定义动画样式（需配合`RUProgressItem`使用）
  Custom
}

/**
 * 配置动画参数
 */
export interface RUProgressElement {
  // 动画大小
  animateSize: SizeOptions
  // 画布大小
  boxBorderSize: SizeOptions
  // 画布圆角
  boxBorderRadius?: Length
  // 画布背景色
  boxBackgroundColor?: ResourceColor
  // json格式的动画数据, 仅限json格式（配合 style = custom 可以自定义动画）
  lottieData?: object | null | string
  // 显示文本
  text?: string | null
  // 文本颜色
  textColor?: ResourceColor
}

/**
 * 动画配置
 */
@Observed
export class RUProgressItem implements RUProgressElement {
  @Track animateSize: SizeOptions = { width: 50, height: 50 }
  @Track boxBorderSize: SizeOptions = { width: 80, height: 80 }
  @Track boxBorderRadius?: Length = 10
  @Track boxBackgroundColor?: ResourceColor = `#80000000`
  @Track text?: string | null = null
  @Track textColor?: ResourceColor = `#FFFFFFFF`
  lottieData?: object | null | string = null

  constructor(t?: RUProgressElement) {
    this.animateSize = t?.animateSize ?? this.animateSize
    this.boxBorderSize = t?.boxBorderSize ?? this.boxBorderSize
    this.boxBorderRadius = t?.boxBorderRadius ?? this.boxBorderRadius
    this.boxBackgroundColor = t?.boxBackgroundColor ?? this.boxBackgroundColor
    this.lottieData = t?.lottieData ?? this.lottieData
    this.text = t?.text ?? this.text
    this.textColor = t?.textColor ?? this.textColor
  }

  /**
   * 重载动画默认样式相关配置
   * @param style 样式
   * @param text 文本
   */
  public reload(style: RUProgressStyle, text?: string) {
    switch (style) {
      case RUProgressStyle.Custom:
        // 自定义动画在外面配置
        break;
      case RUProgressStyle.SandClock:
        this.animateSize = { width: 62, height: 62 }
        this.boxBorderSize = { width: 100, height: 100 }
        this.boxBorderRadius = 10
        this.boxBackgroundColor = '#80000000'
        this.text = text
        this.textColor = '#FFFFFFFF'
        break;
      case RUProgressStyle.WordDance:
        this.animateSize = { width: 200, height: 200 }
        this.boxBorderSize = { width: 220, height: 220 }
        this.boxBorderRadius = 0
        this.boxBackgroundColor = Color.Transparent
        this.text = text
        break;
      case RUProgressStyle.Forward:
        this.animateSize = { width: 300, height: 20 }
        this.boxBorderSize = { width: 310, height: 30 }
        this.boxBorderRadius = 0
        this.boxBackgroundColor = Color.Transparent
        this.text = text
        this.textColor = '#FFEF4033'
        break;
      case RUProgressStyle.Rotate:
      default:
        this.animateSize = { width: 80, height: 80 }
        this.boxBorderSize = { width: 80, height: 80 } // 因动画属性有内动画边距这里保持一致
        this.boxBorderRadius = 10
        this.boxBackgroundColor = '#80000000'
        this.text = text
        this.textColor = '#FFFFFFFF'
        break;
    }
  }
}

@Component
@CustomDialog
export struct RUProgress {
  controller: CustomDialogController
  // 外部自定义样式配合 progressItem 使用
  style: RUProgressStyle = RUProgressStyle.Rotate
  // 动画自动播放(禁用自动播放通过 `progress` 来外部控制进度，以实现需要任务进度条的功能)
  autoplay: boolean = true
  // 是否允许交互
  interaction: boolean = false
  // 组件唯一tag，用于同一个页面存在多个同一源的组件区分
  tag: string = ''
  // 赋予组件快速能力（如果配置成`all`，组件的所有状态共享，即代表所有快速操作都会共用这一个组件来切换，当一个页面存在多个`RUProgress`组件时，不想共享状态就为组件配置单个能力）
  fastAbility: RUProgressFastAbility = RUProgressFastAbility.None
  // 绑定父组件id（想要赋予快速能力需要绑定父组件的UniqueId）
  parentUniqueId: number = -1
  // 附带消息内容
  @Prop @Watch('onMessageUpdated') message: string = ''
  // 动画播放进度 progress / 1.0
  @Prop @Watch('onProgressUpdated') progress: number = 0
  // 是否显示
  @State show: boolean = true
  // 动画item
  @State progressItem: RUProgressItem = new RUProgressItem()
  // 组件起点偏移量；默认y:0（用于控制遮挡区域）
  @State offsetY: number = 0
  // 偏移量属性是否激活
  @State offsetEnable: boolean = true

  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings)
  private animateItem: AnimationItem | null = null
  private animateName: string = "rocketProgress"
  // 动画总帧数
  private animationFrames: number = 0
  // 当前是否已经加载
  private isLoaded: boolean = false
  // 渲染画布是否准备好
  private onReady: boolean = false
  // 当前页面路径, 只有当前页面中的事件才会响应,其他页面的事件不响应
  private currentPagePath: string | null = null
  private currentTaskFlag: string | null = null

  // MARK: - 组件即将出现时
  async aboutToAppear() {
    RUConfig
    this.registerEvent()
    this.reloadAnimation()
  }

  // MARK: - 组件即将销毁
  aboutToDisappear(){
    lottie.destroy(this.animateName)
    this.unregisterEvent()
    hilog.info(0xFFFF00 , `RocketUI`, "RUProgress lottie动画销毁了" )
  }

  // MARK: -布局UI
  build() {
    Column() {
      Column() {
        if (this.show) { // 利用重新创建来触发画布的 onReady 和 onDisAppear 确保动画尺寸显示正确，也是为了控制常驻内存大小。
          Canvas(this.canvasRenderingContext)
            .size(this.progressItem.animateSize)
            .alignSelf(ItemAlign.Center).align(Alignment.Center)
            .onReady(() => {
              this.onReady = true
              // 在此生命回调周期中加载动画，可以保证动画尺寸正确
              this.startAnimation()
              hilog.info(RU_LOG_DOMAIN , `RocketUI`, "RUProgress Canvas onReady")
            })
            .onDisAppear(() => {
              this.onReady = false
              this.destroyAnimation()
              hilog.info(RU_LOG_DOMAIN , `RocketUI`, "RUProgress Canvas onDisAppear")
            })
          if (this.progressItem.text && this.progressItem.text.length > 0) {
            Text(this.progressItem.text)
              .fontColor(this.progressItem.textColor).fontSize(11).fontWeight(FontWeight.Regular)
              .textAlign(TextAlign.Center)
              .margin({ top: 5, bottom: 5 })
              .constraintSize({ maxWidth: this.progressItem.boxBorderSize.width })
          }
        }
      }
      .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center).align(Alignment.Center)
      .backgroundColor(this.progressItem.boxBackgroundColor)
      .borderRadius(this.progressItem.boxBorderRadius)
      .width(this.progressItem.boxBorderSize.width)
      .constraintSize({ minHeight: this.progressItem.boxBorderSize.height })
      // .offset({ x: 0, y: this.offsetEnable ? -this.offsetY / 2 : 0 })
    }
    .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center).align(Alignment.Center)
    .backgroundColor(Color.Transparent)
    .width('100%').height(this.offsetEnable ? `calc(100% - ${this.offsetY}vp)` : '100%')
    .position({ x: 0, y: this.offsetEnable ? this.offsetY : 0 })
    .zIndex(9999)
    .visibility(this.show ? Visibility.Visible : Visibility.Hidden)
    .hitTestBehavior(this.interaction ? HitTestMode.Transparent : HitTestMode.Default)
  }

  // MARK: - 重新载入动画和配置
  async reloadAnimation(element?: RUProgressElement) {
    try {
      this.destroyAnimation()
      if (element) {
        this.updateAnimationDisplay(element)
      } else {
        // 重载动画画布相关配置
        this.progressItem.reload(this.style, this.message)
      }

      // 自定义动画样式需传入json格式的动画数据
      if (this.style == RUProgressStyle.Custom && this.progressItem.lottieData == null) {
        hilog.error(RU_LOG_DOMAIN , 'RocketUI', "RUProgress 自定义动画样式需传入json格式的动画数据")
        return
      }

      if (this.progressItem.lottieData == null) {
        let animatePath = '';
        switch (this.style) {
          case RUProgressStyle.SandClock:
            animatePath = 'ru_animation_shalou.json'
            break;
          case RUProgressStyle.WordDance:
            animatePath = 'ru_loading_7.json'
            break;
          case RUProgressStyle.Forward:
            animatePath = 'ru_animation_forward.json'
            break;
          case RUProgressStyle.Rotate:
          default:
            animatePath = 'ru_loading_2.json'
            break;
        }

        let context: Context | null = null
        if (RUConfig.rootModuleName) {
          context = getContext(this).createModuleContext(RUConfig.rootModuleName) as common.UIAbilityContext
        } else {
          context = getContext(this) as common.UIAbilityContext
        }
        if (context == null) { return }

        // 这里是一个异步方法，可能在build - Canvas - onReady之后执行
        let data = await context.resourceManager.getRawFileContent(animatePath)
        if(data === null || data === undefined || data.buffer === undefined){ return }

        let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true })
        let lottieStr = resStr.decodeWithStream(new Uint8Array(data.buffer))
        this.progressItem.lottieData = JSON.parse(lottieStr);
      }

      // 默认自动播放动画
      if (!this.isLoaded) {
        this.startAnimation()
      }
    } catch (error) {
      hilog.error(RU_LOG_DOMAIN , `RocketUI`, "RUProgress reloadAnimation" + (error as Error).message)
    }
  }

  // MARK: - 开始动画
  startAnimation() {
    if (!this.onReady) { return }
    if (this.animateItem == null && this.progressItem.lottieData != null) {
      this.animateName = 'rocketProgress' + this.currentPagePath + this.tag + this.currentTaskFlag + this.parentUniqueId.toString()
      this.animateItem = lottie.loadAnimation({
        container: this.canvasRenderingContext,
        renderer: 'canvas', // canvas 渲染模式
        loop: true,
        autoplay: this.autoplay,
        name: this.animateName,
        animationData: this.progressItem.lottieData,
      })
      this.animationFrames = this.animateItem.getDuration(true)
      hilog.info(RU_LOG_DOMAIN , `RocketUI`, "RUProgress 动画帧数：" + this.animationFrames + 'fps')
      this.isLoaded = true
      // 第一次更新一下动画进度
      if (this.show && !this.autoplay) {
        this.updateAnimationFrames(this.progress)
      }
    } else if (this.animateItem && this.autoplay) {
      this.animateItem.play(this.animateName)
    }
  }

  // MARK: - 显示消息
  onMessageUpdated() {
    if (this.progressItem == null) { return }
    this.progressItem.text = this.message
  }

  // MARK: - 播放进度
  onProgressUpdated() {
    this.updateAnimationFrames(this.progress)
  }

  // MARK: - 更新动画进度
  updateAnimationFrames(progress: number) {
    if (this.autoplay || this.progressItem == null || this.animateItem == null) { return }
    let value = Math.min(Math.abs(progress), 1.0)
    value = value * this.animationFrames
    this.animateItem.goToAndStop(value, true)
    hilog.info(RU_LOG_DOMAIN, `RocketUI`, "RUProgress 播放进度：" + value)
  }

  // MARK: - 更新动画展示（大部分属性会影响UI变化）
  updateAnimationDisplay(element: RUProgressElement) {
    this.progressItem.lottieData = element.lottieData
    this.progressItem.animateSize = element.animateSize
    this.progressItem.boxBorderSize = element.boxBorderSize
    this.progressItem.boxBorderRadius = element.boxBorderRadius
    this.progressItem.boxBackgroundColor = element.boxBackgroundColor
    this.progressItem.text = element.text
    this.progressItem.textColor = element.textColor
  }

  // MARK: - 销毁当前动画
  destroyAnimation() {
    this.animateItem = null
    this.isLoaded = false
    lottie.destroy(this.animateName)
  }

  // MARK: - 注册事件
  registerEvent() {
    try {
      let routerState = router.getState();
      this.currentPagePath = routerState.path + routerState.name

      if (this.fastAbility & RUProgressFastAbility.None) { return }

      // 快速Loading能力
      if (this.fastAbility & RUProgressFastAbility.Loading) {
        // 注册显示Loading事件
        RUEventBus.on({
          eventName: EVENT_SHOW_LOADING,
          target: this, callback: (next: RUEventData) => {
            // 不是当前页面发来的不处理
            if (next.pathName != this.currentPagePath) { return }
            if (next.pathId != -1 && next.pathId != this.parentUniqueId) { return }
            if (!next.data) { return }

            // 如果设置了tag；不是当前tag不处理
            let tag = next.data["tag"] as string
            if (tag != undefined && tag != this.tag) { return }

            this.autoplay = true
            this.currentTaskFlag = EVENT_SHOW_LOADING
            this.offsetEnable = next.data["offsetEnable"] as boolean

            let style = next.data["style"] as RUProgressStyle
            // 因为鸿蒙的消息机制限制，这里接收到的对象不具备class能力，需要赋值更新
            let progressElement = next.data["progressElement"] as RUProgressElement
            if (progressElement) {
              this.style = style
              this.reloadAnimation(progressElement)
            } else {
              this.message = next.data["message"] as string

              // 如果当前动画样式不一致则重新刷新
              if (style != this.style) {
                this.style = style
                this.progressItem.lottieData = null
                this.reloadAnimation()
              } else {
                // 当前动画已在加载不处理
                if (this.show && this.isLoaded) { return }
                this.startAnimation()
              }
            }

            this.show = true
          }
        })

        // 注册隐藏Loading事件
        RUEventBus.on({
          eventName: EVENT_HIDE_LOADING,
          target: this, callback: (next: RUEventData) => {
            if (!next.data) { return }
            let type = next.data["type"] as string
            // 不是当前页面发来的不处理
            if (type == 'current' && next.pathName != this.currentPagePath) { return }
            if (type == 'current' && next.pathId != -1 && next.pathId != this.parentUniqueId) { return }

            // 如果设置了tag；不是当前tag不处理
            let tag = next.data["tag"] as string
            if (tag != undefined && tag != this.tag) { return }
            if (!this.show || this.currentTaskFlag != EVENT_SHOW_LOADING) { return }

            this.currentTaskFlag = EVENT_HIDE_LOADING
            this.show = false
            this.destroyAnimation()
          }
        })
      }

      // 快速Progress能力
      if (this.fastAbility & RUProgressFastAbility.Progress) {
        // 注册显示任务进度事件
        RUEventBus.on({
          eventName: EVENT_SHOW_PROGRESS,
          target: this, callback: (next: RUEventData) => {
            // 不是当前页面发来的不处理
            if (next.pathName != this.currentPagePath) { return }
            if (next.pathId != -1 && next.pathId != this.parentUniqueId) { return }

            if (!next.data) { return }
            // 如果设置了tag；不是当前tag不处理
            let tag = next.data["tag"] as string
            if (tag != undefined && tag != this.tag) { return }

            this.autoplay = false
            this.currentTaskFlag = EVENT_SHOW_PROGRESS

            let style = next.data["style"] as RUProgressStyle
            // 因为鸿蒙的消息机制限制，这里接收到的对象不具备class能力，需要赋值更新
            let progressElement = next.data["progressElement"] as RUProgressElement
            if (progressElement) {
              // 如果已经在播放中，因为进度这个处理特殊，暂时用数据源做唯一标识
              if (this.show && this.isLoaded && this.progressItem.lottieData == progressElement.lottieData) {
                this.updateAnimationDisplay(progressElement)
              } else {
                this.style = style
                this.reloadAnimation(progressElement)
              }
            } else {
              this.message = next.data["message"] as string

              // 如果当前动画样式不一致则重新刷新
              if (style != this.style) {
                this.style = style
                this.progressItem.lottieData = null
                this.reloadAnimation()
              } else {
                if (!this.isLoaded) {
                  this.startAnimation()
                }
              }
            }

            this.progress = next.data['progress'] as number
            this.show = true
          }
        })

        // 注册隐藏进度事件
        RUEventBus.on({
          eventName: EVENT_HIDE_PROGRESS,
          target: this, callback: (next: RUEventData) => {
            if (!next.data) { return }
            let type = next.data["type"] as string
            // 不是当前页面发来的不处理
            if (type == 'current' && next.pathName != this.currentPagePath) { return }
            if (type == 'current' && next.pathId != -1 && next.pathId != this.parentUniqueId) { return }

            // 如果设置了tag；不是当前tag不处理
            let tag = next.data["tag"] as string
            if (tag != undefined && tag != this.tag) { return }
            if (!this.show || this.currentTaskFlag != EVENT_SHOW_PROGRESS) { return }

            this.currentTaskFlag = EVENT_HIDE_PROGRESS
            this.show = false
            this.destroyAnimation()
          }
        })
      }

      // 注册隐藏当前组件事件
      RUEventBus.on({
        eventName: EVENT_HIDE_RU_PROGRESS,
        target: this, callback: (next: RUEventData) => {
          if (!next.data) { return }
          let type = next.data["type"] as string
          // 不是当前页面发来的不处理
          if (type == 'current' && next.pathName != this.currentPagePath) { return }
          if (type == 'current' && next.pathId != -1 && next.pathId != this.parentUniqueId) { return }

          // 如果设置了tag；不是当前tag不处理
          let tag = next.data["tag"] as string
          if (tag != undefined && tag != this.tag) { return }

          this.currentTaskFlag = EVENT_HIDE_RU_PROGRESS
          this.show = false
          this.destroyAnimation()
        }
      })
    } catch (error) {
      hilog.info(RU_LOG_DOMAIN , `RocketUI`, "RUProgress registerEvent" + error)
    }
  }

  // MARK: - 注销事件
  unregisterEvent() {
    RUEventBus.off(EVENT_SHOW_LOADING, this)
    RUEventBus.off(EVENT_SHOW_PROGRESS, this)
    RUEventBus.off(EVENT_HIDE_LOADING, this)
    RUEventBus.off(EVENT_HIDE_PROGRESS, this)
    RUEventBus.off(EVENT_HIDE_RU_PROGRESS, this)
  }
}

