import { RKTRefreshConstant, PageState } from './RKTRefreshConstant';

@Observed
export class RKTRefreshObserved {
  currentPage: number = 1
  pageSize: number = RKTRefreshConstant.PAGE_SIZE
  pullDownRefreshText: string = '下拉刷新'
  pullDownRefreshImage: Resource = $r("app.media.rkt_ic_pull_down_refresh")
  pullDownRefreshHeight: number = RKTRefreshConstant.CUSTOM_LAYOUT_HEIGHT
  isVisiblePullDown: boolean = false
  pullUpLoadText: string = '加载中...'
  pullUpLoadImage: Resource = $r("app.media.rkt_ic_pull_up_load")
  pullUpLoadHeight: number = 70
  isVisiblePullUpLoad: boolean = false
  offsetY: number = 0
  pageState: number = PageState.Loading
  hasMore: boolean = true
  startIndex = 0
  endIndex = 0
  downY = 0
  lastMoveY = 0
  isRefreshing: boolean = false
  isCanRefresh = false
  isPullRefreshOperation = false
  isLoading: boolean = false
  isCanLoadMore: boolean = false
  //
  currentPageDataLength: number = 0
  onCallRefresh:Function = () => {}
  //
  isVisible?: boolean = false
  imageSrc?: Resource = $r("app.media.rkt_ic_pull_up_load")
  textValue?: string = ""
  heightValue?: number = 0

  constructor(isVisible ?: boolean, imageSrc?: Resource, textValue?: string, heightValue?: number) {
    this.isVisible = isVisible
    this.imageSrc = imageSrc
    this.textValue = textValue
    this.heightValue = heightValue
  }
}