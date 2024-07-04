/**
 * Author:fanlilin
 * Date:2024/1/22
 * Descrobe:
 */

import router from '@ohos.router';
import { RUPage, RUNavBar, RUProgressUtil, RUEventBus } from '@zjos/rocketUI'
import RULoadingDemo from '../demo/RULoadingDemo'
import RUNavBarDemo from '../demo/RUNavBarDemo';
import promptAction from '@ohos.promptAction'
import RUItemInputTextDemo from '../demo/RUItemInputTextDemo';
import RURefreshDemo from '../demo/RURefreshDemo';
import { RUPopupDemo } from '../demo/RUPopupDemo';
import RUDialogDemo from '../demo/RUDialogDemo';
import { RUSelectPicturesDemo } from '../demo/RUSelectPicturesDemo';
import { RUToastDemo } from '../demo/RUToastDemo'
import { RUTabDemo } from "../demo/RUTabDemo"
import { hilog } from '@kit.PerformanceAnalysisKit';
import { RUFilterDemo } from '../demo/RUFilterDemo';
import { DemoParams } from './DemoParams';


@Builder
export function DetailsPage02Builder(param: Object) {
  DetailsPage02({ param: param })
}

// @Entry({ routeName: "pages/DetailsPage02" })
@Component
struct DetailsPage02 {
  @LocalStorageLink("pageStack") pageStack: NavPathStack = new NavPathStack()
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
    RUPage({ title: this.title, titleColor: Color.White,
      onReady:() => {
        hilog.info(0x00503, `DetailsPage02`, "页面onReady")
        RUProgressUtil.showLoading()
        setTimeout(()=>{
          RUProgressUtil.hideLoading()
        }, 1000)
      },
      onShown:() => {
        hilog.info(0x00503, `DetailsPage02`, "页面onShown" + this.title)
      },
      onHidden:() => {
        hilog.info(0x00503, `DetailsPage02`, "页面onHidden")
      }
      })
    {
      if (this.value == 'RULoadingDemo') {
        RULoadingDemo()
      } else if (this.value == 'RUNavBarDemo') {
        RUNavBarDemo()
      } else if (this.value == 'RUItemInputTextDemo') {
        RUItemInputTextDemo()
      } else if (this.value == 'RURefreshDemo') {
        RURefreshDemo()
      } else if (this.value == 'RUPopupDemo') {
        RUPopupDemo()
      } else if (this.value == 'RUDialogDemo') {
        RUDialogDemo()
      } else if (this.value == 'RUSelectPicturesDemo') {
        RUSelectPicturesDemo()
      } else if (this.value == 'RUToastDemo') {
        RUToastDemo()
      } else if (this.value == 'RUFilterDemo') {
        RUFilterDemo()
      } else if (this.value == 'RUTabDemo') {
        RUTabDemo()
      }
    }
  }

  // build() {
  //   Column() {
  //     RUPage({ title: this.title, titleColor: Color.White }) {
  //       if (this.value == 'RULoadingDemo') {
  //         RULoadingDemo()
  //       } else if (this.value == 'RUNavBarDemo') {
  //         RUNavBarDemo()
  //       } else if (this.value == 'RUItemInputTextDemo') {
  //         RUItemInputTextDemo()
  //       } else if (this.value == 'RURefreshDemo') {
  //         RURefreshDemo()
  //       } else if (this.value == 'RUPopupDemo') {
  //         RUPopupDemo()
  //       } else if (this.value == 'RUDialogDemo') {
  //         RUDialogDemo()
  //       } else if (this.value == 'RUSelectPicturesDemo') {
  //         RUSelectPicturesDemo()
  //       } else if (this.value == 'RUToastDemo') {
  //         RUToastDemo()
  //       }
  //     }
  //
  //     // RUPage({title: this.title, navBar: false }) {
  //     //   RUNavBar({title: `` })
  //     //
  //     //   Text()
  //     // }
  //   }
  //   .width('100%')
  //   .height('100%')
  // }
}
