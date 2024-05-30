import {
  RKTAlertDialog,
  RKTCommonDialogObserved,
  RKTCommonObservedDialog,
  RKTOptionsPickerDialog
} from '@zjos/rocketUI'
import promptAction from '@ohos.promptAction'
import RKTPDFViewerDemo from './RKTPDFViewerDemo'

@Component
export default struct RKTDialogDemo {
  @State mChildList: Array<string> = ["第一个选项", "第二个选项", "第三个选项"]

  //弹窗state
  @State mCommonDialogObserved: RKTCommonDialogObserved = new RKTCommonDialogObserved({
    content: "默认详细描述等等。。。",
    //默认字体颜色
    contentTextColor: "#FF123123",
    isOneBtn: false
  })
  @State isNetPdf: boolean = false

  build() {
    Column() {
      Text("滚动选项弹窗")
        .margin({ left: 15, right: 15 }).fontSize(12).fontColor("#666666")

      Text("滚动选项弹窗")
        .padding(10)
        .fontSize(15)
        .margin({ left: 15, top: 10 })
        .backgroundColor("#1A333333")
        .borderRadius(5)
        .fontColor("#FF333333")
        .onClick(() => {
          this.mOptionsDialog.open()
        })

      Row() {
        Shape().layoutWeight(1).height(1).backgroundColor("#F5F5F5").margin({ top: 10, bottom: 10 })
      }

      Text("提示对话框，可以动态设置显示一个或两个按钮,可动态设置内容、颜色等")
        .margin({ left: 15, right: 15 })
        .fontSize(12)
        .fontColor("#666666")

      Row() {
        Text("设置颜色")
          .margin({ left: 5 })
          .padding(5)
          .fontSize(15)
          .backgroundColor("#1A333333")
          .borderRadius(2)
          .fontColor("#FF333333")
          .onClick(() => {
            this.mCommonDialogObserved = new RKTCommonDialogObserved({
              content: "默认详细描述等等。。。",
              //默认字体颜色
              contentTextColor: "#FF0000",
              isOneBtn: false
            })
            this.mMessageDialog.open()
          })

        Text("设置文案")
          .margin({ left: 5 })
          .padding(5)
          .fontSize(15)
          .backgroundColor("#1A333333")
          .borderRadius(2)
          .fontColor("#FF333333")
          .onClick(() => {
            this.mCommonDialogObserved.content = "设置文案"
            this.mCommonDialogObserved.contentTextColor = "#333333"
            this.mMessageDialog.open()
          })

        Text("一个按钮")
          .margin({ left: 5 })
          .padding(5)
          .fontSize(15)
          .backgroundColor("#1A333333")
          .borderRadius(2)
          .fontColor("#FF333333")
          .onClick(() => {
            this.mCommonDialogObserved.content = "一个按钮"
            this.mCommonDialogObserved.contentTextColor = "#333333"
            this.mCommonDialogObserved.isOneBtn = true
            this.mMessageDialog.open()
          })

        Text("两个按钮")
          .margin({ left: 5 })
          .padding(5)
          .fontSize(15)
          .backgroundColor("#1A333333")
          .borderRadius(2)
          .fontColor("#FF333333")
          .onClick(() => {
            this.mCommonDialogObserved.content = "两个按钮"
            this.mCommonDialogObserved.contentTextColor = "#333333"
            this.mCommonDialogObserved.isOneBtn = false
            this.mMessageDialog.open()
          })

      }.width("100%").padding(10).justifyContent(FlexAlign.Start)

      Row() {
        Shape().layoutWeight(1).height(1).backgroundColor("#F5F5F5").margin({ top: 10, bottom: 10 })
      }

      Row() {
        Text("设置颜色")
          .margin({ left: 5 })
          .padding(5)
          .fontSize(15)
          .backgroundColor("#1A333333")
          .borderRadius(2)
          .fontColor("#FF333333")
          .onClick(() => {
            RKTAlertDialog.show({ content: "默认详细描述等等。。。",
              contentTextColor: "#FF0000"
            }, () => {
              promptAction.showToast({ message: "click" })
            })
          })

        Text("设置文案")
          .margin({ left: 5 })
          .padding(5)
          .fontSize(15)
          .backgroundColor("#1A333333")
          .borderRadius(2)
          .fontColor("#FF333333")
          .onClick(() => {
            RKTAlertDialog.show("设置文案设置文案设置文案", () => {
              promptAction.showToast({ message: "click" })
            })
          })

        Text("一个按钮")
          .margin({ left: 5 })
          .padding(5)
          .fontSize(15)
          .backgroundColor("#1A333333")
          .borderRadius(2)
          .fontColor("#FF333333")
          .onClick(() => {
            RKTAlertDialog.show({ content: "一个按钮",
              contentTextColor: "#333333"
            }, () => {
              promptAction.showToast({ message: "click" })
            })
          })

        Text("两个按钮")
          .margin({ left: 5 })
          .padding(5)
          .fontSize(15)
          .backgroundColor("#1A333333")
          .borderRadius(2)
          .fontColor("#FF333333")
          .onClick(() => {

            RKTAlertDialog.show({ content: "两个按钮",
              contentTextColor: "#333333",
              isOneBtn: false
            }, () => {
              promptAction.showToast({ message: "点击确定" })
            }, () => {
              promptAction.showToast({ message: "点击取消" })
            })

          })

      }.width("100%").padding(10).justifyContent(FlexAlign.Start)

      Row() {
        Shape().layoutWeight(1).height(1).backgroundColor("#F5F5F5").margin({ top: 10, bottom: 10 })
      }

      Text("PDF预览器（分别是预览本地PDF文件和预览网络PDF文件。）")
        .margin({ left: 15, right: 15 }).fontSize(12).fontColor("#666666")

      Row() {
        Text("预览本地PDF文件")
          .margin({ left: 5 })
          .padding(5)
          .fontSize(15)
          .backgroundColor(this.isNetPdf ? "#1A333333" : "#1AEF4033")
          .borderRadius(2)
          .fontColor(this.isNetPdf ? "#FF333333" : "#FFEF4033")
          .onClick(() => {
            this.isNetPdf = false
          })

        Text("预览网络PDF文件")
          .margin({ left: 5 })
          .padding(5)
          .fontSize(15)
          .backgroundColor(this.isNetPdf ? "#1AEF4033" : "#1A333333")
          .borderRadius(2)
          .fontColor(this.isNetPdf ? "#FFEF4033" : "#FF333333")
          .onClick(() => {
            this.isNetPdf = true
          })

      }.width("100%").padding(10).justifyContent(FlexAlign.Start)

      Row() {
        Shape().layoutWeight(1).height(1).backgroundColor("#F5F5F5").margin({ top: 10, bottom: 10 })
      }

      RKTPDFViewerDemo({ isNetPdf: $isNetPdf })

    }.alignItems(HorizontalAlign.Start).padding({ top: 20 }).backgroundColor("#FFF")
  }

  /**
   * 滚动选项弹窗
   */
  mOptionsDialog: CustomDialogController = new CustomDialogController({
    builder: RKTOptionsPickerDialog({
      onClickRight: (selectIndex: number, selectValue: string) => {
        promptAction.showToast({ message: selectValue })
      },
      childList: $mChildList,
      title: "请选择",
      tag: "tag"
    }),
    alignment: DialogAlignment.BottomEnd,
    customStyle: true
  })

  //弹窗
  mMessageDialog: CustomDialogController = new CustomDialogController({
    builder: RKTCommonObservedDialog({
      mObserved: this.mCommonDialogObserved,
      onClickEnter: () => {
        promptAction.showToast({ message: this.mCommonDialogObserved.content })
      }
    }),
    alignment: DialogAlignment.Default,
    customStyle: true
  })
}
