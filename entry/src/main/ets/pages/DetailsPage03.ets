import { GoodsFilterBoxComponent } from '@zjos/rocketUI'
import {
  GoodsFilterBoxComponentConfig
} from '@zjos/rocketUI/src/main/ets/components/goodsFilterBox/model/GoodsFilterBoxComponentConfig'
import {
  GoodsFilterBoxComponentButtonType,
  GoodsFilterBoxViewModel
} from '@zjos/rocketUI/src/main/ets/components/goodsFilterBox/viewModel/GoodsFilterBoxViewModel'

@Entry
@Component
export struct DetailsPage03 {
  /*外部引用GoodsFilterBoxViewModel，并且@Provide装饰器修饰*/
  @Provide goodsFilterBoxViewModel: GoodsFilterBoxViewModel = new GoodsFilterBoxViewModel()

  aboutToAppear() {
    let moreOne: GoodsFilterBoxComponentConfig = new GoodsFilterBoxComponentConfig({
      text: "多选1",
      index: 0,
      type: GoodsFilterBoxComponentButtonType.normal,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })
    let moreTwo: GoodsFilterBoxComponentConfig = new GoodsFilterBoxComponentConfig({
      text: "多选2",
      index: 0,
      type: GoodsFilterBoxComponentButtonType.normal,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let two: GoodsFilterBoxComponentConfig = new GoodsFilterBoxComponentConfig({
      text: "互斥1",
      index: 0,
      mutableId: "1",
      type: GoodsFilterBoxComponentButtonType.normal,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })
    let three: GoodsFilterBoxComponentConfig = new GoodsFilterBoxComponentConfig({
      text: "互斥2",
      index: 0,
      mutableId: "1",
      type: GoodsFilterBoxComponentButtonType.normal,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let otherButton: GoodsFilterBoxComponentConfig = new GoodsFilterBoxComponentConfig({
      text: "状态2",
      index: 0,
      type: GoodsFilterBoxComponentButtonType.rightButton,
      canExpand: true,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

  //初始化
  this.goodsFilterBoxViewModel.dataArr = [moreOne,moreTwo, two, three, otherButton]
}

build() {
  Navigation(){
    Row() {
      GoodsFilterBoxComponent()
    }
  }
  .navBarWidth("100%")
  .backButtonIcon($r("app.media.btn_more"))
  .titleMode(NavigationTitleMode.Mini)
  .title("筛选组件")
  .width("100%")

}
}