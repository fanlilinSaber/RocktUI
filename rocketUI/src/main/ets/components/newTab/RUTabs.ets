/**
 * Author:fanlilin
 * Date:2024/7/29
 * Descrobe:
 */

export class RUTabsController {

  /**
   * 滚到到指定的索引
   *
   * @param value - Index to jump to.
   */
  changeIndex: (value: number) => void = () => {}

  /** 内部的 */
  onChange:(index: number) => void = () => {}
  onAnimationStart: (index: number, targetIndex: number, event: TabsAnimationEvent) => void = () => {}
  onAnimationEnd: (index: number, event: TabsAnimationEvent) => void = () => {}
  onGestureSwipe: (index: number, event: TabsAnimationEvent) => void = () => {}
  onAreaChange: (oldValue: Area,newValue: Area) => void = () => {}
}

@Component
export default struct RUTabs {
  index?: number = 0
  controller?: RUTabsController
  xheight?: Length = '100%'
  xwidth?: Length = '100%'

  private xcontroller: TabsController = new TabsController()

  @Builder closerBuilder () {}
  @BuilderParam content: () => void = this.closerBuilder

  aboutToAppear(): void {
    if (this.controller) {
      this.controller.changeIndex = (value: number) => {
        this.xcontroller.changeIndex(value)
      }
    }
  }

  build() {
    Tabs({ index: this.index, controller: this.xcontroller }) {
      this.content()
    }
    .barWidth(0)
    .barHeight(0)
    .height(this.xheight)
    .width(this.xwidth)
    .onChange((index: number) => {
      this.controller?.onChange(index)
    })
    .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
      this.controller?.onAnimationStart(index, targetIndex, event)
    })
    .onAnimationEnd((index: number, event: TabsAnimationEvent) => {
      this.controller?.onAnimationEnd(index, event)
    })
    .onGestureSwipe((index: number, event: TabsAnimationEvent) => {
      this.controller?.onGestureSwipe(index, event)
    })
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.controller?.onAreaChange(oldValue, newValue)
    })
    .id('Tabs001')
  }
}