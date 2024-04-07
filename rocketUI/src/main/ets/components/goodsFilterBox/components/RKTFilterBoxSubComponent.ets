import { RKTFilterBoxComponentConfig } from '../model/RKTFilterBoxComponentConfig'
import {
  RKTFilterBoxComponentButtonType,
  RKTFilterBoxViewModel
} from '../viewModel/RKTFilterBoxViewModel'

@Component
export struct RKTFilterBoxSubComponent {
  index: number
  @Consume RKTFilterBoxViewModel: RKTFilterBoxViewModel

  build() {
    Row() {
      if (this.RKTFilterBoxViewModel.dataArr[this.index].type ==
      RKTFilterBoxComponentButtonType
        .rightButton) {
        Text(this.RKTFilterBoxViewModel.dataArr[this.index].text)
          .textAlign(TextAlign.Center)
          .fontColor(this.RKTFilterBoxViewModel.dataArr[this.index].type ==
          RKTFilterBoxComponentButtonType.normal
            ? (this.RKTFilterBoxViewModel.dataArr[this
          .index].isSelected == true
              ? $r("app.color.color_FFEF4033") : Color.Black)
            : (this.RKTFilterBoxViewModel.dataArr[this
          .index].isSelected == true
              ? $r("app.color.color_FFEF4033") : Color.Black))
        Blank().width(5)
        if (this.RKTFilterBoxViewModel.dataArr[this.index].isClick == true && this
          .RKTFilterBoxViewModel.dataArr[this.index].isSelected == false) {
          Image($r("app.media.ic_arrowUp_grey"))
            .size({ width: 7, height: 5 })
        } else if (this.RKTFilterBoxViewModel.dataArr[this.index].isClick == false && this.RKTFilterBoxViewModel.dataArr[this.index].isSelected == true) {
          Image($r("app.media.ic_arrowDown_red"))
            .size({ width: 7, height: 5 })
        } else if (this.RKTFilterBoxViewModel.dataArr[this.index].isClick == false && this
          .RKTFilterBoxViewModel.dataArr[this.index].isSelected == false) {
          Image($r("app.media.ic_arrowDown_grey"))
            .size({ width: 7, height: 5 })
        } else if (this.RKTFilterBoxViewModel.dataArr[this.index].isClick == true && this.RKTFilterBoxViewModel.dataArr[this.index].isSelected == true) {
          Image($r("app.media.ic_arrowUp_grey"))
            .size({ width: 7, height: 5 })
        } else {
          Image($r("app.media.ic_arrowDown_grey"))
            .size({ width: 7, height: 5 })
        }
      } else {
        Text(this.RKTFilterBoxViewModel.dataArr[this.index].text)
          .textAlign(TextAlign.Center)
          .fontColor(this.RKTFilterBoxViewModel.dataArr[this.index].isSelected == true ? $r("app.color.color_FFEF4033") : Color.Black)
      }
    }
    .backgroundColor(this.RKTFilterBoxViewModel.dataArr[this.index].type == RKTFilterBoxComponentButtonType.normal
      ? (this.RKTFilterBoxViewModel.dataArr[this.index].isSelected == true ? $r("app.color.color_FFEDEDED") : $r("app.color.color_FFFAFAFA"))
      : (this.RKTFilterBoxViewModel.dataArr[this.index].isClick ? Color.White : $r("app.color.color_FFEDEDED")))
    .padding({ left: 10, right: 10, top: 5, bottom: 5 })
    .borderRadius(12)
    .border({
      color: this.RKTFilterBoxViewModel.dataArr[this.index].type == RKTFilterBoxComponentButtonType.normal ?
        (this.RKTFilterBoxViewModel.dataArr[this.index].isSelected == true ? $r("app.color.color_FFEF4033") : Color.Transparent) :
        (this.RKTFilterBoxViewModel.dataArr[this.index].isSelected == true && this
          .RKTFilterBoxViewModel.dataArr[this.index].isClick == false ? $r("app.color.color_FFEF4033") : Color.Transparent),
      width: .5
    })
  }
}