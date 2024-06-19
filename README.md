# RocketUI

## 简介
鸿蒙快速开发UI组件库，适用于内部项目UI样式快速调用组装。目前还在不断完善中，希望多多参与。

## 注意
此库是静态库har，被动态库依赖会被打进包里，被多个动态库依赖会造成重复依赖。

## 下载安装

1.通过npm安装源代码，安装在根目录（存放目录：./node_modules/rocket-ui/RocketUI）
``` 
 https:
 npm install 'git+https://codehub.devcloud.cn-east-3.huaweicloud.com/HarmonyOS00001/RocketUI.git#release'
 ssh:
 npm install 'git+ssh://git@codehub.devcloud.cn-east-3.huaweicloud.com:HarmonyOS00001/RocketUI.git#release'
 ```
2.在工程级下build-profile.json5文件下配置手动新增module
```
 "modules": [
    {
      "name": "rocketUI",
      "srcPath": "./node_modules/rocket-ui/rocketUI"
    }
  ]
```
3.然后在依赖的module或entry下通过ohpm依赖本地包，oh-package.json5中如下配置
```
 "dependencies": {
    "@zjos/rocketUI": 'file:../node_modules/rocket-ui/rocketUI'
  },
```
4.更新版本 终端根目录执行：
```
 npm update rocket-ui
```

## 使用说明

1.在相应的类中引入组件：
```
import import { RKTPage, RKTNavBar, RKTProgressUtil } from '@zjos/rocketUI'
```

2.使用RKTPage

在有@Entry装饰的组件使用如下：
```
build() {
    Column() {
      RKTPage({ title: this.title, titleColor: Color.Black, 
      onReady: () => {
      // 第一次进入页面就showLoading，在这里时机最合适
      RKTProgressUtil.showLoading()
    } }) {
        // 业务UI代码
        ...
      }
    }
    .width('100%')
    .height('100%')
  }
}
```
在只有@Component装饰的组件使用如下：
```
build() {
    RKTPage({ title: this.title, appearanceMode: RKTNavBarAppearanceMode.WhiteMode, 
    onReady: () => {
      // 第一次进入页面就showLoading，在这里时机最合适
      RKTProgressUtil.showLoading()
    } }) {
        // 业务UI代码
        ...
      }
  }
}
```
3.使用RKTProgress
```
1.配合RKTPage使用
显示loding
RKTProgressUtil.showLoading()
隐藏loading
RKTProgressUtil.hideLoading()

2.单独使用
结合arkUI语法，用条件语句控制是否加载
if(this.isloding) {
   RKTProgress()
}
```