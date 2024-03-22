
import { RKTOptionsPickerDialog } from '@zjos/rocketUI'
@Component
export default struct RKTDialogDemo {

  @State mChildList: Array<string> = ["第一个选项", "第二个选项", "第三个选项"]

  build() {
    Column() {
      Row() {
        Text("滚动选项弹窗")
          .padding(2)
          .fontSize(15)
          .backgroundColor("#1A333333")
          .borderRadius(2)
          .fontColor("#FF333333")
          .onClick(() => {
            this.mOptionsDialog.open()
          })

        Text("other")
          .margin({ left: 5 })
          .padding(2)
          .fontSize(15)
          .backgroundColor("#1A333333")
          .borderRadius(2)
          .fontColor("#FF333333")
          .onClick(() => {
          })

      }.width("100%").padding(10).justifyContent(FlexAlign.Start)



    }
  }


  mOptionsDialog: CustomDialogController = new CustomDialogController({
    builder: RKTOptionsPickerDialog({
      onClickLeft: (selectIndex, selectValue) => {

      },
      childList: $mChildList,
      title: "请选择",
      tag: "tag"
    }),
    alignment: DialogAlignment.BottomEnd,
    customStyle: true
  })


}
