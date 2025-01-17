import { RUFilterExpandComponentConfig } from '../model/RUFilterExpandComponentConfig'
import { RUFilterBoxViewModel } from '../viewModel/RUFilterBoxViewModel'
import {
  RUFilterExpandComponentType,
  RUFilterExpandViewModel } from '../viewModel/RUFilterExpandViewModel'

/*这个组件是显示单选多选选项的组件*/
@Component
export struct RUFilterAllItemComponent {
  /*条件筛选的viewModel*/
  @Consume @Watch("filterChange") filterBoxViewModel: RUFilterBoxViewModel
  /*展开组件的viewModel*/
  @Consume filterExpandViewModel: RUFilterExpandViewModel
  /*私有化的数据源*/
  @State private privateDataArr: RUFilterExpandComponentConfig[] = []
  /*list的高度*/
  @State listHeight: number = 0
  /*按钮的高度*/
  @State buttonHeight: number = 0
  /*空白的高度*/
  @State blankHeight: string = "0%"
  /*空白的高度*/
  @State blankTransparency: number = 0
  /*每一项的高度*/
  @State itemHeight: number = 0
  /*选中状态的字体*/
  selFontSize: number = 14
  /*正常状态的字体颜色*/
  textColor: ResourceColor = Color.Black
  /*选中状态的字体颜色*/
  selTextColor: ResourceColor = $r("app.color.ru_main_color")
  /*正常状态的字体*/
  fontSize: number = 14

  filterChange() {
    if (this.filterExpandViewModel.type == RUFilterExpandComponentType.other){
      let index = this.filterBoxViewModel.dataArr.findIndex((item) => {
        return item.isClick == true && item.canExpand
      })
      index > -1 ? this.show() : this.hide()
    }
  }

  show() {
    animateTo({ duration: 100, curve: Curve.Linear }, () => {
      this.listHeight = 95
      this.buttonHeight = 40
      this.itemHeight = 35
      this.blankTransparency = 0.3
    })
    this.blankHeight = "100%"
  }

  hide() {
    /*如果没有选中保存，则清空*/
    animateTo({ duration: 100, curve: Curve.Linear }, () => {
      this.listHeight = 0
      this.buttonHeight = 0
      this.itemHeight = 0
      this.blankTransparency = 0
    })
    this.blankHeight = "0%"
  }

  build() {
    Column() {
      if (this.listHeight > 0) {
        Grid() {
          ForEach(this.privateDataArr, (item: RUFilterExpandComponentConfig, index) => {
            GridItem() {
              Text(item.text)
                .fontColor(item.isSelected ? this.selTextColor : this.textColor)
                .fontSize(item.isSelected ? this.selFontSize : this.fontSize)
                .backgroundColor(item.isSelected ? "#ffe9e8" : "#f4f4f4")
                .height(this.itemHeight)
                .constraintSize({ minWidth: 85 })
                .textAlign(TextAlign.Center)
                .border({
                  width: .5,
                  color: item.isSelected == true ? this.selTextColor : Color.Transparent,
                  radius: 5
                })
                .onClick(() => {
                  if (this.filterExpandViewModel.isSingle) {
                    this.privateDataArr.forEach(item => {
                      item.isSelected = false
                    })
                  }
                  item.isSelected = !item.isSelected
                  this.privateDataArr.splice(index, 1, item)
                  this.privateDataArr = this.privateDataArr.slice()
                })
            };
          })
        }
        .onAppear(() => {
          /*我这么写是为了在这个组件内部生成一个私有的数据源，在没点确定按钮的时候，保证外部数据不被改变*/
          this.privateDataArr = JSON.parse(JSON.stringify(this.filterExpandViewModel.dataArr))
        })
        .width("100%")
        .height(this.listHeight)
        .padding({ left: 12, right: 12, top: 15, bottom: 20 })
        .backgroundColor(Color.White)
        .columnsGap(10)
        .columnsTemplate("1fr 1fr 1fr 1fr")
        .rowsGap(10)
      }

      Row() {
        Text("重置")
          .fontColor(Color.Black)
          .backgroundColor("#f4f4f4")
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 15, left: 5 })
          .height(this.buttonHeight)
          .borderRadius(5)
          .onClick(() => {
            this.privateDataArr.forEach(item => item.isSelected = false)
            this.privateDataArr = this.privateDataArr.slice()
          })

        Text("确定")
          .backgroundColor($r("app.color.ru_main_color"))
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .flexGrow(1)
          .margin({ right: 15, left: 5 })
          .height(this.buttonHeight)
          .borderRadius(5)
          .onClick(() => {
            this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig!.isClick = false
            this.privateDataArr.forEach((privateItem, index) => {
              (this.filterExpandViewModel.dataArr[index] as RUFilterExpandComponentConfig).isSelected = privateItem.isSelected
            })
            let selArray = (this.filterExpandViewModel.dataArr as RUFilterExpandComponentConfig[]).filter(item => item.isSelected)
            if (selArray !== null && selArray !== undefined && selArray.length != 0) {
              this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig!.isSelected = true
              this.filterExpandViewModel.makeSureCallBack(selArray)
            } else {
              this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig!.isSelected = false
            }
            this.filterBoxViewModel.dataArr = this.filterBoxViewModel.dataArr.slice()
            this.hide()
          })
      }
      .padding({ top: this.buttonHeight > 0 ? 8 : 0, bottom: this.buttonHeight > 0 ? 8 : 0 })
      .backgroundColor(Color.White)
      .borderRadius({ bottomLeft: 10, bottomRight: 10 })
      .width("100%")

      Blank()
        .height(this.blankHeight)
        .width("100%")
        .backgroundColor(Color.Black)
        .opacity(this.blankTransparency)
        .onClick(() => {
          if (typeof this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig != "undefined") {
            this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig.isClick = false
          }
          this.filterBoxViewModel.dataArr = this.filterBoxViewModel.dataArr.slice()
          this.hide()
        })
    }
    .opacity((this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig ? (this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig.index != 6 ? 1 : 0) : 0) )
  }
}
