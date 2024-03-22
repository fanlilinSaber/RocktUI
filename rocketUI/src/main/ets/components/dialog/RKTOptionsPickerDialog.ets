/**
 * 滚动选项弹窗
 * @author shengjie
 * @time 2023.12.09 10:45
 */
@CustomDialog
export struct RKTOptionsPickerDialog {
  controller: CustomDialogController
  onClickLeft: Function = (selectIndex: number, selectValue: string) => {
  }
  onClickRight: Function = (selectIndex: number, selectValue: string) => {
  }
  enterTextColor: Resource | string
  cancelTextColor: Resource | string
  enterText: string
  title: string
  cancelText: string
  tag: string
  selectIndex: number = 0
  @Link childList: Array<string>
  private selectValue: string = this.childList.length > 0 ? this.childList[0] : ""

  build() {
    Column() {
      Row() {
        Text(this.cancelText??"取消")
          .padding({ left: 20 })
          .fontColor(this.cancelTextColor??"#666666")
          .onClick(() => {
            this.controller.close()
            if (this.onClickLeft) {
              if (this.childList != null && this.childList.length > 0 && (this.selectValue == null || this.selectValue.length == 0)) {
                this.selectIndex = 0
                this.selectValue = this.childList[0]
              }
              this.onClickLeft(this.selectIndex, this.selectValue)
            }
          })
          .textAlign(TextAlign.Center)
          .width(60)
          .height(44)
        Text(this.title??"")
          .fontColor(this.cancelTextColor??"#969696")
          .textAlign(TextAlign.Center)
          .maxLines(1)
          .padding({ left: 80, right: 80 })
          .height(44)
          .layoutWeight(1)
        Text(this.enterText??"确定")
          .padding({ right: 20 })
          .fontColor(this.cancelTextColor??"#5792FD")
          .onClick(() => {
            this.controller.close()
            if (this.onClickRight) {
              if (this.childList != null && this.childList.length > 0 && (this.selectValue == null || this.selectValue.length == 0)) {
                this.selectIndex = 0
                this.selectValue = this.childList[0]
              }
              this.onClickRight(this.selectIndex, this.selectValue)
            }
          })
          .textAlign(TextAlign.Center)
          .width(60)
          .height(44)
      }
      .backgroundColor("#F5F5F5")
      .width("100%")
      .height(49)
      .justifyContent(FlexAlign.Center)

      TextPicker({ range: this.childList, selected: this.selectIndex })
        .onChange((value: string, index: number) => {
          this.selectIndex = index
          this.selectValue = value
        })
        .width("100%")
        .height(180)
    }
    .backgroundColor(Color.White)
    .width("100%")
    .height(224)
  }
}









