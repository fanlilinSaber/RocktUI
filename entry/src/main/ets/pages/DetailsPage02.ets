/**
 * Author:fanlilin
 * Date:2024/1/22
 * Descrobe:
 */

import router from '@ohos.router';
import { RKTPage, RKTNavBar, RKTProgressUtil } from '@zjos/rocketUI'
import RKTLoadingDemo from '../demo/RKTLoadingDemo'
import RKTNavBarDemo from '../demo/RKTNavBarDemo';
import promptAction from '@ohos.promptAction'
import RKTItemInputTextDemo from '../demo/RKTItemInputTextDemo';
import RKTRefreshDemo from '../demo/RKTRefreshDemo';
import { RKTPopupDemo } from '../demo/RKTPopupDemo';
import RKTDialogDemo from '../demo/RKTDialogDemo';
import { RKTSelectPicturesDemo } from '../demo/RKTSelectPicturesDemo';
import RKTToastDemo from '../demo/RKTToastDemo'

interface DemoParams{
  title?: string
  value?: string
}

@Builder
export function DetailsPage02Builder(param: Object, pageStack: NavPathStack) {
  DetailsPage02({ param: param, pageStack: pageStack })
}

// @Entry
@Component
struct DetailsPage02 {
  pageStack?: NavPathStack
  param?: Object
  @State title: string = "";
  value: string = "";

  aboutToAppear() {
    let params = (this.param || {}) as DemoParams
    if (params.title) {
      this.title = params.title
      this.value = params.value ?? ""
    }
  }

  build() {
    RKTPage({ navPathStack: this.pageStack, title: this.title, titleColor: Color.White, backFillColor: Color.Yellow,
      onReady: () => {
      // RKTProgressUtil.showLoading()
    } }) {
      if (this.value == 'RKTLoadingDemo') {
        RKTLoadingDemo()
      } else if (this.value == 'RKTNavBarDemo') {
        RKTNavBarDemo()
      } else if (this.value == 'RKTItemInputTextDemo') {
        RKTItemInputTextDemo()
      } else if (this.value == 'RKTRefreshDemo') {
        RKTRefreshDemo()
      } else if (this.value == 'RKTPopupDemo') {
        RKTPopupDemo()
      } else if (this.value == 'RKTDialogDemo') {
        RKTDialogDemo()
      } else if (this.value == 'RKTSelectPicturesDemo') {
        RKTSelectPicturesDemo()
      } else if (this.value == 'RKTToastDemo') {
        RKTToastDemo()
      }
    }
  }

  // build() {
  //   Column() {
  //     RKTPage({ title: this.title, titleColor: Color.White }) {
  //       if (this.value == 'RKTLoadingDemo') {
  //         RKTLoadingDemo()
  //       } else if (this.value == 'RKTNavBarDemo') {
  //         RKTNavBarDemo()
  //       } else if (this.value == 'RKTItemInputTextDemo') {
  //         RKTItemInputTextDemo()
  //       } else if (this.value == 'RKTRefreshDemo') {
  //         RKTRefreshDemo()
  //       } else if (this.value == 'RKTPopupDemo') {
  //         RKTPopupDemo()
  //       } else if (this.value == 'RKTDialogDemo') {
  //         RKTDialogDemo()
  //       } else if (this.value == 'RKTSelectPicturesDemo') {
  //         RKTSelectPicturesDemo()
  //       } else if (this.value == 'RKTToastDemo') {
  //         RKTToastDemo()
  //       }
  //     }
  //
  //     // RKTPage({title: this.title, navBar: false }) {
  //     //   RKTNavBar({title: `` })
  //     //
  //     //   Text()
  //     // }
  //   }
  //   .width('100%')
  //   .height('100%')
  // }
}