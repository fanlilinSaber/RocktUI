/**
 * Author:fanlilin
 * Date:2024/6/17
 * Descrobe:
 */

// 默认导航栏高度（鸿蒙推荐高度：https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-navigation-0000001815927580）
export const NAVBAR_HEIGHT: number = 56;
// 当前页面标识符（一般是组件的UniqueId）
export const NEW_PAGE_TAG: string = 'NewPageTag';
// 旧页面标识符（一般是组件的UniqueId）
export const OLD_PAGE_TAG: string = 'OldPageTag';

// show loading event name
export const EVENT_SHOW_LOADING: string = "showLoading"
// hide current loading event name
export const EVENT_HIDE_LOADING: string = "hideLoading"
// show progress event name
export const EVENT_SHOW_PROGRESS: string = "showProgress"
// hide progress event name
export const EVENT_HIDE_PROGRESS: string = "hideProgress"
// hide RUProgress event name
export const EVENT_HIDE_RU_PROGRESS: string = "hideRUProgress"
// show Toast event name
export const EVENT_SHOW_TOAST: string = "showToast"

//显示弹窗广播事件常量
export  const EVENT_ALERTDIALOG_OPEN: string = "EVENT_ALERTDIALOG_OPEN"
//隐藏弹窗广播事件常量
export  const EVENT_ALERTDIALOG_CLOSE: string = "EVENT_ALERTDIALOG_CLOSE"

// log domain
export const RU_LOG_DOMAIN = 0x00503;