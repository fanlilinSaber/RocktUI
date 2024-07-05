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
export type UData = object | string | undefined
export type UTag = string | number | undefined

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
  // 同一个事件可以指定不同的标识符来响应
  tag?: string | number
}

/**
 * 接收事件接口
 */
export interface RUEventData {
  // 事件名称
  eventName: string
  // 当前页面路径
  pathName?: string
  // 同一个事件指定不同的标识符来相应（可以和当前Component的UniqueId进行绑定）
  tag?: UTag
  // 数据
  data?: UData
}

/**
 * 事件拦截接口
 */
export interface RUEventIntercept {
  // 要拦截的事件名
  eventNames: Array<string>
}

/**
 * 发送的事件拦截
 */
export interface RUEventInterceptSendable extends RUEventIntercept {
  /**
   * 发送事件前拦截
   * @param eventName 事件名
   * @param data 数据源
   * @param tag tag
   * @param reform 改造数据源函数（实现的地方调用 reform(data) 即可）
   * @returns true = 可发送，false = 不可发送
   */
  send: <T extends UData>(eventName: string, data: T, tag: UTag, reform: (data: UData) => void) => boolean
}

/**
 * 接收的事件拦截
 */
export interface RUEventInterceptReceivable extends RUEventIntercept {
  /**
   * 接收事件前拦截
   * @param next 事件源
   * @param reform 改造数据源函数（实现的地方调用 reform(data) 即可）
   * @returns true = 可接收，false = 不可接收
   */
  receive: (next: RUEventData, reform: (data: RUEventData) => void) => boolean
}

export class RUEventBus {
  private static instance: RUEventBus;
  private subscribes: Map<string, Map<object | string, RUEvent>> = new Map()
  private sendInterceptors: Map<string, RUEventInterceptSendable> = new Map()
  private receivInterceptors: Map<string, RUEventInterceptReceivable> = new Map()

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
  private onEvent(eventData: RUEventData) {
    hilog.info(RU_LOG_DOMAIN , `RocketUI`, "RUEventBus.onEvent() 接收事件eventData/" + JSON.stringify(eventData))

    let eventName = eventData.eventName
    if(!eventName || !this.subscribes.has(eventName)) { return }

    let subs = this.subscribes.get(eventName)
    subs?.forEach((value) => {
      try {
        // 如果接收到tag，但是接收到的tag不是事件对象的tag就跳过当前循环
        if (eventData.tag && eventData.tag != value.tag) { return }

        let tempData = eventData
        if (this.receivInterceptors.has(eventName)) {
          let receivable = this.receivInterceptors.get(eventName) as RUEventInterceptReceivable
          let next = receivable.receive(eventData, (data) => {
            tempData = data
          }) as boolean
          if (!next) { return }
        }

        value.callback && value.callback(tempData)
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
   * @param tag 唯一标识符（默认取值）
   */
  public emit(eventName: string, data?: UData, tag?: UTag) {
    try {
      let tempData = data
      if (this.sendInterceptors.has(eventName)) {
        let sendable = this.sendInterceptors.get(eventName) as RUEventInterceptSendable
        let next = sendable.send(eventName, data, tag, (data) => {
          tempData = data
        }) as boolean
        if (!next) { return }
      }

      let routerState = router.getState()
      let eventData: RUEventData = {
        eventName: eventName,
        pathName: routerState.path + routerState.name,
        tag: tag,
        data: tempData
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
  public off(eventName: string, target?: object) {
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

  /**
   * 添加发送事件消息拦截
   * @param i 拦截器
   */
  public addInterceptor(i: RUEventInterceptSendable | RUEventInterceptReceivable) {
    try {
      i.eventNames.forEach((value) => {
        if ((i as RUEventInterceptSendable).send != undefined) {
          if (this.sendInterceptors.has(value)) { return }
          this.sendInterceptors.set(value, i as RUEventInterceptSendable)
        } else if ((i as RUEventInterceptReceivable).receive != undefined) {
          if (this.receivInterceptors.has(value)) { return }
          this.receivInterceptors.set(value, i as RUEventInterceptReceivable)
        }
      })
    } catch (error) {
      hilog.info(RU_LOG_DOMAIN, `RocketUI`, "RUEventBus.addIntercept() 拦截事件" + i.eventNames)
    }
  }
}

export default RUEventBus.getInstance();