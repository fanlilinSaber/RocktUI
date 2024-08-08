/**
 * Author:fanlilin
 * Date:2024/8/8
 * Descrobe:
 */

@Component
export default struct GoodsListPage {
  tabsController?: TabsController
  tabsIndex: number = 0

  randomColor = Math.floor(Math.random()*16777215).toString(16);

  build() {
    Column() {
      Text(`${this.tabsIndex}`)
        .fontSize(50)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(RandomRGBColor())
  }


}

function RandomRGBColor() {
  let r = Math.floor(Math.random() * 256)
  let g = Math.floor(Math.random() * 256)
  let b = Math.floor(Math.random() * 256)
  return `rgb(${r},${g},${b})`
}