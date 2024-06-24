import {
  RUProgressUtil,
  RURefreshActionEvent,
  RURefreshComponent,
  RURefreshEnum,
  RURefreshItemContent,
  RURefreshObserved
} from '@zjos/rocketUI'
import promptAction from '@ohos.promptAction'

@Component
export default struct RURefreshDemo {
  @State mLiveData: ListItemEntity[] = []
  //控制事件（例如点击、刷新等）
  @Watch("onActionChange") @State mActionEvent: RURefreshActionEvent = new RURefreshActionEvent()

  build() {
    Column() {
      RURefreshComponent({
        currentPage: 1,
        pageSize: 10,
        extendData: "",
        mLiveData: $mLiveData,
        mActionEvent: $mActionEvent,
        listItemContent: this.listItemContent,
        onRefreshOrLoadMore: (mObserved: RURefreshObserved, isAboutToAppear: boolean) => {
          if (isAboutToAppear || mObserved.pageState == RURefreshEnum.NetErr) {
            RUProgressUtil.showLoading()
          }
          this.getListData(mObserved)
        }
      })
    }.backgroundColor("#FFFFFFFF").zIndex(-1)
  }

  @Builder listItemContent($$: RURefreshItemContent) {
    ListItemComponent({ entity: $$.item as ListItemEntity}).onClick(() => {
      this.mActionEvent = new RURefreshActionEvent({
        action: RURefreshEnum.ClickEvent,
        id: ($$.item as ListItemEntity).name
      })
    })
  }

  onActionChange() {
    if (this.mActionEvent.action === RURefreshEnum.ClickEvent) {
      promptAction.showToast({ message: this.mActionEvent.id })
    }
  }

  getListData(mObserved: RURefreshObserved) {
    let mLiveData: ListItemEntity[] = []
    for (let i = 1; i < (mObserved.currentPage > 2 ? 6 : 11); i++) {
      let item = new ListItemEntity()
      item.name = "第" + mObserved.currentPage + "页-第" + i + "条数据"
      mLiveData.push(item)
    }
    if (mLiveData.length === mObserved.pageSize) {
      mObserved.hasMore = true;
      mObserved.currentPage++;
    } else {
      mObserved.hasMore = false;
    }
    if (mObserved.isRefreshing) {
      this.mLiveData = mLiveData
    } else {
      this.mLiveData = this.mLiveData.concat(mLiveData)
    }
    RUProgressUtil.hideLoading()
  }
}


@Component
export struct ListItemComponent {
  entity?: ListItemEntity

  build() {
    Column() {
      Text(this.entity?.name).width("100%").height(100)
      Shape().width("100%").height(1).backgroundColor("#FFEDEDED")
    }.padding({ left: 15, right: 15 })
  }
}

class ListItemEntity{
  name?: string
}
