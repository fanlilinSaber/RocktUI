/*选择区域的配置信息*/
export class GoodsFilterBoxComponentAreaSelectedModel {
  /*省名称选择*/
  provinceNameSelected: string = ""
  /*省编码选择*/
  provinceCodeSelected: string = ""
  /*选择城市名*/
  cityNameSelected: string = ""
  /*选择城市编码*/
  cityCodeSelected: string = ""
  /*选择区域名称数组*/
  areaNameSelected: string[] = []
  /*选择区域编码数组*/
  areaCodeSelected: string[] = []

  constructor(
    provinceNameSelected: string = "",
    provinceCodeSelected: string = "",
    cityNameSelected: string = "",
    cityCodeSelected: string = "",
    areaNameSelected: string[] = [],
    areaCodeSelected: string[] = []
  ) {
    this.provinceNameSelected = provinceNameSelected
    this.provinceCodeSelected = provinceCodeSelected
    this.cityNameSelected = cityNameSelected
    this.cityCodeSelected = cityCodeSelected
    this.areaNameSelected = areaNameSelected
    this.areaCodeSelected = areaCodeSelected
  }
}