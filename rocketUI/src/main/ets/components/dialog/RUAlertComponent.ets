import router from '@ohos.router';
import { CURRENT_PAGE_TAG } from '../../constants/RUConstants';
import RUEventBus, { RUEventData } from '../../utils/RUEventBus'
import { RUCommonDialogObserved, RUCommonObservedDialog } from './RUCommonDialog';

//显示弹窗广播事件常量
const EVENT_ALERTDIALOG_OPEN: string = "EVENT_ALERTDIALOG_OPEN"
//隐藏弹窗广播事件常量
const EVENT_ALERTDIALOG_CLOSE: string = "EVENT_ALERTDIALOG_CLOSE"

/**
 * 自定义的提示弹窗工具类
 * 通过单例的方式实现，使用单例模式是为了实现按钮点击的回调
 * 注意，这个工具类需要配合RUPage基类使用
 * @author shengjie
 * @time 2024.03.28
 */
export class RUAlertDialog {
  //确定按钮
  onClickEnter: Function = () => {}
  //取消按钮
  onClickCancel: Function =  () => {}
  //单例模式
  private static mInstance: RUAlertDialog
  //获取对象
  public static getInstance() {
    if (RUAlertDialog.mInstance == null || RUAlertDialog.mInstance == undefined) {
      RUAlertDialog.mInstance = new RUAlertDialog()
    }
    return RUAlertDialog.mInstance;
  }

  /**
   * 显示弹窗
   * @param message 信息
   * @param onClickEnter 确定按钮点击回调函数
   * @param onClickCancel 取消按钮点击回调函数
   */
  static show(message?: string | RUAlertDialogElement,
              onClickEnter: Function = ()=>{},
              onClickCancel: Function = ()=>{}
  ) {
    let mInstance = RUAlertDialog.getInstance()
    mInstance.onClickEnter = onClickEnter
    mInstance.onClickCancel = onClickCancel

    let data : Record<string , string | boolean | undefined> = {}
    if (typeof message === 'string') {
      data = {
        "content": message
      }
    } else {
      data = {
        "content": message?.content,
        "contentTextColor": message?.contentTextColor,
        "enterTextColor": message?.enterTextColor,
        "cancelTextColor": message?.cancelTextColor,
        "enterText": message?.enterText,
        "cancelText": message?.cancelText,
        "title": message?.title,
        "tag": message?.tag,
        "isOneBtn": message?.isOneBtn??true,
      }
    }

    let aTag = AppStorage.get(CURRENT_PAGE_TAG) as number
    RUEventBus.emit(EVENT_ALERTDIALOG_OPEN, data, aTag)
  }

  /**
   * 隐藏弹窗
   */
  static dismiss() {
    RUEventBus.emit(EVENT_ALERTDIALOG_CLOSE)
  }
}

/**
 * 支持修改的参数
 */
export interface  RUAlertDialogElement {
  content?: string
  contentTextColor?: string
  enterTextColor?: string
  cancelTextColor?: string
  enterText?: string
  cancelText?: string
  title?: string
  tag?: string
  isOneBtn?: boolean
}

/**
 * 自定义弹窗控件
 * 1、添加自定义弹窗
 * 2、注册广播事件（包括显示弹窗广播事件、隐藏弹窗广播事件）
 */
@Component
export struct RUAlertComponent {
  // 组件唯一tag，用于同一个页面存在多个同一源的组件区分
  tag?: string | number = undefined

  //弹窗state
  @State mCommonDialogObserved: RUCommonDialogObserved = new RUCommonDialogObserved({
    content: "",
    //默认字体颜色
    contentTextColor: "#FF123123",
    isOneBtn: false
  })

  aboutToAppear() {
    this.registerEvent()
  }

  build() {
  }

  //弹窗
  mMessageDialog: CustomDialogController = new CustomDialogController({
    builder: RUCommonObservedDialog({
      mObserved: this.mCommonDialogObserved,
      onClickEnter: (tag: string) => {
        if (RUAlertDialog.getInstance().onClickEnter) {
          RUAlertDialog.getInstance().onClickEnter(tag)
        }
      },
      onClickCancel: (tag: string) => {
        if (RUAlertDialog.getInstance().onClickCancel) {
          RUAlertDialog.getInstance().onClickCancel(tag)
        }
      }
    }),
    alignment: DialogAlignment.Default,
    customStyle: true
  })

  aboutToDisappear() {
    this.unregisterEvent()
  }

  registerEvent() {
    try {
      let routerState = router.getState();
      let currentPagePath = routerState.path + routerState.name

      // 注册显示提示框事件
      RUEventBus.on({
        eventName: EVENT_ALERTDIALOG_OPEN,
        tag: this.tag,
        target: this, callback: (next: RUEventData) => {
          // 不是当前页面发来的不处理
          if (next.tag && next.tag != this.tag) { return }
          if (next.pathName != currentPagePath) { return }

          if (!next.data) { return }

          let mCommonDialogObserved: RUCommonDialogObserved = new RUCommonDialogObserved()
          let content: string = next.data["content"]
          let contentTextColor: Resource | string = next.data["contentTextColor"]
          let enterTextColor: Resource | string = next.data["enterTextColor"]
          let cancelTextColor: Resource | string = next.data["cancelTextColor"]
          let enterText: string = next.data["enterText"]
          let cancelText: string = next.data["cancelText"]
          let title: string = next.data["title"]
          let tag: string = next.data["tag"]
          let isOneBtn: boolean = next.data["isOneBtn"]
          if (content) {
            mCommonDialogObserved.content = content
          }
          if (contentTextColor) {
            mCommonDialogObserved.contentTextColor = contentTextColor
          }
          if (enterTextColor) {
            mCommonDialogObserved.enterTextColor = enterTextColor
          }
          if (cancelTextColor) {
            mCommonDialogObserved.cancelTextColor = cancelTextColor
          }
          if (enterText) {
            mCommonDialogObserved.enterText = enterText
          }
          if (cancelText) {
            mCommonDialogObserved.cancelText = cancelText
          }
          if (title) {
            mCommonDialogObserved.title = title
          }
          if (tag) {
            mCommonDialogObserved.tag = tag
          }
          mCommonDialogObserved.isOneBtn = isOneBtn??true
          this.mCommonDialogObserved = mCommonDialogObserved
          this.mMessageDialog.open()
        }
      })

      // 注册关闭提示框事件
      RUEventBus.on({
        eventName: EVENT_ALERTDIALOG_CLOSE,
        tag: this.tag,
        target: this, callback: (next: RUEventData) => {
          // 不是当前页面发来的不处理
          if (next.tag && next.tag != this.tag) { return }
          if (next.pathName != currentPagePath) { return }

          this.mMessageDialog.close()
        }
      })
    } catch (err) {
    }
  }

  unregisterEvent() {
    RUEventBus.off(EVENT_ALERTDIALOG_OPEN, this)
    RUEventBus.off(EVENT_ALERTDIALOG_CLOSE, this)
  }
}