import { closeRefresh, listTouchEvent } from './RKTPullDownRefresh';
import { closeLoadMore } from './RKTPullUpLoadMore';
import { RKTRefreshConstant } from './RKTRefreshConstant';
import { RKTRefreshObserved } from './RKTRefreshObserved';

/**
 * 重新封装的下拉刷新上拉加载更多组件
 * @author 盛杰
 * @time 2024.01.18
 */
@Component
export struct RKTRefreshComponent {
  enableRefresh: boolean = true
  currentPage: number
  pageSize: number
  //如果有其它的数据，可以用这个字段传递
  extendData: any
  //隐藏“没有更多数据了”
  isHideNoMoreData: boolean = false
  @State mObserved: RKTRefreshObserved = new RKTRefreshObserved();
  //监听列表的数据
  @Watch("onLiveDataChange") @Link mLiveData: any[]
  //监听用户的交互操作
  @Watch("onActionChange") @Link mActionEvent: RKTRefreshActionEvent

  //注意：这种方式添加的@Builder listItemContent(){}内部的this是指向此RKTRefreshComponent的
  @BuilderParam listItemContent: ($$: {
    mLiveData: any[],
    item: any,
    index: number,
    extendData: any
  }) => void
  onRefreshOrLoadMore: Function = (mObserved: RKTRefreshObserved, isAboutToAppear: boolean) => {
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
        case RKTRefreshEnum.Refresh:
        case RKTRefreshEnum.ReLoad:
          this.mObserved.currentPage = this.currentPage??1
          this.mObserved.isRefreshing = true
          this.onRefreshOrLoadMore(this.mObserved, false)
          break;
      }
    }
  }

  build() {
    if (this.mActionEvent != null && this.mActionEvent.action === RKTRefreshEnum.NetErr) {
      Column() {
        Image($r('app.media.rkt_ic_net_err'))
          .height(187)
          .width(144)
          .margin({ top: 100 })
        Text("网络连接失败")
          .fontSize(16)
          .fontColor($r('app.color.color_FF333333'))
          .margin({ top: 15 })
        Text("请检查您的网络设置或重新加载")
          .fontSize(14)
          .fontColor($r('app.color.color_FF969696'))
          .margin({ top: 10, bottom: 50 })
      }.onClick(() => {
        this.onRefreshOrLoadMore(this.mObserved, false)
      })
    } else {

      Column() {
        List() {
          ListItem() {
            RKTRefreshLayout({
              mObserved: new RKTRefreshObserved(this.mObserved.isVisiblePullDown, this.mObserved.pullDownRefreshImage,
                this.mObserved.pullDownRefreshText, this.mObserved.pullDownRefreshHeight)
            })
          }

          ForEach(this.mLiveData, (item, index) => {
            ListItem() {
              this.listItemContent({ mLiveData: this.mLiveData, item: item, index: index, extendData: this.extendData })
            }
          })

          ListItem() {
            if (this.mObserved.hasMore) {
              RKTLoadMoreLayout({
                mObserved: new RKTRefreshObserved(this.mObserved.isVisiblePullUpLoad, this.mObserved.pullUpLoadImage,
                  this.mObserved.pullUpLoadText, this.mObserved.pullUpLoadHeight)
              })
            } else {
              if (this.isHideNoMoreData) {
                Shape().width("100%").height(70)
              } else {
                RKTNoMoreLayout()
              }
            }
          }
        }
        .width("100%")
        .height("100%")
        .edgeEffect(EdgeEffect.None)
        .offset({ x: 0, y: `${this.mObserved.offsetY}${RKTRefreshConstant.LIST_OFFSET_UNIT}` })
        .onScrollIndex((start: number, end: number) => {
          this.mObserved.startIndex = start;
          this.mObserved.endIndex = end;
        })

      }
      .width(RKTRefreshConstant.FULL_WIDTH)
      .height(RKTRefreshConstant.FULL_HEIGHT)
      .justifyContent(FlexAlign.Center)
      .onTouch((event: TouchEvent | undefined) => {
        if (event && this.enableRefresh) {
          const promise = listTouchEvent(this.mObserved, event)
          if (promise != null) {
            promise.then((model: RKTRefreshObserved) => {
              this.onRefreshOrLoadMore(model, false)
            })
          }
        }
      })
    }
  }
}

/**
 * 组件间通信
 */
export class RKTRefreshActionEvent {
  constructor(t?: RKTRefreshActionEventElement) {
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

  build(action?: RKTRefreshEnum, id?: string, entity?: any, index?: number, content?: any, tag?: any, other?: any) {
    this.action = action
    this.id = id
    this.entity = entity
    this.index = index
    this.content = content
    this.tag = tag
    this.other = other
    return this
  }

  action: RKTRefreshEnum
  id: string
  entity: any
  index: number
  content: any
  tag: any
  other: any
}


export declare type RKTRefreshActionEventElement = {
  action?: RKTRefreshEnum
  id?: string
  entity?: any
  index?: number
  content?: any
  tag?: any
  other?: any
}

export const enum RKTRefreshEnum {
  Default, //默认
  ClickEvent, //点击事件
  Refresh, //刷新
  ReLoad, //重新加载
  NetErr //网络错误
}


@Component
export struct RKTLoadingLayout {
  @ObjectLink mObserved: RKTRefreshObserved

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
export struct RKTRefreshLayout {
  @ObjectLink mObserved: RKTRefreshObserved

  build() {
    Column() {
      if (this.mObserved.isVisible) {
        RKTLoadingLayout({ mObserved: new RKTRefreshObserved
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
export struct RKTLoadMoreLayout {
  @ObjectLink mObserved: RKTRefreshObserved

  build() {
    Column() {
      if (this.mObserved.isVisible) {
        RKTLoadingLayout({
          mObserved: new RKTRefreshObserved(this.mObserved.isVisible,
            this.mObserved.imageSrc, this.mObserved.textValue, this.mObserved.heightValue)
        })
      } else {
        RKTLoadingLayout({
          mObserved: new RKTRefreshObserved(this.mObserved.isVisible,
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
export struct RKTNoMoreLayout {
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
