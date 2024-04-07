import { RKTFilterBoxComponentConfig } from '../model/RKTFilterBoxComponentConfig'
import {
  RKTFilterBoxComponentButtonType,
  RKTFilterBoxViewModel
} from '../viewModel/RKTFilterBoxViewModel'

@Component
export struct RKTFilterBoxSubComponent {
  index: number
  @Consume filterBoxViewModel: RKTFilterBoxViewModel

  build() {
    Row() {
      if (this.filterBoxViewModel.dataArr[this.index].type ==
      RKTFilterBoxComponentButtonType
        .rightButton) {
        Text(this.filterBoxViewModel.dataArr[this.index].text)
          .textAlign(TextAlign.Center)
          .fontColor(this.filterBoxViewModel.dataArr[this.index].type ==
          RKTFilterBoxComponentButtonType.normal
            ? (this.filterBoxViewModel.dataArr[this
          .index].isSelected == true
              ? $r("app.color.color_FFEF4033") : Color.Black)
            : (this.filterBoxViewModel.dataArr[this
          .index].isSelected == true && this.filterBoxViewModel.dataArr[this
            .index].isClick == false
              ? $r("app.color.color_FFEF4033") : Color.Black))
        Blank().width(5)
        if (this.filterBoxViewModel.dataArr[this.index].isClick == true && this
          .filterBoxViewModel.dataArr[this.index].isSelected == false) {
          Image($r("app.media.ic_arrowUp_grey"))
            .size({ width: 7, height: 5 })
        } else if (this.filterBoxViewModel.dataArr[this.index].isClick == false && this.filterBoxViewModel.dataArr[this.index].isSelected == true) {
          Image($r("app.media.ic_arrowDown_red"))
            .size({ width: 7, height: 5 })
        } else if (this.filterBoxViewModel.dataArr[this.index].isClick == false && this
          .filterBoxViewModel.dataArr[this.index].isSelected == false) {
          Image($r("app.media.ic_arrowDown_grey"))
            .size({ width: 7, height: 5 })
        } else if (this.filterBoxViewModel.dataArr[this.index].isClick == true && this.filterBoxViewModel.dataArr[this.index].isSelected == true) {
          Image($r("app.media.ic_arrowUp_grey"))
            .size({ width: 7, height: 5 })
        } else {
          Image($r("app.media.ic_arrowDown_grey"))
            .size({ width: 7, height: 5 })
        }
      } else {
        Text(this.filterBoxViewModel.dataArr[this.index].text)
          .textAlign(TextAlign.Center)
          .fontColor(this.filterBoxViewModel.dataArr[this.index].isSelected == true ? $r("app.color.color_FFEF4033") : Color.Black)
      }
    }
    .backgroundColor(this.filterBoxViewModel.dataArr[this.index].type == RKTFilterBoxComponentButtonType.normal
      ? (this.filterBoxViewModel.dataArr[this.index].isSelected == true ? $r("app.color.color_FFEDEDED") : $r("app.color.color_FFFAFAFA"))
      : (this.filterBoxViewModel.dataArr[this.index].isClick ? Color.White : $r("app.color.color_FFEDEDED")))
    .padding({ left: 10, right: 10, top: 5, bottom: 5 })
    .borderRadius(12)
    .border({
      color: this.filterBoxViewModel.dataArr[this.index].type == RKTFilterBoxComponentButtonType.normal ?
        (this.filterBoxViewModel.dataArr[this.index].isSelected == true ? $r("app.color.color_FFEF4033") : Color.Transparent) :
        (this.filterBoxViewModel.dataArr[this.index].isSelected == true && this
          .filterBoxViewModel.dataArr[this.index].isClick == false ? $r("app.color.color_FFEF4033") : Color.Transparent),
      width: .5
    })
  }
}