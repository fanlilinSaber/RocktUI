import display from '@ohos.display';

@Component
export struct RKTGridMenuPopupView {
  @State topMargin: number = 44
  @State selectIndex: number = 0
  @State gridMenuTitles: string[] = []
  private itemWidth: number = 80
  private itemHeight: number = 35
  private gridColumnTemplate: string = ''
  private maxHeight: number = 240
  private heightValue: number
  clickAction: (index: number) => void
  cancelAction: () => void

  aboutToAppear() {
    let screenWidth = Math.ceil(px2vp(display.getDefaultDisplaySync().width))
    let maxRow = Math.floor((screenWidth - 15 * 2 + 10) / (this.itemWidth + 10))
    var columns = Math.ceil(this.gridMenuTitles.length / maxRow)
    this.gridColumnTemplate = '1fr '.repeat(maxRow)
    this.heightValue = columns * (this.itemHeight + 10) + 10 > this.maxHeight ? this.maxHeight : columns * (this.itemHeight + 10) + 10
  }

  @Builder gridMenuItem($$: {
    title: string,
    isSelect: boolean
  }) {
    Text($$.title)
      .fontSize(12)
      .fontColor($$.isSelect ? "#EF4033" : "#666666")
      .textAlign(TextAlign.Center)
      .backgroundColor($$.isSelect ? "#1AEF4033" : "#F5F5F5")
      .borderRadius(2)
      .borderWidth($$.isSelect ? 1 : 0)
      .borderColor($$.isSelect ? "#EF4033" : "#F5F5F5")
      .width(this.itemWidth)
      .height(this.itemHeight)
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.gridMenuTitles, (title, index) => {
          GridItem() {
            this.gridMenuItem({ title: title, isSelect: this.selectIndex == index })
          }
          .onClick(() => {
            this.selectIndex = index
            this.clickAction(this.selectIndex)
          })
        })
      }
      .backgroundColor(Color.White)
      .columnsTemplate(this.gridColumnTemplate)
      // .rowsTemplate(this.gridRowTemplate)
      .columnsGap(10)
      .rowsGap(10)
      .padding({ left: 10, right: 10, bottom: 10 })
      .height(this.heightValue)
      .borderRadius({ bottomLeft: 12, bottomRight: 12 })

      Blank()
        .onClick(() => {
          this.cancelAction()
        })
    }
    .backgroundColor("#7F000000")
    .width('100%')
    .height('100%')
    .margin({ top: this.topMargin })
  }
}