/**
 * Author:fanlilin
 * Date:2024/3/18
 * Descrobe:
 */

import common from '@ohos.app.ability.common';
import util from '@ohos.util';
import { RKTProgress, RKTProgressStyle } from '../components/RKTProgress'
import RKTEventBus, { RKTEventData } from '../utils/RKTEventBus'

export class RKTUtil {

  public static context(x: any) {
    // let context = getContext(x).createModuleContext('rocketUI') as common.UIAbilityContext
  }

  /**
   * 加载
   * @param style
   * @param message
   */
  public static showLoading(style?: RKTProgressStyle, message?: string) {
    let data = {
      "style": style,
      "message": message
    }
    RKTEventBus.emit("showLoading", data)
  }

  public static hideLoading() {
    RKTEventBus.emit("hideLoading")
  }
}

export default RKTUtil