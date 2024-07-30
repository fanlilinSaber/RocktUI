import { closeRefresh, listTouchEvent } from './RUPullDownRefresh';
import { closeLoadMore } from './RUPullUpLoadMore';
import { RURefreshConstant } from './RURefreshConstant';
import { RURefreshObserved } from './RURefreshObserved';

/**
 * 重新封装的下拉刷新上拉加载更多组件
 * @author 盛杰
 * @time 2024.01.18
 */
@Component
export struct RURefreshComponent {
  enableRefresh: boolean = true
  currentPage: number = 0
  pageSize: number = 10
  //如果有其它的数据，可以用这个字段传递
  extendData: object | string | number | boolean | null | undefined
  //隐藏“没有更多数据了”
  isHideNoMoreData: boolean = false
  @State mObserved: RURefreshObserved = new RURefreshObserved();
  //监听列表的数据
  @Watch("onLiveDataChange") @Link mLiveData: object[]
  //监听用户的交互操作
  @Watch("onActionChange") @Link mActionEvent: RURefreshActionEvent

  //注意：这种方式添加的@Builder listItemContent(){}内部的this是指向此RURefreshComponent的
  @BuilderParam listItemContent: ($$: RURefreshItemContent) => void

  onRefreshOrLoadMore: Function = (mObserved: RURefreshObserved, isAboutToAppear: boolean) => {
  }

  aboutToAppear() {
    if (this.currentPage) {
      this.mObserved.currentPage = this.currentPage
    }
    if (this.pageSize) {
      this.mObserved.pageSize = this.pageSize
    }
    this.onRefreshOrLoadMore(this.mObserved, true)
  }

  /**
   * 列表的数据发生改变（增删）
   */
  onLiveDataChange() {
    if (this.mObserved.isRefreshing) {
      closeRefresh(this.mObserved, true)
    } else {
      closeLoadMore(this.mObserved)
    }
    this.mObserved.currentPageDataLength = this.mLiveData.length
  }

  /**
   * 用户进行了交互操作
   */
  onActionChange() {
    if (this.mActionEvent != null) {
      switch (this.mActionEvent.action) {
        case RURefreshEnum.Refresh:
        case RURefreshEnum.ReLoad:
          this.mObserved.currentPage = this.currentPage??1
          this.mObserved.isRefreshing = true
          this.onRefreshOrLoadMore(this.mObserved, false)
          break;
      }
    }
  }

  build() {
    if (this.mActionEvent != null && this.mActionEvent.action === RURefreshEnum.NetErr) {
      Column() {
        Image($r("app.media.ru_ic_net_err"))
          .height(187)
          .width(144)
          .margin({ top: 116 })
        Text("网络连接失败")
          .fontSize(16)
          .fontColor($r("app.color.ru_color_FF333333"))
          .margin({ top: 15 })
        Text("请检查您的网络设置或重新加载")
          .fontSize(14)
          .fontColor($r("app.color.ru_color_FF969696"))
          .margin({ top: 10, bottom: 50 })
      }.onClick(() => {
        this.onRefreshOrLoadMore(this.mObserved, false)
      })
    } else {

      Column() {
        List() {
          ListItem() {
            RURefreshLayout({
              mObserved: new RURefreshObserved(this.mObserved.isVisiblePullDown, this.mObserved.pullDownRefreshImage,
                this.mObserved.pullDownRefreshText, this.mObserved.pullDownRefreshHeight)
            })
          }

          ForEach(this.mLiveData, (item : object, index) => {
            ListItem() {
              this.listItemContent({ mLiveData: this.mLiveData, item: item, index: index, extendData: this.extendData })
            }
          })

          ListItem() {
            if (this.mObserved.hasMore) {
              RULoadMoreLayout({
                mObserved: new RURefreshObserved(this.mObserved.isVisiblePullUpLoad, this.mObserved.pullUpLoadImage,
                  this.mObserved.pullUpLoadText, this.mObserved.pullUpLoadHeight)
              })
            } else {
              if (this.isHideNoMoreData) {
                Shape().width("100%").height(70)
              } else {
                RUNoMoreLayout()
              }
            }
          }
        }
        .width("100%")
        .height("100%")
        .edgeEffect(EdgeEffect.None)
        .offset({ x: 0, y: `${this.mObserved.offsetY}${RURefreshConstant.LIST_OFFSET_UNIT}` })
        .onScrollIndex((start: number, end: number) => {
          this.mObserved.startIndex = start;
          this.mObserved.endIndex = end;
        })

      }
      .width(RURefreshConstant.FULL_WIDTH)
      .height(RURefreshConstant.FULL_HEIGHT)
      .justifyContent(FlexAlign.Center)
      .onTouch((event: TouchEvent | undefined) => {
        if (event && this.enableRefresh) {
          const promise = listTouchEvent(this.mObserved, event)
          if (promise != null) {
            promise.then((model: RURefreshObserved) => {
              this.onRefreshOrLoadMore(model, false)
            })
          }
        }
      })
    }
  }
}

