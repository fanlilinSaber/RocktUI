import { GoodsFilterBoxComponentConfig } from '../model/GoodsFilterBoxComponentConfig'
import {
  GoodsFilterBoxComponentButtonType,
  GoodsFilterBoxViewModel
} from '../viewModel/GoodsFilterBoxViewModel'

@Component
export struct GoodsFilterBoxComponentSub {
  index: number
  @Consume goodsFilterBoxViewModel: GoodsFilterBoxViewModel

  build() {
    Row() {
      if (this.goodsFilterBoxViewModel.dataArr[this.index].type ==
      GoodsFilterBoxComponentButtonType
        .rightButton) {
        Text(this.goodsFilterBoxViewModel.dataArr[this.index].text)
          .textAlign(TextAlign.Center)
          .fontColor(this.goodsFilterBoxViewModel.dataArr[this.index].type ==
          GoodsFilterBoxComponentButtonType.normal ? (this.goodsFilterBoxViewModel.dataArr[this
          .index].isSelected == true ? $r("app.color.color_FFEF4033") : Color.Black) : (this.goodsFilterBoxViewModel.dataArr[this
          .index].isClick == true ? $r("app.color.color_FFEF4033") : Color.Black))
        Blank().width(5)
        if (this.goodsFilterBoxViewModel.dataArr[this.index].isClick == true && this
          .goodsFilterBoxViewModel.dataArr[this.index].isSelected == false) {
          Image($r("app.media.ic_arrowUp_grey"))
            .size({ width: 7, height: 5 })
        } else if (this.goodsFilterBoxViewModel.dataArr[this.index].isClick == false && this.goodsFilterBoxViewModel.dataArr[this.index].isSelected == true) {
          Image($r("app.media.ic_arrowDown_red"))
            .size({ width: 7, height: 5 })
        } else if (this.goodsFilterBoxViewModel.dataArr[this.index].isClick == false && this
          .goodsFilterBoxViewModel.dataArr[this.index].isSelected == false) {
          Image($r("app.media.ic_arrowDown_grey"))
            .size({ width: 7, height: 5 })
        } else if (this.goodsFilterBoxViewModel.dataArr[this.index].isClick == true && this.goodsFilterBoxViewModel.dataArr[this.index].isSelected == true) {
          Image($r("app.media.ic_arrowUp_grey"))
            .size({ width: 7, height: 5 })
        } else {
          Image($r("app.media.ic_arrowDown_grey"))
            .size({ width: 7, height: 5 })
        }
      } else {
        Text(this.goodsFilterBoxViewModel.dataArr[this.index].text)
          .textAlign(TextAlign.Center)
          .fontColor(this.goodsFilterBoxViewModel.dataArr[this.index].isSelected == true ? $r("app.color.color_FFEF4033") : Color.Black)
      }
    }
    .backgroundColor(this.goodsFilterBoxViewModel.dataArr[this.index].type == GoodsFilterBoxComponentButtonType.normal
      ? (this.goodsFilterBoxViewModel.dataArr[this.index].isSelected == true ? $r("app.color.color_FFEDEDED") : $r("app.color.color_FFFAFAFA"))
      : (this.goodsFilterBoxViewModel.dataArr[this.index].isClick ? Color.White : $r("app.color.color_FFEDEDED")))
    .padding({ left: 10, right: 10, top: 5, bottom: 5 })
    .borderRadius(12)
    .border({
      color: this.goodsFilterBoxViewModel.dataArr[this.index].type == GoodsFilterBoxComponentButtonType.normal ?
        (this.goodsFilterBoxViewModel.dataArr[this.index].isSelected == true ? $r("app.color.color_FFEF4033") : Color.Transparent) :
        (this.goodsFilterBoxViewModel.dataArr[this.index].isSelected == true && this
          .goodsFilterBoxViewModel.dataArr[this.index].isClick == false ? $r("app.color.color_FFEF4033") : Color.Transparent),
      width: .5
    })
  }
}