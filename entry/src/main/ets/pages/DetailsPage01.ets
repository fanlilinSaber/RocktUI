/**
 * Author:fanlilin
 * Date:2024/1/15
 * Descrobe:
 */

import router from '@ohos.router';
import LoadingDemo from '../demo/LoadingDemo'

interface DemoParams{
  title?: string
  value?: string
}


@Builder
export function DetailsPage01Builder(param: Object) {
  NavDestination() {
    DetailsPage01({ param: param })
  }.hideTitleBar(true)
}

@Entry
@Component
struct DetailsPage01 {
  param?: Object
  @State title: string = "";
  @State value: string = "";

  aboutToAppear(){
    let params = (this.param || {}) as DemoParams
    if(params.title){
      this.title = params.title
      this.value = params.value ?? ""
    }
  }

  build() {
    Column() {
      this.buildNavbar()
      this.buildPageFrame()
    }
    .width('100%')
    .height('100%')
  }

  // 页面主内容
  @Builder buildPageFrame() {
    if (this.value == 'LoadingDemo') {
      LoadingDemo()
        .layoutWeight(1)
    }
  }

  // 自定义导航栏
  @Builder buildNavbar() {
    Column() {
      Row() {
        Text("<返回")
          .height('100%')
          .width('60')
          .fontSize(20)
          .onClick(() => {
            router.back()
            // this.pageStack.pop()
          })

        Text(this.title)
          .height('100%')
          .fontSize(25)
          .textAlign(TextAlign.Center)
          .layoutWeight(1)
          .padding({
            right: 30
          })
      }.height('100%')
    }.height('64')
    .shadow({
      radius: 10,
      color: Color.Gray,
      offsetX: 0,
      offsetY: -1
    })
  }
}