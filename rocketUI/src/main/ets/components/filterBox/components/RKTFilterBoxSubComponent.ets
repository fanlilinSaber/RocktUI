import {
  RKTFilterBoxComponentButtonType,
  RKTFilterBoxViewModel
} from '../viewModel/RKTFilterBoxViewModel'

@Component
export struct RKTFilterBoxSubComponent {
  index: number = 0
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
              ? $r("app.color.ru_main_color") : Color.Black)
            : (this.filterBoxViewModel.dataArr[this
          .index].isSelected == true && this.filterBoxViewModel.dataArr[this
            .index].isClick == false
              ? $r("app.color.ru_main_color") : Color.Black))
        Blank().width(5)
        if (this.filterBoxViewModel.dataArr[this.index].isClick == true && this
          .filterBoxViewModel.dataArr[this.index].isSelected == false) {
          Image($r("app.media.ru_ic_arrowUp_grey"))
            .size({ width: 7, height: 5 })
        } else if (this.filterBoxViewModel.dataArr[this.index].isClick == false && this.filterBoxViewModel.dataArr[this.index].isSelected == true) {
          Image($r("app.media.ru_ic_arrowDown_red"))
            .size({ width: 7, height: 5 })
        } else if (this.filterBoxViewModel.dataArr[this.index].isClick == false && this
          .filterBoxViewModel.dataArr[this.index].isSelected == false) {
          Image($r("app.media.ru_ic_arrowDown_grey"))
            .size({ width: 7, height: 5 })
        } else if (this.filterBoxViewModel.dataArr[this.index].isClick == true && this.filterBoxViewModel.dataArr[this.index].isSelected == true) {
          Image($r("app.media.ru_ic_arrowUp_grey"))
            .size({ width: 7, height: 5 })
        } else {
          Image($r("app.media.ru_ic_arrowDown_grey"))
            .size({ width: 7, height: 5 })
        }
      } else {
        Text(this.filterBoxViewModel.dataArr[this.index].text)
          .textAlign(TextAlign.Center)
          .fontColor(this.filterBoxViewModel.dataArr[this.index].isSelected == true ? $r("app.color.ru_main_color") : Color.Black)
      }
    }
    .backgroundColor(this.filterBoxViewModel.dataArr[this.index].type == RKTFilterBoxComponentButtonType.normal
      ? (this.filterBoxViewModel.dataArr[this.index].isSelected == true ? $r("app.color.ru_color_FFEDEDED") : $r("app.color.ru_color_FFFAFAFA"))
      : (this.filterBoxViewModel.dataArr[this.index].isClick ? Color.White : $r("app.color.ru_color_FFEDEDED")))
    .padding({ left: 10, right: 10, top: 5, bottom: 5 })
    .borderRadius(12)
    .border({
      color: this.filterBoxViewModel.dataArr[this.index].type == RKTFilterBoxComponentButtonType.normal ?
        (this.filterBoxViewModel.dataArr[this.index].isSelected == true ? $r("app.color.ru_main_color") : Color.Transparent) :
        (this.filterBoxViewModel.dataArr[this.index].isSelected == true && this
          .filterBoxViewModel.dataArr[this.index].isClick == false ? $r("app.color.ru_main_color") : Color.Transparent),
      width: .5
    })
  }
}