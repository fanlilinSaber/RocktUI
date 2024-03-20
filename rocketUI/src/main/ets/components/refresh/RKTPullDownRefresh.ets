import { touchMoveLoadMore, touchUpLoadMore } from './RKTPullUpLoadMore';
import { RKTRefreshConstant, RefreshState } from './RKTRefreshConstant';
import { RKTRefreshObserved } from './RKTRefreshObserved';


export function listTouchEvent(mObserved: RKTRefreshObserved, event: TouchEvent): Promise<RKTRefreshObserved> {
  switch (event.type) {
    case TouchType.Down:
      mObserved.downY = event.touches[0].y;
      mObserved.lastMoveY = event.touches[0].y;
      break;
    case TouchType.Move:
      if ((mObserved.isRefreshing === true) || (mObserved.isLoading === true)) {
        return;
      }
      let isDownPull = event.touches[0].y - mObserved.lastMoveY > 0;
      if (((isDownPull === true) || (mObserved.isPullRefreshOperation === true)) && (mObserved.isCanLoadMore === false)) {
        // Finger movement, processing pull-down refresh.
        touchMovePullRefresh(mObserved, event);
      } else {
        // Finger movement, processing load more.
        touchMoveLoadMore(mObserved, event);
      }
      mObserved.lastMoveY = event.touches[0].y;
      break;
    case TouchType.Cancel:
      break;
    case TouchType.Up:
      if ((mObserved.isRefreshing === true) || (mObserved.isLoading === true)) {
        return;
      }
      if ((mObserved.isPullRefreshOperation === true)) {
        // Lift your finger and pull down to refresh.
        return touchUpPullRefresh(mObserved);
      } else {
        // Fingers up, handle loading more.
        return touchUpLoadMore(mObserved);
      }
      break;
    default:
      break;
  }
}

export function touchMovePullRefresh(mObserved: RKTRefreshObserved, event: TouchEvent) {
  if (mObserved.startIndex === 0) {
    mObserved.isPullRefreshOperation = true;
    let height = vp2px(mObserved.pullDownRefreshHeight);
    mObserved.offsetY = event.touches[0].y - mObserved.downY;
    // The sliding offset is greater than the pull-down refresh layout height, and the refresh condition is met.
    if (mObserved.offsetY >= height) {
      pullRefreshState(mObserved, RefreshState.Release);
      mObserved.offsetY = height + mObserved.offsetY * RKTRefreshConstant.Y_OFF_SET_COEFFICIENT;
    } else {
      pullRefreshState(mObserved, RefreshState.DropDown);
    }
    if (mObserved.offsetY < 0) {
      mObserved.offsetY = 0;
      mObserved.isPullRefreshOperation = false;
    }
  }
}

export function touchUpPullRefresh(mObserved: RKTRefreshObserved): Promise<RKTRefreshObserved> {
  return new Promise(async (resolve: Function, reject: Function) => {
    if (mObserved.isCanRefresh === true) {
      mObserved.offsetY = vp2px(mObserved.pullDownRefreshHeight);
      pullRefreshState(mObserved, RefreshState.Refreshing);
      mObserved.currentPage = 1;
      setTimeout(() => {
        resolve(mObserved)
      }, RKTRefreshConstant.DELAY_TIME);
    } else {
      closeRefresh(mObserved, false);
    }
  })
}

export function pullRefreshState(mObserved: RKTRefreshObserved, state: number) {
  switch (state) {
    case RefreshState.DropDown:
      mObserved.pullDownRefreshText = '下拉刷新';
      mObserved.pullDownRefreshImage = $r("app.media.rkt_ic_pull_down_refresh");
      mObserved.isCanRefresh = false;
      mObserved.isRefreshing = false;
      mObserved.isVisiblePullDown = true;
      break;
    case RefreshState.Release:
      mObserved.pullDownRefreshText = '松开刷新';
      mObserved.pullDownRefreshImage = $r("app.media.rkt_ic_pull_up_refresh");
      mObserved.isCanRefresh = true;
      mObserved.isRefreshing = false;
      break;
    case RefreshState.Refreshing:
      mObserved.offsetY = vp2px(mObserved.pullDownRefreshHeight);
      mObserved.pullDownRefreshText = '正在刷新';
      mObserved.pullDownRefreshImage = $r("app.media.rkt_ic_pull_up_load");
      mObserved.isCanRefresh = true;
      mObserved.isRefreshing = true;
      break;
    case RefreshState.Success:
      mObserved.pullDownRefreshText = '刷新成功';
      mObserved.pullDownRefreshImage = $r("app.media.rkt_ic_succeed_refresh");
      mObserved.isCanRefresh = true;
      mObserved.isRefreshing = true;
      break;
    case RefreshState.Fail:
      mObserved.pullDownRefreshText = '刷新失败';
      mObserved.pullDownRefreshImage = $r("app.media.rkt_ic_fail_refresh");
      mObserved.isCanRefresh = true;
      mObserved.isRefreshing = true;
      break;
    default:
      break;
  }
}

export function closeRefresh(mObserved: RKTRefreshObserved, isRefreshSuccess: boolean) {
  let self = mObserved;
  setTimeout(() => {
    let delay = RKTRefreshConstant.RefreshConstant_DELAY_PULL_DOWN_REFRESH;
    if (self.isCanRefresh === true) {
      pullRefreshState(mObserved, isRefreshSuccess ? RefreshState.Success : RefreshState.Fail);
      delay = RKTRefreshConstant.RefreshConstant_DELAY_SHRINK_ANIMATION_TIME;
    }
    animateTo({
      duration: RKTRefreshConstant.RefreshConstant_CLOSE_PULL_DOWN_REFRESH_TIME,
      delay: delay,
      onFinish: () => {
        pullRefreshState(mObserved, RefreshState.DropDown);
        self.isVisiblePullDown = false;
        self.isPullRefreshOperation = false;
      }
    }, () => {
      self.offsetY = 0;
    })
  }, self.isCanRefresh ? RKTRefreshConstant.DELAY_ANIMATION_DURATION : 0);
}