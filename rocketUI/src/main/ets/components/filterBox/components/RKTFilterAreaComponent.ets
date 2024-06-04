import { RKTFilterExpandComponentConfig } from '../model/RKTFilterExpandComponentConfig'
import { AreaModel } from '../other/AreaData'
import { RKTFilterBoxViewModel } from '../viewModel/RKTFilterBoxViewModel'
import {
  RKTFilterExpandComponentType,
  RKTFilterExpandViewModel } from '../viewModel/RKTFilterExpandViewModel'

@Component
export struct RKTFilterAreaComponent {
  /*条件筛选的viewModel*/
  @Consume @Watch("filterChange") filterBoxViewModel: RKTFilterBoxViewModel
  /*展开组件的viewModel*/
  @Consume filterExpandViewModel: RKTFilterExpandViewModel
  /*list的高度*/
  @State listHeight: number = 0
  /*按钮的高度*/
  @State buttonHeight: number = 0
  /*空白的高度*/
  @State blankHeight: string = "0%"
  /*空白的透明度*/

  @State blankTransparency: number = 0
  @State private provinceDataArr: RKTFilterExpandComponentConfig[] = []
  @State private cityDataArr: RKTFilterExpandComponentConfig[] = []
  @State private areaDataArr: RKTFilterExpandComponentConfig[] = []

  /*组件动画*/
  filterChange() {
    if (this.filterExpandViewModel.type == RKTFilterExpandComponentType.area) {
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
    if (this.filterExpandViewModel.type == RKTFilterExpandComponentType.area) {
      this.provinceDataArr = this.filterExpandViewModel.dataArr[0] as RKTFilterExpandComponentConfig[]
      this.cityDataArr = this.filterExpandViewModel.dataArr[1] as RKTFilterExpandComponentConfig[]
      this.areaDataArr = this.filterExpandViewModel.dataArr[2] as RKTFilterExpandComponentConfig[]
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
        ForEach((this.filterExpandViewModel.dataArr as RKTFilterExpandComponentConfig[][]), (i:RKTFilterExpandComponentConfig[], categoryIndex) => {
          List() {
            ForEach(categoryIndex == 0 ? this.provinceDataArr : (categoryIndex == 1 ? this.cityDataArr : this.areaDataArr), (item: RKTFilterExpandComponentConfig, index) => {
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
            }, (item: AreaModel) => item.name)
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