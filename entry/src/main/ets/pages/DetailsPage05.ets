/**
 * Author:fanlilin
 * Date:2024/7/4
 * Descrobe:
 */

import { RUPage, RUProgressUtil } from '@zjos/rocketUI'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { DemoParams } from './DemoParams'

@Builder
export function DetailsPage05Builder(param: Object) {
  DetailsPage05({ param: param })
}

@Component
struct DetailsPage05 {
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
    RUPage({ title: this.title, titleColor: Color.White, customTitle: wrapBuilder(MyCustomTitle),
      onReady:() => {
        hilog.info(0x00503, `DetailsPage04`, "页面onReady")
        RUProgressUtil.showLoading()
        setTimeout(()=>{
          RUProgressUtil.hideLoading()
        }, 1000)
      },
      onShown:() => {
        hilog.info(0x00503, `DetailsPage04`, "页面onShown" + this.title)
      },
      onHidden:() => {
        hilog.info(0x00503, `DetailsPage04`, "页面onHidden")
      }
    })
    {
      Text("测试测试测试2")
        .backgroundColor(Color.Yellow)
        .fontSize(25)
        .height(46)
    }
  }
}

@Builder
function MyCustomTitle() {
  Text("测试自定义title")
    .backgroundColor(Color.Yellow)
    .fontSize(25)
    .height(46)
}