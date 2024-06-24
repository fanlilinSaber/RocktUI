import { RUFilterExpandComponentConfig } from '../model/RUFilterExpandComponentConfig'
import { RUAreaModel } from '../other/RUAreaData'
import { RUFilterBoxViewModel } from '../viewModel/RUFilterBoxViewModel'
import {
  RUFilterExpandComponentType,
  RUFilterExpandViewModel } from '../viewModel/RUFilterExpandViewModel'

@Component
export struct RUFilterAreaComponent {
  /*条件筛选的viewModel*/
  @Consume @Watch("filterChange") filterBoxViewModel: RUFilterBoxViewModel
  /*展开组件的viewModel*/
  @Consume filterExpandViewModel: RUFilterExpandViewModel
  /*list的高度*/
  @State listHeight: number = 0
  /*按钮的高度*/
  @State buttonHeight: number = 0
  /*空白的高度*/
  @State blankHeight: string = "0%"
  /*空白的透明度*/

  @State blankTransparency: number = 0
  @State private provinceDataArr: RUFilterExpandComponentConfig[] = []
  @State private cityDataArr: RUFilterExpandComponentConfig[] = []
  @State private areaDataArr: RUFilterExpandComponentConfig[] = []

  /*组件动画*/
  filterChange() {
    if (this.filterExpandViewModel.type == RUFilterExpandComponentType.area) {
      let index = this.filterBoxViewModel.dataArr.findIndex(item => {
        return item.isClick == true && item.canExpand
      })
      index > -1 ? this.show() : this.hide()
    }
  }

  configData() {
    if (this.provinceDataArr.length > 0){
      return
    }
    if (this.filterExpandViewModel.type == RUFilterExpandComponentType.area) {
      this.provinceDataArr = this.filterExpandViewModel.dataArr[0] as RUFilterExpandComponentConfig[]
      this.cityDataArr = this.filterExpandViewModel.dataArr[1] as RUFilterExpandComponentConfig[]
      this.areaDataArr = this.filterExpandViewModel.dataArr[2] as RUFilterExpandComponentConfig[]
    }
  }

  show() {
    animateTo({ duration: 100, curve: Curve.Linear }, () => {
      this.listHeight = 280
      this.buttonHeight = 48
      this.blankTransparency = 0.3
    })
    this.blankHeight = "100%"
  }

  hide() {
    animateTo({ duration: 100, curve: Curve.Linear }, () => {
      this.listHeight = 0
      this.buttonHeight = 0
      this.blankTransparency = 0
    })
    this.blankHeight = "0"
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row }) {
        ForEach((this.filterExpandViewModel.dataArr as RUFilterExpandComponentConfig[][]), (i:RUFilterExpandComponentConfig[], categoryIndex) => {
          List() {
            ForEach(categoryIndex == 0 ? this.provinceDataArr : (categoryIndex == 1 ? this.cityDataArr : this.areaDataArr), (item: RUFilterExpandComponentConfig, index) => {
              ListItem() {
                Row() {
                  Text(item.text)
                    .fontWeight(item.isSelected ? FontWeight.Bold : FontWeight.Normal)
                  if (item.isSelected) {
                    Image($r("app.media.ru_ic_selected"))
                      .size({ width: 14, height: 10 })
                  }
                }
                .onClick(() => {

                })
                .justifyContent(FlexAlign.SpaceBetween)
                .width("100%")
              }
              .backgroundColor(Color.Transparent)
              .padding({ left: 14, right: 14 })
              .height(40)
            }, (item: RUAreaModel) => item.name)
          }
          .height(this.listHeight)
          .alignListItem(ListItemAlign.Start)
          .flexGrow(1)
          .backgroundColor("#F4F4F4")
          .width("100%")
          .onAppear(() => {
            this.configData()
          })
        })
      }

      Flex({ direction: FlexDirection.Row }) {
        Text("重置")
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .backgroundColor(Color.White)
          .flexGrow(1)
          .height(this.buttonHeight)
          .onClick(() => {

          })
        Text("确定")
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor(Color.Red)
          .flexGrow(1)
          .height(this.buttonHeight)
          .onClick(() => {

          })
      }
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
    .opacity((this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig ? (this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig.index == 6 ? 1 : 0) : 0) )
  }
}