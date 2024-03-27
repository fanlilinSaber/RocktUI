import promptAction from '@ohos.promptAction'
import {
  RKTItemAddFieldEntity,
  RKTItemAddFieldView,
  RKTItemInputTextView,
  RKTItemInputTextViewObserved,
  RKTOrientation
} from '@zjos/rocketUI'

@Component
export default struct RKTItemInputTextDemo {

  //水平样式
  @State mHorizontalOb: RKTItemInputTextViewObserved = new RKTItemInputTextViewObserved({
    orientation: RKTOrientation.horizontal,
    leftImage: $r("app.media.icon"),
    leftContent: "水平样式",
    rightContent: "去第二页",
    leftContentFontColor: "#FFFF0000"
  })

  //水平样式(可输入)
  @State mHorizontalInputOb: RKTItemInputTextViewObserved = new RKTItemInputTextViewObserved({
    orientation: RKTOrientation.horizontal,
    leftImage: $r("app.media.icon"),
    leftContent: "水平样式(可输入)",
    isRightInput: true
  })

  //垂直样式
  @State mVerticalOb: RKTItemInputTextViewObserved = new RKTItemInputTextViewObserved({
    orientation: RKTOrientation.vertical,
    leftContent: "垂直样式",
    isBottomInput: true
  })

  //勾选样式
  @State mCheckBoxOb: RKTItemInputTextViewObserved = new RKTItemInputTextViewObserved({
    orientation: RKTOrientation.checkBox,
    leftContent: "勾选样式"
  })


  //新增字段，最多5条
  @State fieldList: Array<RKTItemAddFieldEntity> = []

  build() {
    Column() {
      RKTItemInputTextView({ mObserved: this.mHorizontalOb, onClickItem: () => {
        promptAction.showToast({ message: "clickAction-" + this.mHorizontalOb.rightContent })
      } }) {
        Text("标签")
          .margin({ left: 5 })
          .padding(2)
          .fontSize(10)
          .backgroundColor("#1A5792FD")
          .borderRadius(2)
          .fontColor("#FF5792FD")
      }

      Row() {
        Text("颜色")
          .padding(2)
          .fontSize(15)
          .backgroundColor("#1A333333")
          .borderRadius(2)
          .fontColor("#FF333333")
          .onClick(() => {
            this.mHorizontalOb.leftContentFontColor = Math.random() * 1000000
          })

        Text("分割线")
          .margin({ left: 5 })
          .padding(2)
          .fontSize(15)
          .backgroundColor("#1A333333")
          .borderRadius(2)
          .fontColor("#FF333333")
          .onClick(() => {
            this.mHorizontalOb.isShowBottomLine = !this.mHorizontalOb.isShowBottomLine
          })

      }.width("100%").padding(10).justifyContent(FlexAlign.Start)

      //水平样式(可输入)
      RKTItemInputTextView({ mObserved: this.mHorizontalInputOb, starView: this.defaultBuilder, onClickItem: () => {
        promptAction.showToast({ message: "clickAction-" + this.mHorizontalInputOb.rightContent })
      } }).margin({ top: 10 })

      //
      RKTItemInputTextView({ mObserved: this.mVerticalOb, onClickItem: () => {
        promptAction.showToast({ message: "clickAction-" + this.mVerticalOb.bottomContent })
      } }).margin({ top: 20 })

      //
      RKTItemInputTextView({ mObserved: this.mCheckBoxOb }).margin({ top: 20 })

      //新增字段组件 【+新增】
      Text("新增字段组件 【+新增】").padding({ top: 20, bottom: 10 })
      RKTItemAddFieldView({ fieldList: $fieldList })

    }
  }

  @Builder defaultBuilder() {
    Text("标签")
      .margin({ left: 5 })
      .padding(2)
      .fontSize(10)
      .backgroundColor("#1AEF4033")
      .borderRadius(2)
      .fontColor("#FFEF4033")
  }
}
