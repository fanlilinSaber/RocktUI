import display from '@ohos.display'
import { RKTFilterBoxComponentConfig } from '../model/RKTFilterBoxComponentConfig'
import {
  RKTFilterBoxComponentButtonType,
  RKTFilterBoxViewModel
} from '../viewModel/RKTFilterBoxViewModel'
import { RKTFilterBoxSubComponent } from './RKTFilterBoxSubComponent'

/*
 * @description TODO 这个组件用来显示筛选功能3
 * @author 罗林轩
 * @date 2023/12/07 10:44
 **/
@Component
export struct RKTFilterBoxComponent {
  @Consume RKTFilterBoxViewModel: RKTFilterBoxViewModel
  /*私有属性*/
  //滑动控制器
  scroll: Scroller = new Scroller()
  //滑动控制器的x轴偏移量
  scrollXOffset: number
  //用来配置CanvasRenderingContext2D对象的参数，包括是否开启抗锯齿，true表明开启抗锯齿。
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  //用来创建CanvasRenderingContext2D对象，通过在canvas中调用CanvasRenderingContext2D对象来绘制。
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  //点击的响应对象
  private clickEvent?: ClickEvent

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Scroll(this.scroll) {
          Row({ space: 10 }) {
            ForEach(this.RKTFilterBoxViewModel.dataArr, (item: RKTFilterBoxComponentConfig, index) => {
              RKTFilterBoxSubComponent({ index: index })
                .onClick((event) => {
                  this.RKTFilterBoxViewModel.clickGoodsFilterBoxComponentConfig = item
                  /*获取点击模块,用画布作动画用*/
                  this.clickEvent = event
                  /*获取偏移值*/
                  this.scrollXOffset = Number(Math.ceil(this.scroll.currentOffset().xOffset))
                  if (item.canExpand == true) {
                    /*点击展开的按钮，获取之前已经展开的按钮*/
                    let originSelectedItemIndex: number = this.RKTFilterBoxViewModel.dataArr
                      .findIndex
                      ((item, originIndex) => {
                        return item.isClick == true && index != originIndex
                      })
                    if (originSelectedItemIndex != -1) {
                      /*获取到了，将这个按钮关闭*/
                      this.RKTFilterBoxViewModel.dataArr[originSelectedItemIndex].isClick = false
                      this.RKTFilterBoxViewModel.dataArr = this.RKTFilterBoxViewModel.dataArr.slice()
                    }
                    /*当前的按钮状态改变*/
                    // item.isSelected = !item.isSelected
                    item.isClick = !item.isClick
                  } else {
                    /*一般样式*/
                    item.isSelected = !item.isSelected
                    /*处理互斥的按钮，同一个id的按钮，为互斥的*/
                    if (item
                      .mutableId !== null && item.mutableId !== undefined) {
                      /*点击的按钮是有互斥的，获取所有同样mutableId的按钮*/
                      let originArr = this.RKTFilterBoxViewModel.dataArr.filter(originItem => {
                        return originItem.mutableId !== null && item !== originItem && item
                          .mutableId !== undefined && originItem.canExpand == false && originItem
                          .mutableId == item.mutableId
                      })
                      /*遍历所有相同mutableId的按钮，并且修改状态*/
                      originArr.forEach(i => {
                        i.isClick = false
                        i.isSelected = false
                      })
                    }
                    /*每次点击一般样式的按钮，就要关闭所有的展开状态*/
                    this.RKTFilterBoxViewModel.dataArr.filter(expandItem => {
                      return expandItem.canExpand == true
                    }).forEach(item => {
                      item.isClick = false
                    })
                  }

                  /*触发model里面的回调*/
                  this.RKTFilterBoxViewModel.dataArr[index].clickCallBack(this.RKTFilterBoxViewModel.dataArr[index])
                  this.RKTFilterBoxViewModel.dataArr = this.RKTFilterBoxViewModel.dataArr.slice()

                })
            })
          }
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width("100%")
        .margin({ left: 5, right: 5, top: 5, bottom: 5 })
        .backgroundColor(Color.White)
        .align(Alignment.Start)
        .onScroll(() => {
          this.RKTFilterBoxViewModel.dataArr.forEach(item => {
            item.isClick = false
          })
          this.RKTFilterBoxViewModel.dataArr = this.RKTFilterBoxViewModel.dataArr.slice()
        })

        /*展开模式绘制一个背景*/
        // 在canvas中调用CanvasRenderingContext2D对象。
        if (this.RKTFilterBoxViewModel.dataArr.findIndex(item => {
          return item.isClick == true && item.canExpand == true
        }) != -1) {
          Canvas(this.context)
            .enabled(false)
            .width('100%')
            .height(40)
            .backgroundColor(Color.Transparent)
            .onReady(() => {
              //可以在这里绘制内容。
              this.context.lineWidth = 1
              this.context.beginPath()
              console.debug(JSON.stringify(this.clickEvent))
              /*y轴偏移*/
              let yOffset = 5
              /*x轴偏移*/
              let xOffset = 5
              /*长度*/
              let width = Math.ceil(Number(this.clickEvent.target.area.width))
              /*高度*/
              let height = Math.ceil(Number(this.clickEvent.target.area.height))
              /*点击空间的 x 坐标*/
              let x = Number(this.clickEvent.target.area.globalPosition.x) - this.scrollXOffset
              let r = 12
              this.context.strokeStyle = "#ededed"
              this.context.moveTo(0, height + yOffset)
              this.context.lineTo(x + xOffset, height + yOffset)
              this.context.lineTo(x + xOffset, yOffset + r)
              //左上圆弧 入参是左边框和圆弧的切点（矩形的左上）和顶部边框与圆弧的切点
              this.context.arcTo(x + xOffset, yOffset, x + xOffset + r, yOffset, r)
              this.context.lineTo(width + x + xOffset - r, yOffset)
              //右上圆弧 入参是右边框边框和圆弧的切点（矩形的又上）和右侧边框与圆弧的切点
              this.context.arcTo(width + xOffset + x, yOffset, width + xOffset + x, yOffset + r, r)
              this.context.lineTo(width + xOffset + x, height + yOffset)
              this.context.lineTo(display.getDefaultDisplaySync()
                .width, height + yOffset)
              this.context.stroke()
            })
        }
      }
      .backgroundColor(Color.White)
    }.width("100%")
  }
}


