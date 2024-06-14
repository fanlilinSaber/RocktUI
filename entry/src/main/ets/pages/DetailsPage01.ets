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
export function DetailsPage01Builder(): void {
  NavDestination() {
    DetailsPage01()
  }
}

@Entry
@Component
struct DetailsPage01 {

  @State title: string = "";
  @State value: string = "";

  pageStack: NavPathStack = new NavPathStack()

  aboutToAppear(){
    let params = (router.getParams()||{}) as DemoParams
    if(params.title){
      this.title = params.title;
      this.value = params.value??"";
    }
  }

  build() {
    Column() {
      this.buildNavbar()
      this.buildPageFrame()
      // Navigation() {
      //
      // }
      // .title('测试标题')
      // .hideNavBar(false)
    }
    .width('100%')
    .height('100%')
  }

  // build() {
  //   Navigation(this.pageStack) {
  //     Column() {
  //     }
  //     .width('100%')
  //     .height('100%')
  //   }
  //   .title(this.buildNavbar)
  //   .backButtonIcon($r('app.media.ru_navbar_back'))
  //   .mode(NavigationMode.Stack)
  // }

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