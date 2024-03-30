/**
 * Author:fanlilin
 * Date:2024/3/13
 * Descrobe: 基于系统 emitter 封装，一是为了我们方便集中管理事件中心，二是往往我们在发送事件中需要额外的信息作为补充，比如页面路径信息作为默认信息，三是针对同一行为的事件可以分路径页面管理，四是发现发送多层json数据内容丢失问题。
 */

import emitter from '@ohos.events.emitter'
import hilog from '@ohos.hilog';
import router from '@ohos.router';

// APP总线事件ID
const RKT_EVENT_ID = 2024313;
const RKT_LOG_DOMAIN = 0x00503;

/**
 * 订阅事件接口
 */
export interface RKTEvent {
  // 事件名称
  eventName: string
  // 事件优先级
  priority?: emitter.EventPriority
  // 响应事件时的回调, 可通过 RKTEventBus.on 第2个参数设置
  callback?: (eventData: RKTEventData) => void
  // 谁来响应 谁on就写谁的this
  target?: any
}

/**
 * 接收事件接口
 */
export interface RKTEventData {
  // 事件名称
  eventName: string
  // 当前页面路径
  pathName?: string
  // 数据
  data?: any
}

export class RKTEventBus {
  private static instance: RKTEventBus;
  private subscribes: Map<string, Map<any, RKTEvent>> = new Map()

  private constructor() {
    this.__registerEventListener()
  }

  private __registerEventListener() {
    emitter.on({eventId: RKT_EVENT_ID}, (data: emitter.EventData) => {
      let eventData: RKTEventData = {
        eventName: data?.data['eventName'],
        pathName: data?.data['pathName'],
      }
      let dataStr = data?.data['dataStr']
      if (dataStr) {
        let data = JSON.parse(dataStr)
        eventData.data = data
      }
      this.onEvent(eventData)
    });
  }

  public static getInstance() {
    if(!RKTEventBus.instance){
      RKTEventBus.instance = new RKTEventBus()
    }
    return RKTEventBus.instance
  }

  /**
   * 接收事件处理
   * @param eventData 事件消息体
   */
  private onEvent(eventData: RKTEventData){
    hilog.info(RKT_LOG_DOMAIN , `RocketUI`, "RKTEventBus.onEvent() 接收事件eventData/" + JSON.stringify(eventData))

    let eventName = eventData.eventName
    if(!eventName || !this.subscribes.has(eventName)) { return }

    let subs = this.subscribes.get(eventName)
    for (let [key, value] of subs) {
      try {
        value.callback && value.callback(eventData);
        hilog.info(RKT_LOG_DOMAIN , `RocketUI`, `RKTEventBus.onEvent() 事件${eventName}触发成功`)
      } catch (error) {
        hilog.error(RKT_LOG_DOMAIN , `RocketUI`, `RKTEventBus.onEvent() 触发失败` + error)
      }
    }
  }

  /**
   * 注册事件
   * 例：例：RKTEventBus.on({ eventName: 'showLoading'}, (data: RKTEventData) => { })
   * @param event 事件对象
   * @param callback 响应事件时的回调，也可通过事件对象构建
   */
  public on(event: RKTEvent, callback?: (next: RKTEventData) => void) {
    try {
      let eventName = event.eventName
      if (callback) { event.callback = callback }
      if (!this.subscribes.has(eventName)) {
        this.subscribes.set(eventName, new Map())
      }

      let eventTarget = event.target
      let subs = this.subscribes.get(eventName)
      // 如果外部传了 target 则使用 target 作为key来管理消息事件，如果没有则分配随机key管理
      var subKey = eventTarget ? eventTarget : eventName + "." + subs.size
      if (!subs.has(subKey)) {
        subs.set(subKey, event)
      }
      hilog.info(RKT_LOG_DOMAIN , `RocketUI`, `RKTEventBus.on() 注册事件${eventName}成功`)
    } catch (error) {
      hilog.error(RKT_LOG_DOMAIN , `RocketUI`, `RKTEventBus.on() 注册事件${event.eventName}失败` + error)
    }
  }

  /**
   * 发送事件消息
   * @param eventName 事件名称
   * @param data 传送的数据
   */
  public emit(eventName: string, data?: any){
    try {
      let routerState = router.getState()
      var newData = {
        'pathName': routerState.path + routerState.name,
        'eventName': eventName
      }

      // 因系统emitter发送多层json数据的格式会过滤掉，这里转换成json字符串发送
      if (data) { newData['dataStr'] = JSON.stringify(data) }
      emitter.emit({ eventId: RKT_EVENT_ID }, { data: newData })
      hilog.info(RKT_LOG_DOMAIN , `RocketUI`, "RKTEventBus.emit() 发送事件成功/" + JSON.stringify(newData))
    } catch (error) {
      hilog.error(RKT_LOG_DOMAIN , `RocketUI`, "RKTEventBus.emit() 发送事件失败/" + error)
    }
  }

  /**
   * 关闭事件（注册地销毁事件也要跟随销毁，不然有内存泄露）
   * @param eventName 要取消的事件名称
   * @param target 要取消该事件的目标（this）
   */
  public off(eventName: string, target?: any){
    if (!this.subscribes.has(eventName)) { return }
    // 如果没有指定 target；取消注册该事件的所有目标
    if (!target) {
      this.subscribes.delete(eventName)
      hilog.info(RKT_LOG_DOMAIN, `RocketUI`, "RKTEventBus.off() 关闭事件" + eventName)
      return
    }

    // 如果指定了 target；则单独取消注册该事件的目标
    let subs = this.subscribes.get(eventName)
    if (subs.has(target)) {
      subs.delete(target);
      hilog.info(RKT_LOG_DOMAIN, `RocketUI`, "RKTEventBus.off() 关闭事件" + eventName + target)
    }
  }
}

export default RKTEventBus.getInstance();