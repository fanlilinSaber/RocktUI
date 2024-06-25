/**
 * Author:fanlilin
 * Date:2024/6/12
 * Descrobe:
 */
import { window } from '@kit.ArkUI';

export class RUConfig {
  // 用于被HSP包依赖，需要指定对应被依赖的HSP module的下文context寻找资源（默认自动获取了）
  public rootModuleName?: string | null = null
  // 状态栏高度
  public statusBarHeight: number | undefined = undefined
  // 底部导航条区域的高度
  public indicatorHeight: number | undefined = undefined
  // 实例
  private static instance: RUConfig
  private context?: Context

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
   * 初始化（一定要在windowStage.loadContent完成之后调用，按鸿蒙的解释：windowStage.loadContent是初始化ArkUI，只有当初始化完成后，px2vp才会根据设备得到具体的值。）
   * @param context
   */
  public init(context: Context) {
    this.context = context
    if (!context) { return }

    window.getLastWindow(context).then((data) => {
      // 获取系统默认区域，一般包括状态栏、导航栏
      let avoidArea1 = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      // 顶部状态栏高度
      let statusBarHeight = px2vp(avoidArea1.topRect.height);
      // 底部导航栏高度
      let bottomNavHeight = px2vp(avoidArea1.bottomRect.height);
      // 获取导航条区域
      let avoidArea2 = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      // 获取到导航条区域的高度
      let indicatorHeight = px2vp(avoidArea2.bottomRect.height);
      this.statusBarHeight = statusBarHeight
      this.indicatorHeight = indicatorHeight
      console.info(`voidArea statusBarHeight is ${statusBarHeight}`);
      console.info(`voidArea bottomNavHeight is ${bottomNavHeight}`);
      console.info(`voidArea indicatorHeight is ${indicatorHeight}`);
    }).catch((err: Error) => {
      console.error(`Failed to obtain the window. Cause: ${JSON.stringify(err)}`);
    });
  }
}

export default RUConfig.getInstance()