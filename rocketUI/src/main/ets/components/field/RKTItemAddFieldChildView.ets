
import { RKTItemAddFieldEntity } from './RKTItemAddFieldEntity'

/**
 * 新增字段组件 【+新增】
 * @author shengjie
 * @time 2023.12.21 10:15
 */
@Component
export struct RKTItemAddFieldChildView {
  itemData: RKTItemAddFieldEntity = new RKTItemAddFieldEntity()
  clickAction: Function = (result?: string) => {
  }
  onDateChange: Function = (itemData?: RKTItemAddFieldEntity) => {
  }

  build() {
    Stack() {
      Column() {
        TextArea({ placeholder: "请输入标题", text: this.itemData.key })
          .placeholderColor($r("app.color.color_FFC0C4CC"))
          .fontSize(15)
          .padding({ top: 15, bottom: 15 })
          .fontColor($r("app.color.color_FF333333"))
          .backgroundColor($r("app.color.color_FFFAFAFA"))
          .onChange((value: string) => {
            if (this.itemData.key === value) {
              return
            }
            this.itemData.key = value
            this.onDateChange(this.itemData)
          })

        Shape()
          .height(0.5)
          .backgroundColor($r("app.color.color_FFEDEDED"))
          .width("100%")

        TextArea({ placeholder: "请输入内容", text: this.itemData.value })
          .placeholderColor($r("app.color.color_FFC0C4CC"))
          .fontSize(15)
          .padding({ top: 15, bottom: 15 })
          .fontColor($r("app.color.color_FF333333"))
          .backgroundColor($r("app.color.color_FFFAFAFA"))
          .onChange((value: string) => {
            if (this.itemData.value === value) {
              return
            }
            this.itemData.value = value
            this.onDateChange(this.itemData)
          })
      }
      .layoutWeight(1)
      .borderRadius(2)
      .borderColor($r("app.color.color_FFFAFAFA"))
      .backgroundColor($r("app.color.color_FFFAFAFA"))
      .padding({ left: 15, right: 15 })
      .margin({ top: 5, right: 5 })

      Image($r("app.media.rkt_ic_field_del"))
        .width(30)
        .width(32)
        .padding({ left: 20, top: 0, bottom: 22, right: 0 })
        .onClick(() => {
          this.clickAction()
        })
    }.alignContent(Alignment.TopEnd).margin({ bottom: 6 })
  }
}

