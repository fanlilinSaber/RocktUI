import { GoodsFilterBoxComponentConfig } from '../Model/GoodsFilterBoxComponentConfig'

export interface GoodsAllItemComponentModel {
  id: string,
  title: string
}

@Component
export struct GoodsAllItemComponent {
  /*config*/
  @Link item: GoodsFilterBoxComponentConfig
  /*是否展示,和上一个页面双向同步*/
  @Watch("componentAnimate") @Link expandIndex: number
  /*这个参数和expandIndex一样时，就表示可以展开了*/
  configExpandIndex: number
  /*list的高度*/
  @State listHeight: number = 0
  /*按钮的高度*/
  @State buttonHeight: number = 0
  /*空白的高度*/
  @State blankHeight: string = "0%"
  /*每一项的高度*/
  @State itemHeight: number = 0
  /*所有的数据*/
  data: GoodsAllItemComponentModel[]
  @State private selectedIndex: number = -1

  /*选中状态的字体*/
  selFontSize: number = 14
  /*正常状态的字体颜色*/
  textColor: ResourceColor = Color.Black
  /*选中状态的字体颜色*/
  selTextColor: ResourceColor = $r("app.color.color_FFFF2928")
  /*正常状态的字体*/
  fontSize: number = 14
  /*组件动画*/
  componentAnimate() {
      this.expandIndex == this.configExpandIndex ? this.show() : this.hide()
  }

  show() {
    animateTo({ duration: 300, curve: Curve.Linear }, () => {
      this.listHeight = 95
      this.buttonHeight = 40
      this.blankHeight = "100%"
      this.itemHeight = 35
    })
  }

  hide() {
    this.item.isClick = false
    /*如果没有选中保存，则清空*/
    animateTo({ duration: 300, curve: Curve.Linear }, () => {
      this.listHeight = 0
      this.buttonHeight = 0
      this.itemHeight = 0
      this.blankHeight = "0%"
    })
  }

  build() {
    Column() {
      if (this.listHeight > 0) {
        Grid() {
          ForEach(this.data, (item, index) => {
            GridItem() {
              Text(item.title)
                .fontColor(this.selectedIndex == index ? this.selTextColor : this.textColor)
                .fontSize(this.selectedIndex == index ? this.selFontSize : this.fontSize)
                .backgroundColor(this.selectedIndex == index ? "#ffe9e8" : "#f4f4f4")
                .height(this.itemHeight)
                .constraintSize({ minWidth: 85 })
                .textAlign(TextAlign.Center)
                .border({
                  width: .5,
                  color: this.selectedIndex == index ? this.selTextColor : Color.Transparent,
                  radius: 5
                })
                .onClick((event) => {
                  this.selectedIndex = index
                })
            };
          })
        }
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
            this.selectedIndex = -1
          })

        Text("确定")
          .backgroundColor($r("app.color.color_FFFF2928"))
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .flexGrow(1)
          .margin({ right: 15, left: 5 })
          .height(this.buttonHeight)
          .borderRadius(5)
          .onClick(() => {
            this.item.isSelected = true
            this.item.clickCallBack(this.item)
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
        .opacity(0.3)
        .onClick(() => {
          this.expandIndex = -1
        })
    }
  }
}
