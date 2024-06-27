/**
 * Author:fanlilin
 * Date:2024/6/12
 * Descrobe:
 */
import { window } from '@kit.ArkUI';

export class RUConfig {
  // 用于被HSP包依赖，需要指定对应被依赖的HSP module的下文context寻找资源（默认自动获取了）
  public rootModuleName?: string | null = null
  // 状态栏高度（获取的单位是px，需要vp用px2vp转换）
  public get statusBarHeight(): number {
    if (this._statusBarHeight == undefined) {
      throw this.error()
    }
    return this._statusBarHeight
  }
  // 底部导航条区域的高度（获取的单位是px，需要vp用px2vp转换）
  public get indicatorHeight(): number {
    if (this._indicatorHeight == undefined) {
      throw this.error()
    }
    return this._indicatorHeight
  }
  // 实例
  private static instance: RUConfig
  // 当前上下文
  private context?: Context
  private _statusBarHeight: number | undefined = undefined
  private _indicatorHeight: number | undefined = undefined

  public static getInstance(): RUConfig {
    if (!RUConfig.instance) {
      RUConfig.instance = new RUConfig()
      let self = RUConfig.instance
      // TODO: 暂时用这种办法获取当包所存在的module
      self.rootModuleName = $rawfile('ru_animation_forward.json').moduleName
    }
    return RUConfig.instance
  }

  /**
   * 初始化（一定要在windowStage.loadContent完成之前调用，保证进入页面之前已获取到初始化值）
   * @param context
   */
  public init(context: Context) {
    this.context = context
    if (!context) { return }

    window.getLastWindow(context).then((data) => {
      // 获取系统默认区域，一般包括状态栏、导航栏
      let avoidArea1 = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      // 顶部状态栏高度
      let statusBarHeight = avoidArea1.topRect.height
      // 底部导航栏高度
      let bottomNavHeight = avoidArea1.bottomRect.height
      // 获取导航条区域
      let avoidArea2 = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
      // 获取到导航条区域的高度
      let indicatorHeight = avoidArea2.bottomRect.height
      this._statusBarHeight = statusBarHeight
      this._indicatorHeight = indicatorHeight
      console.info(`avoidArea statusBarHeight is ${statusBarHeight}px`);
      console.info(`avoidArea bottomNavHeight is ${bottomNavHeight}px`);
      console.info(`avoidArea indicatorHeight is ${indicatorHeight}px`);
    }).catch((err: Error) => {
      console.error(`Failed to obtain the window. Cause: ${JSON.stringify(err)}`);
    });
  }

  private error(): Error {
    return new Error('未初始化RocketUI；请在EntryAbility中的windowStage.loadContent之前调用 RocketUI.init(this.context)')
  }
}

export default RUConfig.getInstance()