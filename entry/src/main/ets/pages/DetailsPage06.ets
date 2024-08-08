/**
 * Author:fanlilin
 * Date:2024/8/8
 * Descrobe:
 */
import { RUNavBar, RUPage, RUTabBarIndicatorDelegate, RUTabBarIndicatorLineType, RUTabBarItem } from '@zjos/rocketUI';
import RUTabBar, { RUTabBarController,
  RUTabBarIndicatorType } from '@zjos/rocketUI/src/main/ets/components/newTab/RUTabBar';
import { RUTabBarIndicatorPosition } from '@zjos/rocketUI/src/main/ets/components/newTab/RUTabBarIndicator';
import { RUTabBarIndicatorLine } from '@zjos/rocketUI/src/main/ets/components/newTab/RUTabBarIndicatorLine';
import RUTabs, { RUTabsController } from '@zjos/rocketUI/src/main/ets/components/newTab/RUTabs';
import { DemoParams } from './DemoParams';
import GoodsListPage from './GoodsListPage';


@Builder
export function DetailsPage06Builder(param: Object) {
  DetailsPage06({ param: param })
}


const TabBarItems: RUTabBarItem[] = [
  new RUTabBarItem({ title: '商品大厅' }),
  new RUTabBarItem({ title: '自营商品'}),
  new RUTabBarItem({ title: '企业专项'}),
  new RUTabBarItem({ title: '集采商品'}),
  new RUTabBarItem({ title: '促销商品'}),
  new RUTabBarItem({ title: '供应商'}),
  new RUTabBarItem({ title: '长标题测试一下'}),
]

@Component
export default struct DetailsPage06 {
  param?: Object
  @State title: string = "";
  value: string = "";

  tabsController: RUTabsController = new RUTabsController()
  tabBarController: RUTabBarController = new RUTabBarController()

  aboutToAppear() {
    let params = (this.param || {}) as DemoParams
    if (params.title) {
      this.title = params.title
      this.value = params.value ?? ""
    }
  }

  build() {
    RUPage({
      navBar: false,
      onReady:() => {} })
    {
      RUNavBar({ customTitle: (): void => { this.customTitle() } })

      RUTabs({ controller: this.tabsController }) {
        ForEach(TabBarItems, (item: RUTabBarItem, index: number) => {
          TabContent() {
            GoodsListPage({ tabsController: this.tabsController, tabsIndex: index })
          }
        })
      }
    }
  }

  @Builder
  customTitle() {
    RUTabBar({ items: TabBarItems, indicatorType: RUTabBarIndicatorType.Custom, indicator: this.customIndicatorLine, tabsController: this.tabsController, tabBarController: this.tabBarController })
  }

  @Builder
  customIndicatorLine(controller: RUTabBarIndicatorDelegate) {
    RUTabBarIndicatorLine({ delegate: controller, options: { width: 20, height: 3, color: '#FFFFFFFF', position: RUTabBarIndicatorPosition.Bottom}, lineType: RUTabBarIndicatorLineType.Lengthen })
  }
}