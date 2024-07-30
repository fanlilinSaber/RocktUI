/**
 * 温馨提示对话框，可以动态设置显示一个或两个按钮
 *
 * ---------------------
 *        温馨提示
 *      自定义提示文案
 *      取消  |  确定
 * ---------------------
 */
@CustomDialog
export struct RUCommonObservedDialog {
  controller: CustomDialogController
  onClickEnter: Function = (result: string) => {
  }
  onClickCancel: Function = (result: string) => {
  }
  @ObjectLink mObserved: RUCommonDialogObserved

  build() {
    Column() {
      Text(this.mObserved.title ?? '温馨提示')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 20, left: 20, right: 20 })
      Text(this.mObserved.content)
        .fontSize(14)
        .margin({ top: 20, left: 20, right: 20 })
        .fontColor(this.mObserved.contentTextColor ?? $r("app.color.ru_color_FF333333"))
      Divider().color($r("app.color.ru_color_FFEDEDED")).width('100%').margin({ top: 20 })
      Flex() {
        if (this.mObserved.isOneBtn == false) {
          Text(this.mObserved.cancelText ?? '取消')
            .backgroundColor($r("app.color.ru_color_FFFFFFFF"))
            .fontColor(this.mObserved.cancelTextColor ?? $r("app.color.ru_color_FF333333"))
            .textAlign(TextAlign.Center)
            .height('100%')
            .flexGrow(1)
            .borderRadius(12)
            .onClick(() => {
              this.controller.close()
              if (this.onClickCancel) {
                this.onClickCancel(this.mObserved.tag)
              }
            })
          Divider().vertical(true).color($r("app.color.ru_color_FFEDEDED")).height('100%')
        }
        Text(this.mObserved.enterText ?? '确定')
          .backgroundColor($r("app.color.ru_color_FFFFFFFF"))
          .fontColor(this.mObserved.enterTextColor ?? $r("app.color.ru_color_FF79A2FF"))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .height('100%')
          .flexGrow(1)
          .borderRadius(12)
          .onClick(() => {
            this.controller.close()
            if (this.onClickEnter) {
              this.onClickEnter(this.mObserved.tag)
            }
          })
      }
      .width('100%')
      .height(44)
    }
    .backgroundColor(Color.White)
    .width(280)
    .borderRadius(12)
  }
}

@Observed
export class RUCommonDialogObserved {
  constructor(t?: RUCommonDialogElement) {
    if (t) {
      this.content = t.content
      this.contentTextColor = t.contentTextColor
      this.enterTextColor = t.enterTextColor
      this.cancelTextColor = t.cancelTextColor
      this.enterText = t.enterText
      this.cancelText = t.cancelText
      this.title = t.title
      this.tag = t.tag
      this.obj = t.obj
      this.isOneBtn = t.isOneBtn
    }
  }

  content?: string = ""
  contentTextColor?: Resource | string
  enterTextColor?: Resource | string
  cancelTextColor?: Resource | string
  enterText?: string
  cancelText?: string
  title?: string
  tag?: string
  obj?: object | string | number | boolean | null
  isOneBtn?: boolean = false
}

export class RUCommonDialogElement {
  content?: string
  contentTextColor?: Resource | string
  enterTextColor?: Resource | string
  cancelTextColor?: Resource | string
  enterText?: string
  cancelText?: string
  title?: string
  tag?: string
  obj?: object | string | number | boolean | null
  isOneBtn?: boolean
}

/**
 * 温馨提示对话框，可以动态设置显示一个或两个按钮
 *
 * ---------------------
 *        温馨提示
 *      自定义提示文案
 *      取消  |  确定
 * ---------------------
 */
@CustomDialog
export struct RUCommonDialog {
  controller: CustomDialogController
  onClickEnter: Function = (result: string) => {
  };
  onClickCancel: Function = (result: string) => {
  };
  content: string = ""
  enterTextColor: Resource | string = ""
  cancelTextColor: Resource | string = ""
  enterText: string = ""
  cancelText: string = ""
  title: string = ""
  tag: string = ""
  isOneBtn: boolean = false

  build() {
    Column() {
      Text(this.title ?? '温馨提示').fontSize(16).fontWeight(FontWeight.Medium).margin({ top: 20, left: 20, right: 20 })
      Text(this.content).fontSize(14).margin({ top: 20, left: 20, right: 20 })
      Divider().color($r("app.color.ru_color_FFEDEDED")).width('100%').margin({ top: 20 })
      Flex() {
        if (this.isOneBtn == false) {
          Text(this.cancelText ?? '取消')
            .backgroundColor($r("app.color.ru_color_FFFFFFFF"))
            .fontColor(this.cancelTextColor ?? $r("app.color.ru_color_FF333333"))
            .textAlign(TextAlign.Center)
            .height('100%')
            .flexGrow(1)
            .borderRadius(12)
            .onClick(() => {
              this.controller.close()
              if (this.onClickCancel) {
                this.onClickCancel(this.tag)
              }
            })
          Divider().vertical(true).color($r("app.color.ru_color_FFEDEDED")).height('100%')
        }
        Text(this.enterText ?? '确定')
          .backgroundColor($r("app.color.ru_color_FFFFFFFF"))
          .fontColor(this.enterTextColor ?? $r("app.color.ru_color_FF79A2FF"))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .height('100%')
          .flexGrow(1)
          .borderRadius(12)
          .onClick(() => {
            this.controller.close()
            if (this.onClickEnter) {
              this.onClickEnter(this.tag)
            }
          })
      }
      .width('100%')
      .height(44)
    }
    .backgroundColor(Color.White)
    .width(280)
    .borderRadius(12)
  }
}
