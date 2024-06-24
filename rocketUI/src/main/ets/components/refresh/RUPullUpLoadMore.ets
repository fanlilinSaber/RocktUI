import { RURefreshConstant } from './RURefreshConstant';
import { RURefreshObserved } from './RURefreshObserved';

export function touchMoveLoadMore(mObserved: RURefreshObserved, event: TouchEvent) {
  if (mObserved.endIndex === mObserved.currentPageDataLength - 1 || mObserved.endIndex === mObserved.currentPageDataLength) {
    mObserved.offsetY = event.touches[0].y - mObserved.downY;
    if (Math.abs(mObserved.offsetY) > vp2px(mObserved.pullUpLoadHeight) / 2) {
      mObserved.isCanLoadMore = true;
      mObserved.isVisiblePullUpLoad = true;
      mObserved.offsetY = -vp2px(mObserved.pullUpLoadHeight) + mObserved.offsetY * RURefreshConstant.Y_OFF_SET_COEFFICIENT;
    }
  }
}

export function touchUpLoadMore(mObserved: RURefreshObserved): Promise<RURefreshObserved> {
  return new Promise(async (resolve: Function, reject: Function) => {
    let self: RURefreshObserved = mObserved;
    animateTo({
      duration: RURefreshConstant.ANIMATION_DURATION,
    }, () => {
      self.offsetY = 0;
    })

    let isCanLoadMore = self.isCanLoadMore === true
    let hasMore = self.hasMore === true
    if ((isCanLoadMore) && (hasMore)) {
      self.isLoading = true;
      setTimeout(() => {
        resolve(mObserved)
      }, RURefreshConstant.DELAY_TIME);
    } else {
      closeLoadMore(self);
    }
  })
}


export function closeLoadMore(mObserved: RURefreshObserved) {
  mObserved.isCanLoadMore = false;
  mObserved.isLoading = false;
  mObserved.isVisiblePullUpLoad = false;
}