import { GoodsAllItemComponent, GoodsFilterBoxComponent } from '@zjos/rocketUI'
import {
  GoodsFilterBoxComponentConfig
} from '@zjos/rocketUI/src/main/ets/components/goodsFilterBox/model/GoodsFilterBoxComponentConfig'
import {
  GoodsFilterExpandComponentConfig
} from '@zjos/rocketUI/src/main/ets/components/goodsFilterBox/model/GoodsFilterExpandComponentConfig'
import {
  GoodsFilterBoxComponentButtonType,
  GoodsFilterBoxViewModel
} from '@zjos/rocketUI/src/main/ets/components/goodsFilterBox/viewModel/GoodsFilterBoxViewModel'
import {
  GoodsFilterExpandViewModel
} from '@zjos/rocketUI/src/main/ets/components/goodsFilterBox/viewModel/GoodsFilterExpandViewModel'

@Entry
@Component
export struct DetailsPage03 {
  /*外部引用GoodsFilterBoxViewModel，并且@Provide装饰器修饰*/
  @Provide @Watch("change") goodsFilterBoxViewModel: GoodsFilterBoxViewModel = new GoodsFilterBoxViewModel()
  @Provide goodsFilterExpandViewModel: GoodsFilterExpandViewModel = new GoodsFilterExpandViewModel({
    isSingle: false
  })
  item1 = [new GoodsFilterExpandComponentConfig({
    text: "选项1",
    id: "1"
  }), new GoodsFilterExpandComponentConfig({
    text: "选项2",
    id: "2"
  }), new GoodsFilterExpandComponentConfig({
    text: "选项3",
    id: "3"
  }), new GoodsFilterExpandComponentConfig({
    text: "选项4",
    id: "4"
  }), new GoodsFilterExpandComponentConfig({
    text: "选项5",
    id: "5"
  }), new GoodsFilterExpandComponentConfig({
    text: "选项6",
    id: "6"
  })]
  item2 = [new GoodsFilterExpandComponentConfig({
    text: "a选项1",
    id: "1"
  }), new GoodsFilterExpandComponentConfig({
    text: "a选项2",
    id: "2"
  }), new GoodsFilterExpandComponentConfig({
    text: "a选项3",
    id: "3"
  }), new GoodsFilterExpandComponentConfig({
    text: "a选项4",
    id: "4"
  }), new GoodsFilterExpandComponentConfig({
    text: "a选项5",
    id: "5"
  }), new GoodsFilterExpandComponentConfig({
    text: "a选项6",
    id: "6"
  })]

  change() {
    if (this.goodsFilterBoxViewModel.clickGoodsFilterBoxComponentConfig != undefined) {
      if (this.goodsFilterBoxViewModel.clickGoodsFilterBoxComponentConfig.index == 5 && this.goodsFilterBoxViewModel.clickGoodsFilterBoxComponentConfig.isClick == true) {
        this.goodsFilterExpandViewModel.dataArr = this.item1
      } else {
        this.goodsFilterExpandViewModel.dataArr = this.item2
      }
    }
  }

  aboutToAppear() {
    this.configFilterBox()
    this.configExpand()
  }

  /*配置条件筛选点击的下拉*/
  configExpand() {
    this.goodsFilterExpandViewModel.makeSureCallBack = (sel) => {
      
    }
  }

  /*配置条件筛选*/
  configFilterBox() {
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
      index: 1,
      type: GoodsFilterBoxComponentButtonType.normal,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let two: GoodsFilterBoxComponentConfig = new GoodsFilterBoxComponentConfig({
      text: "互斥1",
      index: 2,
      mutableId: "1",
      type: GoodsFilterBoxComponentButtonType.normal,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })
    let three: GoodsFilterBoxComponentConfig = new GoodsFilterBoxComponentConfig({
      text: "互斥2",
      index: 3,
      mutableId: "1",
      type: GoodsFilterBoxComponentButtonType.normal,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let otherButton: GoodsFilterBoxComponentConfig = new GoodsFilterBoxComponentConfig({
      text: "状态2",
      index: 4,
      type: GoodsFilterBoxComponentButtonType.rightButton,
      canExpand: true,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let otherButton1: GoodsFilterBoxComponentConfig = new GoodsFilterBoxComponentConfig({
      text: "状态2",
      index: 5,
      type: GoodsFilterBoxComponentButtonType.rightButton,
      canExpand: true,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    //初始化
    this.goodsFilterBoxViewModel.dataArr = [moreOne, moreTwo, two, three, otherButton, otherButton1]
  }

  build() {
    Navigation() {
      Column() {
        Row() {
          GoodsFilterBoxComponent()
        }

        GoodsAllItemComponent()
      }
    }
    .navBarWidth("100%")
    .backButtonIcon($r("app.media.btn_more"))
    .titleMode(NavigationTitleMode.Mini)
    .title("筛选组件")
    .width("100%")
  }
}