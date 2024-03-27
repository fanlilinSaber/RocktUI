import display from '@ohos.display'
import { MatchPattern } from '@ohos.UiTest'
import { GoodsFilterBoxComponentAreaSelectedModel } from '../Model/GoodsFilterBoxComponentAreaSelectedModel'
import { GoodsFilterBoxComponentConfig } from '../Model/GoodsFilterBoxComponentConfig'
import { GoodsFilterBoxComponentSub } from './GoodsFilterBoxComponentSub'

export enum GoodsFilterBoxComponentButtonType {
  /*正常形态*/
  normal,
  /*右侧有个箭头按钮*/
  rightButton
}


/*
 * @description TODO 这个组件用来显示筛选功能3
 * @author 罗林轩
 * @date 2023/12/07 10:44
 **/
@Component
export struct GoodsFilterBoxComponent {
  /*数据源*/
  @Link dataArr: GoodsFilterBoxComponentConfig[]
  /*展开的下标*/
  @Link expandIndex: number

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
            ForEach(this.dataArr, (item: GoodsFilterBoxComponentConfig, index) => {
              GoodsFilterBoxComponentSub({ item: item }).onClick((event) => {
                /*获取点击模块,用画布作动画用*/
                this.clickEvent = event
                this.scrollXOffset = Number(Math.ceil(this.scroll.currentOffset().xOffset))

                if (this.expandIndex != -1 && this.expandIndex != index) {
                  /*如果当前点击的不是已经展开的按钮，则收起刚才展开的按钮*/
                  this.dataArr[this.expandIndex].isClick = false
                  this.expandIndex = -1
                  if (item.type == GoodsFilterBoxComponentButtonType.rightButton) {
                    return
                  }
                }

                if (item.type == GoodsFilterBoxComponentButtonType.normal) {
                  /*一般样式*/
                  item.isSelected = !item.isSelected
                } else {
                  /*带右侧按钮点击*/
                  item.isClick = !item.isClick
                  if (item.isClick == true) {
                    this.expandIndex = index
                  } else {
                    this.expandIndex = -1
                  }
                }
                /*处理互斥的按钮，同一个id的按钮，为互斥的*/
                if (item.mutableId != null) {
                  for (let index = 0; index < this.dataArr.length; index++) {
                    let config: GoodsFilterBoxComponentConfig = this.dataArr[index]
                    if (config.mutableId != null && config.mutableId == item.mutableId && index != this.dataArr.indexOf(item) && this.expandIndex == -1) {
                      config.isSelected = false
                      config.isClick = false
                      config.selectedAreaContent = new GoodsFilterBoxComponentAreaSelectedModel()
                    }
                  }
                }

                if (item.canExpand == false){
                  item.clickCallBack(item)
                }
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
          for (let index = 0; index < this.dataArr.length; index++) {
            const config: GoodsFilterBoxComponentConfig = this.dataArr[index]
            if (config.isClick == true) {
              config.isClick = false
              this.expandIndex = -1
            }
          }
        })
        /*展开模式绘制一个背景*/
        // 在canvas中调用CanvasRenderingContext2D对象。
        if (this.expandIndex > -1) {
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
              console.debug(JSON.stringify(this.scroll.currentOffset()))
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
      }.backgroundColor(Color.White)
    }.width("100%")
  }
}