export class RURefreshItemContent {
  mLiveData: object[] = []
  item: object = new Object()
  index: number = 0
  extendData: object | string | number | boolean | null | undefined
}

/**
 * 组件间通信
 */
export class RURefreshActionEvent {
  constructor(t?: RURefreshActionEventElement) {
    if (t) {
      this.action = t.action
      this.id = t.id
      this.entity = t.entity
      this.index = t.index
      this.content = t.content
      this.tag = t.tag
      this.other = t.other
    }
  }

  build(action?: RURefreshEnum, id?: string, entity?: object | string | number | boolean | null , index?: number, content?: object | string | number | boolean | null , tag?: object | string | number | boolean | null , other?: object | string | number | boolean | null ) {
    this.action = action
    this.id = id
    this.entity = entity
    this.index = index
    this.content = content
    this.tag = tag
    this.other = other
    return this
  }

  action?: RURefreshEnum
  id?: string
  entity?: object | string | number | boolean | null
  index?: number
  content?: object | string | number | boolean | null
  tag?: object | string | number | boolean | null
  other?: object | string | number | boolean | null
}


export interface RURefreshActionEventElement {
  action?: RURefreshEnum
  id?: string
  entity?: object | string | number | boolean | null
  index?: number
  content?: object | string | number | boolean | null
  tag?: object | string | number | boolean | null
  other?: object | string | number | boolean | null

}

export const enum RURefreshEnum {
  Default, //默认
  ClickEvent, //点击事件
  Refresh, //刷新
  ReLoad, //重新加载
  NetErr //网络错误
}


@Component
export struct RULoadingLayout {
  @ObjectLink mObserved: RURefreshObserved

  build() {
    Row() {
      Image(this.mObserved.imageSrc)
        .width(18)
        .height(18)

      Text(this.mObserved.textValue)
        .margin({
          left: 7,
          bottom: 1
        })
        .fontSize(17)
        .textAlign(TextAlign.Center)
    }
    .clip(true)
    .width("100%")
    .justifyContent(FlexAlign.Center)
    .height(this.mObserved.heightValue)
  }
}

/**
 * header样式
 */
@Component
export struct RURefreshLayout {
  @ObjectLink mObserved: RURefreshObserved

  build() {
    Column() {
      if (this.mObserved.isVisible) {
        RULoadingLayout({ mObserved: new RURefreshObserved
        (this.mObserved.isVisible, this.mObserved.imageSrc, this.mObserved.textValue,
          this.mObserved.heightValue) })
      }
    }
  }
}

/**
 * footer加载样式
 */
@Component
export struct RULoadMoreLayout {
  @ObjectLink mObserved: RURefreshObserved

  build() {
    Column() {
      if (this.mObserved.isVisible) {
        RULoadingLayout({
          mObserved: new RURefreshObserved(this.mObserved.isVisible,
            this.mObserved.imageSrc, this.mObserved.textValue, this.mObserved.heightValue)
        })
      } else {
        RULoadingLayout({
          mObserved: new RURefreshObserved(this.mObserved.isVisible,
            this.mObserved.imageSrc, this.mObserved.textValue, 0)
        })
      }
    }
  }
}

/**
 * footer没有更多数据样式
 */
@Component
export struct RUNoMoreLayout {
  build() {
    Row() {
      Text('没有更多数据了')
        .margin({ left: 8 })
        .fontSize(16)
        .textAlign(TextAlign.Center)
    }
    .width("100%")
    .justifyContent(FlexAlign.Center)
    .height(70)
  }
}
