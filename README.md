# RocketUI

## 简介
鸿蒙快速开发UI组件库，适用于内部项目UI样式快速调用组装。目前还在不断完善中，希望多多参与。

## 下载安装

```
 1.通过npm安装源代码（示列存放目录：entry/node_modules/RocketUI/rocket-ui）
 npm install git+https://codehub.devcloud.cn-east-3.huaweicloud.com/HarmonyOS00001/RocketUI.git

 2.然后通过ohpm安装本地文件夹
 "dependencies": {
    "@zjos/rocketUI": 'file:../entry/node_modules/RocketUI/rocket-ui'
  },
```

## 使用说明

1.在相应的类中引入组件：

```
import lottie from '@zjos/rocketUI'
```

2.使用RKTPage
```
build() {
    Column() {
      RKTPage({ title: this.title, titleColor: Color.Black }) {

      }
    }
    .width('100%')
    .height('100%')
  }
}
```