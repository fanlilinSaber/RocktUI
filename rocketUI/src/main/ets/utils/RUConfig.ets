/**
 * Author:fanlilin
 * Date:2024/6/12
 * Descrobe:
 */
import { common } from '@kit.AbilityKit'

export class RUUIConfig {
  // 用于被HSP包依赖，需要指定对应被依赖的HSP module的下文context寻找资源（默认自动获取了）
  public rootModuleName?: string | null = null
  // 实例
  private static instance: RUUIConfig

  public static getInstance(): RUUIConfig {
    if (!RUUIConfig.instance) {
      RUUIConfig.instance = new RUUIConfig()
      let self = RUUIConfig.instance
      // TODO: 暂时用这种办法获取当包所存在的module
      self.rootModuleName = $rawfile('ru_animation_forward.json').moduleName
    }
    return RUUIConfig.instance
  }
}

export default RUUIConfig.getInstance()