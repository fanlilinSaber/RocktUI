import { RKTRefreshConstant } from './RKTRefreshConstant';
import { RKTRefreshObserved } from './RKTRefreshObserved';

export function touchMoveLoadMore(mObserved: RKTRefreshObserved, event: TouchEvent) {
  if (mObserved.endIndex === mObserved.currentPageDataLength - 1 || mObserved.endIndex === mObserved.currentPageDataLength) {
    mObserved.offsetY = event.touches[0].y - mObserved.downY;
    if (Math.abs(mObserved.offsetY) > vp2px(mObserved.pullUpLoadHeight) / 2) {
      mObserved.isCanLoadMore = true;
      mObserved.isVisiblePullUpLoad = true;
      mObserved.offsetY = -vp2px(mObserved.pullUpLoadHeight) + mObserved.offsetY * RKTRefreshConstant.Y_OFF_SET_COEFFICIENT;
    }
  }
}

export function touchUpLoadMore(mObserved: RKTRefreshObserved): Promise<RKTRefreshObserved> {
  return new Promise(async (resolve: Function, reject: Function) => {
    let self: RKTRefreshObserved = mObserved;
    animateTo({
      duration: RKTRefreshConstant.ANIMATION_DURATION,
    }, () => {
      self.offsetY = 0;
    })

    let isCanLoadMore = self.isCanLoadMore === true
    let hasMore = self.hasMore === true
    if ((isCanLoadMore) && (hasMore)) {
      self.isLoading = true;
      setTimeout(() => {
        resolve(mObserved)
      }, RKTRefreshConstant.DELAY_TIME);
    } else {
      closeLoadMore(self);
    }
  })
}


export function closeLoadMore(mObserved: RKTRefreshObserved) {
  mObserved.isCanLoadMore = false;
  mObserved.isLoading = false;
  mObserved.isVisiblePullUpLoad = false;
}