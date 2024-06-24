import Prompt from '@system.prompt'
import { RUItemAddFieldEntity } from './RUItemAddFieldEntity'
import { RUItemAddFieldChildView } from './RUItemAddFieldChildView'

/**
 * 新增字段组件 【+新增】
 * @author shengjie
 * @time 2023.12.21 10:15
 */
@Component
export struct RUItemAddFieldView {
  @Link fieldList: Array<RUItemAddFieldEntity>
  @State listHeight: number = 0
  @State bottomLine: boolean = false

  build() {
    Column() {
      Row() {
        Text("新增字段")
          .fontSize(15)
          .padding({ top: 15, bottom: 15 })
          .fontColor($r("app.color.ru_color_FF333333"))
          .layoutWeight(1)

        Text("+ 新增")
          .fontSize(14)
          .padding({ top: 2, bottom: 2, left: 5, right: 5 })
          .fontColor($r("app.color.ru_color_FF5792FD"))
          .borderColor($r("app.color.ru_color_FF5792FD"))
          .borderWidth(0.5)
          .borderRadius(5)
          .onClick(() => {
            if (this.fieldList == null) {
              this.fieldList = []
            }
            if (this.fieldList.length == 5) {
              Prompt.showToast({ message: "数量已达上限" })
              return
            } else {
              for (let i = 0; i < this.fieldList.length; i++) {
                let element = this.fieldList[i]
                if (element.key == undefined || element.key == null || element.key.length == 0) {
                  Prompt.showToast({ message: "请输入新增标题" })
                  return
                }
                if (element.value == undefined || element.value == null || element.value.length == 0) {
                  Prompt.showToast({ message: "请输入新增内容" })
                  return
                }
              }
            }
            this.fieldList.push(new RUItemAddFieldEntity())
          })
      }
      .width("100%")
      .padding({ right: 5 })
      .justifyContent(FlexAlign.Start)

      List() {
        ForEach(this.fieldList, (item : RUItemAddFieldEntity, index) => {
          ListItem() {
            RUItemAddFieldChildView({ itemData: item, onDateChange: (itemData: RUItemAddFieldEntity) => {
              this.fieldList[index] = itemData
            },
              clickAction: () => {
                this.fieldList = this.fieldList.filter((value, i) => i !== index)
              }
            })
          }
        })
      }
      .width("100%")

      if (this.bottomLine) {
        Divider().width('100%').height(0.5).color($r("app.color.ru_color_FFEDEDED"))
      }
    }
    .width("100%")
    .padding({ left: 15, right: 10 })
    .backgroundColor($r("app.color.ru_color_FFFFFFFF"))
  }
}



