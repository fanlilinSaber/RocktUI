import {
  AreaData,
  RUFilterAllItemComponent,
  RUFilterAreaComponent,
  RUFilterBoxComponent,
  RUFilterBoxComponentConfig,
  RUFilterExpandComponentConfig,
  RUFilterExpandViewModel
} from '@zjos/rocketUI'
import {
  RUFilterBoxComponentButtonType,
  RUFilterBoxViewModel
} from '@zjos/rocketUI/src/main/ets/components/filterBox/viewModel/RUFilterBoxViewModel'
import {
  RUFilterExpandComponentType
} from '@zjos/rocketUI/src/main/ets/components/filterBox/viewModel/RUFilterExpandViewModel'

@Builder
export function DetailsPage03Builder(param: Object) {
  NavDestination() {
    DetailsPage03()
  }.hideTitleBar(true)
}

@Entry
@Component
export struct DetailsPage03 {
  /*外部引用RUFilterBoxViewModel，并且@Provide装饰器修饰*/
  @Provide @Watch("change") filterBoxViewModel: RUFilterBoxViewModel = new RUFilterBoxViewModel()
  /*外部引用RUFilterExpandViewModel，并且@Provide装饰器修饰*/
  @Provide filterExpandViewModel: RUFilterExpandViewModel = new RUFilterExpandViewModel()
  item1 = [new RUFilterExpandComponentConfig({
    text: "选项1",
    id: "1"
  }), new RUFilterExpandComponentConfig({
    text: "选项2",
    id: "2"
  }), new RUFilterExpandComponentConfig({
    text: "选项3",
    id: "3"
  }), new RUFilterExpandComponentConfig({
    text: "选项4",
    id: "4"
  }), new RUFilterExpandComponentConfig({
    text: "选项5",
    id: "5"
  }), new RUFilterExpandComponentConfig({
    text: "选项6",
    id: "6"
  })]
  item2 = [new RUFilterExpandComponentConfig({
    text: "a选项1",
    id: "1"
  }), new RUFilterExpandComponentConfig({
    text: "a选项2",
    id: "2"
  }), new RUFilterExpandComponentConfig({
    text: "a选项3",
    id: "3"
  }), new RUFilterExpandComponentConfig({
    text: "a选项4",
    id: "4"
  }), new RUFilterExpandComponentConfig({
    text: "a选项5",
    id: "5"
  }), new RUFilterExpandComponentConfig({
    text: "a选项6",
    id: "6"
  })]
  item3: RUFilterExpandComponentConfig[][] = this.getAreaData()

  /*获取区域数据*/
  getAreaData(): RUFilterExpandComponentConfig[][] {
    let data = AreaData.getData()
    /*添加省数据*/
    let provinceArr : RUFilterExpandComponentConfig[] = []
    let cityArr : RUFilterExpandComponentConfig[]= []
    let areaArr : RUFilterExpandComponentConfig[]= []

    data.forEach(province => {
      let provinceConfig = new RUFilterExpandComponentConfig({
        text: province.name,
        id: province.id.toString()
      })
      provinceArr.push(provinceConfig)
      province.children?.forEach(city => {
        let cityConfig = new RUFilterExpandComponentConfig({
          text: city.name,
          id: city.id.toString()
        })
        cityArr.push(cityConfig)
        city.children?.forEach(area => {
          let areaConfig = new RUFilterExpandComponentConfig({
            text: area.name,
            id: area.id.toString()
          })
          areaArr.push(areaConfig)
        })
      })
    })
    return [provinceArr, cityArr, areaArr]
  }

  /*改变展开项*/
  change() {
    if (this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig != undefined) {
      if (this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig.index == 4) {
        this.filterExpandViewModel.isSingle = false
        this.filterExpandViewModel.dataArr = this.item1
        this.filterExpandViewModel.type = RUFilterExpandComponentType.other
      } else if (this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig.index == 5) {
        this.filterExpandViewModel.isSingle = true
        this.filterExpandViewModel.dataArr = this.item2
        this.filterExpandViewModel.type = RUFilterExpandComponentType.other
      } else if (this.filterBoxViewModel.clickGoodsFilterBoxComponentConfig.index == 6) {
        this.filterExpandViewModel.isSingle = true
        this.filterExpandViewModel.dataArr = this.item3
        this.filterExpandViewModel.type = RUFilterExpandComponentType.area
      }
    }
  }

  /*生命周期刚显示界面*/
  aboutToAppear() {
    this.configFilterBox()
    this.configExpand()
  }

  /*配置条件筛选点击的下拉菜单的选择毁掉*/
  configExpand() {
    this.filterExpandViewModel.makeSureCallBack = (sel : RUFilterExpandComponentConfig[] | RUFilterExpandComponentConfig[]) => {
      console.debug("选择内容" + JSON.stringify(sel))
    }
  }

  /*配置条件筛选*/
  configFilterBox() {
    let moreOne: RUFilterBoxComponentConfig = new RUFilterBoxComponentConfig({
      text: "多选1",
      index: 0,
      type: RUFilterBoxComponentButtonType.normal,
      clickCallBack: (item : RUFilterBoxComponentConfig) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })
    let moreTwo: RUFilterBoxComponentConfig = new RUFilterBoxComponentConfig({
      text: "多选2",
      index: 1,
      type: RUFilterBoxComponentButtonType.normal,
      clickCallBack: (item : RUFilterBoxComponentConfig) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let two: RUFilterBoxComponentConfig = new RUFilterBoxComponentConfig({
      text: "互斥1",
      index: 2,
      mutableId: "1",
      type: RUFilterBoxComponentButtonType.normal,
      clickCallBack: (item : RUFilterBoxComponentConfig) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let three: RUFilterBoxComponentConfig = new RUFilterBoxComponentConfig({
      text: "互斥2",
      index: 3,
      mutableId: "1",
      type: RUFilterBoxComponentButtonType.normal,
      clickCallBack: (item : RUFilterBoxComponentConfig) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let otherButton: RUFilterBoxComponentConfig = new RUFilterBoxComponentConfig({
      text: "单选下拉",
      index: 4,
      type: RUFilterBoxComponentButtonType.rightButton,
      canExpand: true,
      clickCallBack: (item : RUFilterBoxComponentConfig) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let otherButton1: RUFilterBoxComponentConfig = new RUFilterBoxComponentConfig({
      text: "多选下拉",
      index: 5,
      type: RUFilterBoxComponentButtonType.rightButton,
      canExpand: true,
      clickCallBack: (item : RUFilterBoxComponentConfig) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    let areaSelected: RUFilterBoxComponentConfig = new RUFilterBoxComponentConfig({
      text: "选择区域",
      index: 6,
      type: RUFilterBoxComponentButtonType.rightButton,
      canExpand: true,
      clickCallBack: (item : RUFilterBoxComponentConfig) => {
        /*点击回调*/
        console.debug(JSON.stringify(item))
      }
    })

    //初始化
    this.filterBoxViewModel.dataArr = [moreOne, moreTwo, two, three, otherButton, otherButton1, areaSelected]
  }

  build() {
    Navigation() {
      Column() {
        Row() {
          RUFilterBoxComponent()
        }

        /*所有可能会显示的下拉框都在这儿*/
        RUFilterAreaComponent()
        RUFilterAllItemComponent()
      }
    }
    .navBarWidth("100%")
    .backButtonIcon($r("app.media.btn_more"))
    .titleMode(NavigationTitleMode.Mini)
    .title("筛选组件")
    .width("100%")
  }
}