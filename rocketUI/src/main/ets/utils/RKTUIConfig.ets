/**
 * Author:fanlilin
 * Date:2024/6/12
 * Descrobe:
 */

export class RKTUIConfig {

  // 配置被HSP模块依赖的模块名，不然会有资源路径访问问题。
  public moduleName?: string | null = null

  private static instance: RKTUIConfig

  public static getInstance(): RKTUIConfig {
    if (!RKTUIConfig.instance) {
      RKTUIConfig.instance = new RKTUIConfig()
    }
    return RKTUIConfig.instance
  }
}

export default RKTUIConfig.getInstance()