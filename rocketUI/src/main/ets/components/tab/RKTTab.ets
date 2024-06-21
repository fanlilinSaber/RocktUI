export interface RKTTabDataListType{
  name:string
  no:string
  type?:string
  children?:RKTTabDataListType[]
}
export enum RKTTabType{
  UnderlineTab,
  BorderTab,
  LeftLineTab
}
/**
 * tabBar公共组件
 */
@Component
export struct RKTTabComponent {
  /*数据源*/
  @Prop tabDataList:RKTTabDataListType[]
  /*选中下标*/
  @Prop currentIndex:number = 0
  /*间距*/
  @Prop space:number = 10
  /*下划线*/
  @Prop tabType:RKTTabType = RKTTabType.UnderlineTab
  /*下划线宽度-只有TabType.UnderlineTab时生效*/
  @Prop lineWidth:number = 2
  /*背景色*/
  @Prop bgColor:string| Resource | Color = Color.White
  /*字體顔色*/
  @Prop fontColor:string| Resource | Color = $r('app.color.ru_color_FF666666')
  /*选中状态字体顔色*/
  @Prop activeColor:string| Resource | Color = $r('app.color.ru_main_color')
  /*边框*/
  @Prop isShowBorder:Boolean = true
  /*高度*/
  @Prop tabHeight:Length = 36
  /*横纵-默认横向*/
  @Prop place:Axis = Axis.Horizontal
  /*字体大小*/
  @Prop fontSize:number = 14
  private scroller:Scroller = new Scroller()
  /*change事件*/
  private onChangeTab:(index:number) => void = (index:number) => {}
  /*自定义类型tabbar*/
  @BuilderParam customComponent:()=> void
  build() {
    List({space:this.space,initialIndex:this.currentIndex,scroller:this.scroller}){
      ForEach(this.tabDataList,(item:RKTTabDataListType,index:number)=>{
        ListItem(){
          if(this.tabType === RKTTabType.UnderlineTab) {
            LineTab({
              name:item.name,
              isActive: index === this.currentIndex ,
              fontColor: this.fontColor,
              activeColor:this.activeColor,
              fontSize:this.fontSize,
              lineWidth:this.lineWidth
            })
          } else if(this.tabType === RKTTabType.BorderTab) {
            BorderTab({
              name:item.name,
              isActive: index === this.currentIndex ,
              fontColor: this.fontColor,
              activeColor:this.activeColor,
              fontSize:this.fontSize
            })
          } else if(this.tabType === RKTTabType.LeftLineTab) {
            LeftLineTab({
              name:item.name,
              isActive: index === this.currentIndex ,
              fontColor: this.fontColor,
              activeColor:this.activeColor,
              fontSize:this.fontSize
            })
          } else {
            // 自定义类型
            this.customComponent()
          }
        }.onClick(()=>{
          if(this.currentIndex === index) return
          this.currentIndex = index
          this.onChangeTab(index)
        })
      })
    }
    .listDirection(this.place)
    .border({
      style:BorderStyle.Solid,
      width:{bottom:this.isShowBorder ? 1 : 0},
      color:$r('app.color.ru_color_FFEDEDED')
    })
      .width('100%')
      .padding(this.tabType === RKTTabType.LeftLineTab ?{ bottom:30 } : {left:10,right:10,top:3})
      .backgroundColor(this.bgColor)
      .height(this.tabHeight)
      .scrollBar(BarState.Off)
  }
}

/**
 * 下划线类型tabbar
 */
@Component
struct LineTab {
  @Prop name: string
  @Prop isActive:Boolean
  @Prop fontColor:string| Resource | Color
  @Prop activeColor:string| Resource | Color
  @Prop fontSize:number
  @Prop lineWidth:number
  build() {
      Column({ space: 3 }) {
        Text(this.name)
          .fontColor(this.isActive ? this.activeColor : this.fontColor)
          .fontSize(this.fontSize)
          .textAlign(TextAlign.Center)
          .fontWeight(this.isActive ? 500 : 400)
          .constraintSize({ minWidth: '16vp', maxWidth: "320vp" })
        Text() {
          Span(this.name).opacity(1).fontSize(this.fontSize).fontColor(Color.Transparent)
        }
        .border({
          width: { top: this.lineWidth },
          color: this.activeColor,
          style: { top: BorderStyle.Solid }
        })
        .opacity(this.isActive ? 1 : 0)
      }
      .padding({ left: 0, right: 0, top: 5, bottom: 5 })
    }
}

/**
 * 边框类型tabbar
*/
@Component
struct BorderTab{
  @Prop name: string
  @Prop isActive:Boolean
  @Prop fontColor:string| Resource | Color
  @Prop activeColor:string| Resource | Color
  @Prop fontSize:number
  build(){
    Column() {
      Text(this.name)
        .fontColor(this.isActive ? this.activeColor: this.fontColor)
        .fontSize(this.fontSize)
        .textAlign(TextAlign.Center)
        .align(Alignment.Center)
        .height(24)
        .fontWeight(this.isActive ? 500 : 400)
        .width('auto')
        .border({
          width: 1,
          color: this.isActive ? this.activeColor: $r('app.color.ru_color_FFEDEDED'),
          style: { top: BorderStyle.Solid }
        })
        .padding({left:5,right:5})
        .borderRadius(5)
    }
    .padding({top:2}) // 设置这个是为了上下居中
    .height(36)
    .alignItems(HorizontalAlign.Center)
  }
}

/**
 * 左边块类型tabbar
 */
@Component
struct LeftLineTab {
  @Prop name: string
  @Prop isActive:Boolean
  @Prop fontColor:string| Resource | Color
  @Prop activeColor:string| Resource | Color
  @Prop fontSize:number
  @Prop lineWidth:number
  build() {
    Row(){
      Text()
        .height(this.fontSize - 2)
        .width(3)
        .backgroundColor(this.activeColor)
        .margin({right:5})
        .borderRadius(3)
          // None隐藏不参与占位  Hidden隐藏参与占位 Visible正常显示
        .visibility(this.isActive ?  Visibility.Visible : Visibility.Hidden )
      Text(this.name)
        .fontColor(this.isActive ? this.activeColor : this.fontColor)
        .fontSize(this.fontSize)
        .textAlign(TextAlign.Center)
        .fontWeight(this.isActive ? 500 : 400)
        .textOverflow({overflow:TextOverflow.Ellipsis})
        .maxLines(1)
        .width('auto')
    }
    .width('100%')
    .padding({left:5,right:8,top:15,bottom:15})
    .backgroundColor(this.isActive ? $r('app.color.ru_color_FFF5F5F5') :Color.White)
  }
}