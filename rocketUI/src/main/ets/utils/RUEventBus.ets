/**
 * Author:fanlilin
 * Date:2024/3/13
 * Descrobe: 基于系统 emitter 封装，一是为了我们方便集中管理事件中心，二是往往我们在发送事件中需要额外的信息作为补充，比如页面路径信息作为默认信息，三是针对同一行为的事件可以分路径页面管理，四是发现发送多层json数据内容丢失问题。
 * AmendHistory：系统的`emitter`因消息内容格式和大小问题（10KB）限制，我们优化掉`emitter`这个中间层，直接实现消息转发机制。
 */

import emitter from '@ohos.events.emitter'
import hilog from '@ohos.hilog';
import router from '@ohos.router';


const RU_LOG_DOMAIN = 0x00503;

/**
 * 订阅事件接口
 */
export interface RUEvent {
  // 事件名称
  eventName: string
  // 事件优先级
  priority?: emitter.EventPriority
  // 响应事件时的回调, 可通过 RUEventBus.on 第2个参数设置
  callback?: (eventData: RUEventData) => void
  // 谁来响应 谁on就写谁的this
  target?: object
}

/**
 * 接收事件接口
 */
export interface RUEventData {
  // 事件名称
  eventName: string
  // 当前页面路径
  pathName?: string
  // 当前Component的UniqueId
  pathId?: number
  // 数据
  data?: object | string
}

export class RUEventBus {
  private static instance: RUEventBus;
  private subscribes: Map<string, Map<object | string, RUEvent>> = new Map()
  // 用了Navigation管理页面，暂时么有系统的全局获取方法，配合页面显示和消失绑定页面的UniqueId，当前Component的UniqueId。UniqueId为系统为每个组件分配的Id，可保证唯一性，-1 = 无效
  currentPathId: number = -1

  public static getInstance() {
    if(!RUEventBus.instance){
      RUEventBus.instance = new RUEventBus()
    }
    return RUEventBus.instance
  }

  /**
   * 接收事件处理
   * @param eventData 事件消息体
   */
  private onEvent(eventData: RUEventData){
    hilog.info(RU_LOG_DOMAIN , `RocketUI`, "RUEventBus.onEvent() 接收事件eventData/" + JSON.stringify(eventData))

    let eventName = eventData.eventName
    if(!eventName || !this.subscribes.has(eventName)) { return }

    let subs = this.subscribes.get(eventName)
    subs?.forEach((value) => {
      try {
        value.callback && value.callback(eventData)
        hilog.info(RU_LOG_DOMAIN , `RocketUI`, `RUEventBus.onEvent() 事件${eventName}触发成功`)
      } catch (error) {
        hilog.error(RU_LOG_DOMAIN , `RocketUI`, `RUEventBus.onEvent() 触发失败` + error)
      }
    })
  }

  /**
   * 注册事件
   * 例：例：RUEventBus.on({ eventName: 'showLoading'}, (data: RUEventData) => { })
   * @param event 事件对象
   * @param callback 响应事件时的回调，也可通过事件对象构建
   */
  public on(event: RUEvent, callback?: (next: RUEventData) => void) {
    try {
      let eventName = event.eventName
      if (callback) { event.callback = callback }
      if (!this.subscribes.has(eventName)) {
        this.subscribes.set(eventName, new Map())
      }

      let eventTarget = event.target
      let subs = this.subscribes.get(eventName)
      // 如果外部传了 target 则使用 target 作为key来管理消息事件，如果没有则分配随机key管理
      let subKey = eventTarget ?? eventName + "." + subs?.size
      if (!subs?.has(subKey)) {
        subs?.set(subKey, event)
        hilog.info(RU_LOG_DOMAIN , `RocketUI`, `RUEventBus.on() 注册事件${eventName}成功`)
      }
    } catch (error) {
      hilog.error(RU_LOG_DOMAIN , `RocketUI`, `RUEventBus.on() 注册事件${event.eventName}失败` + error)
    }
  }

  /**
   * 发送事件消息
   * @param eventName 事件名称
   * @param data 发送的数据
   */
  public emit(eventName: string, data?: object | string){
    try {
      let routerState = router.getState()
      let eventData: RUEventData = {
        eventName: eventName,
        pathName: routerState.path + routerState.name,
        pathId: this.currentPathId,
        data: data
      }
      this.onEvent(eventData)
      hilog.info(RU_LOG_DOMAIN , `RocketUI`, "RUEventBus.emit() 发送事件成功/" + JSON.stringify(eventData))
    } catch (error) {
      hilog.error(RU_LOG_DOMAIN , `RocketUI`, "RUEventBus.emit() 发送事件失败/" + error)
    }
  }

  /**
   * 关闭事件（注册地销毁事件也要跟随销毁，不然有内存泄露）
   * @param eventName 要取消的事件名称
   * @param target 要取消该事件的目标（this）
   */
  public off(eventName: string, target?: object){
    if (!this.subscribes.has(eventName)) { return }
    // 如果没有指定 target；取消注册该事件的所有目标
    if (!target) {
      this.subscribes.delete(eventName)
      hilog.info(RU_LOG_DOMAIN, `RocketUI`, "RUEventBus.off() 关闭事件" + eventName)
      return
    }

    // 如果指定了 target；则单独取消注册该事件的目标
    let subs = this.subscribes.get(eventName)
    if (subs?.has(target)) {
      subs.delete(target);
      hilog.info(RU_LOG_DOMAIN, `RocketUI`, "RUEventBus.off() 关闭事件" + eventName + target)
    }
  }
}

export default RUEventBus.getInstance();