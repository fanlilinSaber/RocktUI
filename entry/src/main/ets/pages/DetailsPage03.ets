import { RKTFilterAllItemComponent, RKTFilterBoxComponent } from '@zjos/rocketUI'
import {
  RKTFilterBoxComponentConfig
} from '@zjos/rocketUI/src/main/ets/components/goodsFilterBox/model/RKTFilterBoxComponentConfig'
import {
  RKTFilterExpandComponentConfig
} from '@zjos/rocketUI/src/main/ets/components/goodsFilterBox/model/RKTFilterExpandComponentConfig'
import {
  RKTFilterBoxComponentButtonType,
  RKTFilterBoxViewModel
} from '@zjos/rocketUI/src/main/ets/components/goodsFilterBox/viewModel/RKTFilterBoxViewModel'
import {
  RKTFilterExpandViewModel
} from '@zjos/rocketUI/src/main/ets/components/goodsFilterBox/viewModel/RKTFilterExpandViewModel'

@Entry
@Component
export struct DetailsPage03 {
  /*外部引用GoodsFilterBoxViewModel，并且@Provide装饰器修饰*/
  @Provide @Watch("change") RKTFilterBoxViewModel: RKTFilterBoxViewModel = new RKTFilterBoxViewModel()
  @Provide RKTFilterExpandViewModel: RKTFilterExpandViewModel = new RKTFilterExpandViewModel({
    isSingle: false
  })
  item1 = [new RKTFilterExpandComponentConfig({
    text: "选项1",
    id: "1"
  }), new RKTFilterExpandComponentConfig({
    text: "选项2",
    id: "2"
  }), new RKTFilterExpandComponentConfig({
    text: "选项3",
    id: "3"
  }), new RKTFilterExpandComponentConfig({
    text: "选项4",
    id: "4"
  }), new RKTFilterExpandComponentConfig({
    text: "选项5",
    id: "5"
  }), new RKTFilterExpandComponentConfig({
    text: "选项6",
    id: "6"
  })]
  item2 = [new RKTFilterExpandComponentConfig({
    text: "a选项1",
    id: "1"
  }), new RKTFilterExpandComponentConfig({
    text: "a选项2",
    id: "2"
  }), new RKTFilterExpandComponentConfig({
    text: "a选项3",
    id: "3"
  }), new RKTFilterExpandComponentConfig({
    text: "a选项4",
    id: "4"
  }), new RKTFilterExpandComponentConfig({
    text: "a选项5",
    id: "5"
  }), new RKTFilterExpandComponentConfig({
    text: "a选项6",
    id: "6"
  })]

  change() {
    if (this.RKTFilterBoxViewModel.clickGoodsFilterBoxComponentConfig != undefined) {
      if (this.RKTFilterBoxViewModel.clickGoodsFilterBoxComponentConfig.index == 5 && this.RKTFilterBoxViewModel.clickGoodsFilterBoxComponentConfig.isClick == true) {
        this.RKTFilterExpandViewModel.dataArr = this.item1
      } else {
        this.RKTFilterExpandViewModel.dataArr = this.item2
      }
    }
  }

  aboutToAppear() {
    this.configFilterBox()
    this.configExpand()
  }

  /*配置条件筛选点击的下拉*/
  configExpand() {
    this.RKTFilterExpandViewModel.makeSureCallBack = (sel) => {
      
    }
  }

  /*配置条件筛选*/
  configFilterBox() {
    let moreOne: RKTFilterBoxComponentConfig = new RKTFilterBoxComponentConfig({
      text: "多选1",
      index: 0,
      type: RKTFilterBoxComponentButtonType.normal,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })
    let moreTwo: RKTFilterBoxComponentConfig = new RKTFilterBoxComponentConfig({
      text: "多选2",
      index: 1,
      type: RKTFilterBoxComponentButtonType.normal,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let two: RKTFilterBoxComponentConfig = new RKTFilterBoxComponentConfig({
      text: "互斥1",
      index: 2,
      mutableId: "1",
      type: RKTFilterBoxComponentButtonType.normal,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })
    let three: RKTFilterBoxComponentConfig = new RKTFilterBoxComponentConfig({
      text: "互斥2",
      index: 3,
      mutableId: "1",
      type: RKTFilterBoxComponentButtonType.normal,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let otherButton: RKTFilterBoxComponentConfig = new RKTFilterBoxComponentConfig({
      text: "状态2",
      index: 4,
      type: RKTFilterBoxComponentButtonType.rightButton,
      canExpand: true,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let otherButton1: RKTFilterBoxComponentConfig = new RKTFilterBoxComponentConfig({
      text: "状态2",
      index: 5,
      type: RKTFilterBoxComponentButtonType.rightButton,
      canExpand: true,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    //初始化
    this.RKTFilterBoxViewModel.dataArr = [moreOne, moreTwo, two, three, otherButton, otherButton1]
  }

  build() {
    Navigation() {
      Column() {
        Row() {
          RKTFilterBoxComponent()
        }

        RKTFilterAllItemComponent()
      }
    }
    .navBarWidth("100%")
    .backButtonIcon($r("app.media.btn_more"))
    .titleMode(NavigationTitleMode.Mini)
    .title("筛选组件")
    .width("100%")
  }
}