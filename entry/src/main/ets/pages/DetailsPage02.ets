/**
 * Author:fanlilin
 * Date:2024/1/22
 * Descrobe:
 */

import router from '@ohos.router';
import { RKTPage, RKTNavBar } from '@zjos/rocketUI'
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

@Entry
@Component
struct DetailsPage02 {
  @State title: string = "";
  value: string = "";

  aboutToAppear() {
    let params = (router.getParams() || {}) as DemoParams
    if (params.title) {
      this.title = params.title;
      this.value = params.value??"";
    }
  }

  build() {
    Column() {
      RKTPage({ title: this.title, titleColor: Color.White }) {
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

      // RKTPage({title: this.title, navBar: false }) {
      //   RKTNavBar({title: `` })
      //
      //   Text()
      // }
    }
    .width('100%')
    .height('100%')
  }
}