import router from '@ohos.router';
import RKTEventBus, { RKTEventData } from '../../utils/RKTEventBus'
import { RKTCommonDialogObserved, RKTCommonObservedDialog } from './RKTCommonDialog';

//显示弹窗广播事件常量
const EVENT_ALERTDIALOG_OPEN: string = "EVENT_ALERTDIALOG_OPEN"
//隐藏弹窗广播事件常量
const EVENT_ALERTDIALOG_CLOSE: string = "EVENT_ALERTDIALOG_CLOSE"

/**
 * 自定义的提示弹窗工具类
 * 通过单例的方式实现，使用单例模式是为了实现按钮点击的回调
 * 注意，这个工具类需要配合RKTPage基类使用
 * @author shengjie
 * @time 2024.03.28
 */
export class RKTAlertDialog {
  //确定按钮
  onClickEnter: Function = () => {}
  //取消按钮
  onClickCancel: Function =  () => {}
  //单例模式
  private static mInstance: RKTAlertDialog
  //获取对象
  public static getInstance() {
    if (RKTAlertDialog.mInstance == null || RKTAlertDialog.mInstance == undefined) {
      RKTAlertDialog.mInstance = new RKTAlertDialog()
    }
    return RKTAlertDialog.mInstance;
  }

  /**
   * 显示弹窗
   * @param message 信息
   * @param onClickEnter 确定按钮点击回调函数
   * @param onClickCancel 取消按钮点击回调函数
   */
  static show(message?: string | RKTAlertDialogElement,
              onClickEnter: Function = ()=>{},
              onClickCancel: Function = ()=>{}
  ) {
    let mInstance = RKTAlertDialog.getInstance()
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
    RKTEventBus.emit(EVENT_ALERTDIALOG_OPEN, data)
  }

  /**
   * 隐藏弹窗
   */
  static dismiss() {
    RKTEventBus.emit(EVENT_ALERTDIALOG_CLOSE)
  }
}

/**
 * 支持修改的参数
 */
export interface  RKTAlertDialogElement {
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
export struct RKTAlertComponent {

  //弹窗state
  @State mCommonDialogObserved: RKTCommonDialogObserved = new RKTCommonDialogObserved({
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
    builder: RKTCommonObservedDialog({
      mObserved: this.mCommonDialogObserved,
      onClickEnter: (tag: string) => {
        if (RKTAlertDialog.getInstance().onClickEnter) {
          RKTAlertDialog.getInstance().onClickEnter(tag)
        }
      },
      onClickCancel: (tag: string) => {
        if (RKTAlertDialog.getInstance().onClickCancel) {
          RKTAlertDialog.getInstance().onClickCancel(tag)
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
      RKTEventBus.on({
        eventName: EVENT_ALERTDIALOG_OPEN,
        target: this, callback: (next: RKTEventData) => {
          // 不是当前页面发来的不处理
          if (next.pathName != currentPagePath) {
            return
          }
          let mCommonDialogObserved: RKTCommonDialogObserved = new RKTCommonDialogObserved()
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
      RKTEventBus.on({
        eventName: EVENT_ALERTDIALOG_CLOSE,
        target: this, callback: (next: RKTEventData) => {
          // 不是当前页面发来的不处理
          if (next.pathName != currentPagePath) {
            return
          }
          this.mMessageDialog.close()
        }
      })
    } catch (err) {
    }
  }

  unregisterEvent() {
    RKTEventBus.off(EVENT_ALERTDIALOG_OPEN, this)
    RKTEventBus.off(EVENT_ALERTDIALOG_CLOSE, this)
  }
}