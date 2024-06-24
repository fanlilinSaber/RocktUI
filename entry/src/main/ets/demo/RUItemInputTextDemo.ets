import promptAction from '@ohos.promptAction'
import {
  RUItemAddFieldEntity,
  RUItemAddFieldView,
  RUItemInputTextView,
  RUItemInputTextViewObserved,
  RUOrientation
} from '@zjos/rocketUI'

@Component
export default struct RUItemInputTextDemo {

  //水平样式
  @State mHorizontalOb: RUItemInputTextViewObserved = new RUItemInputTextViewObserved({
    orientation: RUOrientation.horizontal,
    leftImage: $r("app.media.icon"),
    leftContent: "水平样式",
    rightContent: "去第二页",
    leftContentFontColor: "#FFFF0000"
  })

  //水平样式(可输入)
  @State mHorizontalInputOb: RUItemInputTextViewObserved = new RUItemInputTextViewObserved({
    orientation: RUOrientation.horizontal,
    leftImage: $r("app.media.icon"),
    leftContent: "水平样式(可输入)",
    isRightInput: true
  })

  //垂直样式
  @State mVerticalOb: RUItemInputTextViewObserved = new RUItemInputTextViewObserved({
    orientation: RUOrientation.vertical,
    leftContent: "垂直样式",
    isBottomInput: true
  })

  //勾选样式
  @State mCheckBoxOb: RUItemInputTextViewObserved = new RUItemInputTextViewObserved({
    orientation: RUOrientation.checkBox,
    leftContent: "勾选样式"
  })


  //新增字段，最多5条
  @State fieldList: Array<RUItemAddFieldEntity> = []

  build() {
    Column() {
      RUItemInputTextView({ mObserved: this.mHorizontalOb, onClickItem: () => {
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
      RUItemInputTextView({ mObserved: this.mHorizontalInputOb, starView: this.defaultBuilder, onClickItem: () => {
        promptAction.showToast({ message: "clickAction-" + this.mHorizontalInputOb.rightContent })
      } }).margin({ top: 10 })

      //
      RUItemInputTextView({ mObserved: this.mVerticalOb, onClickItem: () => {
        promptAction.showToast({ message: "clickAction-" + this.mVerticalOb.bottomContent })
      } }).margin({ top: 20 })

      //
      RUItemInputTextView({ mObserved: this.mCheckBoxOb }).margin({ top: 20 })

      //新增字段组件 【+新增】
      Text("新增字段组件 【+新增】").padding({ top: 20, bottom: 10 })
      RUItemAddFieldView({ fieldList: $fieldList })

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
