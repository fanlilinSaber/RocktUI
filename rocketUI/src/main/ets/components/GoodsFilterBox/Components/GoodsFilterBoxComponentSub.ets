import { GoodsFilterBoxComponentButtonType } from './GoodsFilterBoxComponent'
import { GoodsFilterBoxComponentConfig } from '../Model/GoodsFilterBoxComponentConfig'
@Component
export struct GoodsFilterBoxComponentSub {
  @ObjectLink item: GoodsFilterBoxComponentConfig

  build() {
    Row() {
      if (this.item.type == GoodsFilterBoxComponentButtonType.rightButton) {
        Text(this.item.text)
          .textAlign(TextAlign.Center)
          .fontColor(this.item.isSelected == true && this.item.isClick == false ? $r("app.color.color_FFFF2928") : Color.Black)

        Blank().width(5)
        if (this.item.isClick == true && this.item.isSelected == false) {
          Image($r("app.media.ic_arrowUp_grey"))
            .size({ width: 7, height: 5 })
        } else if (this.item.isClick == false && this.item.isSelected == true) {
          Image($r("app.media.ic_arrowDown_red"))
            .size({ width: 7, height: 5 })
        } else if (this.item.isClick == false && this.item.isSelected == true) {
          Image($r("app.media.ic_arrowDown_grey"))
            .size({ width: 7, height: 5 })
        } else if (this.item.isClick == true && this.item.isSelected == true) {
          Image($r("app.media.ic_arrowUp_grey"))
            .size({ width: 7, height: 5 })
        } else {
          Image($r("app.media.ic_arrowDown_grey"))
            .size({ width: 7, height: 5 })
        }
      } else {
        Text(this.item.text)
          .textAlign(TextAlign.Center)
          .fontColor(this.item.isSelected == true ? $r("app.color.color_FFFF2928") : Color.Black)
      }
    }
    .backgroundColor(this.item.type == GoodsFilterBoxComponentButtonType.normal
      ? (this.item.isSelected == true ? $r("app.color.color_FFFAFAFA") : $r("app.color.color_FFFAFAFA"))
      : (this.item.isClick ? Color.White : $r
      ("app.color.color_FFFAFAFA")))
    .padding({ left: 10, right: 10, top: 5, bottom: 5 })
    .borderRadius(12)
    .border({
      color: this.item.type == GoodsFilterBoxComponentButtonType.normal ?
        (this.item.isSelected == true ? $r("app.color.color_FFFF2928") : Color.Transparent) :
        (this.item.isSelected == true && this.item.isClick == false ? $r("app.color.color_FFFF2928") : Color.Transparent),
      width: .5
    })
  }
}