import {
  RKTFilterAllItemComponent,
  RKTFilterBoxComponent,
  RKTFilterBoxComponentConfig,
  RKTFilterExpandComponentConfig,
  RKTFilterExpandViewModel
} from '@zjos/rocketUI'
import {
  RKTFilterBoxComponentButtonType,
  RKTFilterBoxViewModel
} from '@zjos/rocketUI/src/main/ets/components/filterBox/viewModel/RKTFilterBoxViewModel'

@Entry
@Component
export struct DetailsPage03 {
  /*外部引用RKTFilterBoxViewModel，并且@Provide装饰器修饰*/
  @Provide @Watch("change") filterBoxViewModel: RKTFilterBoxViewModel = new RKTFilterBoxViewModel()
  /*外部引用RKTFilterExpandViewModel，并且@Provide装饰器修饰*/
  @Provide filterExpandViewModel: RKTFilterExpandViewModel = new RKTFilterExpandViewModel()
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
    if (this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig != undefined) {
      if (this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig.index == 5 && this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig.isClick == true) {
        this.filterExpandViewModel.isSingle = false
        this.filterExpandViewModel.dataArr = this.item1
      } else {
        this.filterExpandViewModel.isSingle = true
        this.filterExpandViewModel.dataArr = this.item2
      }
    }
  }

  aboutToAppear() {
    this.configFilterBox()
    this.configExpand()
  }

  /*配置条件筛选点击的下拉*/
  configExpand() {
    this.filterExpandViewModel.makeSureCallBack = (sel) => {
      console.debug("选择内容" + JSON.stringify(sel))
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
      text: "单选下拉",
      index: 4,
      type: RKTFilterBoxComponentButtonType.rightButton,
      canExpand: true,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let otherButton1: RKTFilterBoxComponentConfig = new RKTFilterBoxComponentConfig({
      text: "多选下拉",
      index: 5,
      type: RKTFilterBoxComponentButtonType.rightButton,
      canExpand: true,
      clickCallBack: (item) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    //初始化
    this.filterBoxViewModel.dataArr = [moreOne, moreTwo, two, three, otherButton, otherButton1]
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