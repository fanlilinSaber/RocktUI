import measure from '@ohos.measure'

/**
 * 常用工具方法
 */
export default class RKTCommonUtils {

  /**
   * 如果数组不为空，返回第0条数据，反之则返回null。
   * @param array
   * @returns
   */
  static getZeroItem(arr: Array<any>) {
    if (this.isNotEmptyArray(arr)) {
      return arr[0]
    } else {
      return null
    }
  }

  /**
   * 判断数组是否为空数据
   * @param array
   * @returns true 是空数组
   */
  static isEmptyArray(arr: Array<any>): boolean {
    return arr == undefined || arr == null || arr.length == 0 || !Array.isArray(arr)
  }

  /**
   * 判断数组是否为空数据
   * @param array
   * @returns true 不是空数组
   */
  static isNotEmptyArray(arr: Array<any>): boolean {
    return arr != undefined && arr != null && arr.length > 0 && Array.isArray(arr)
  }

  /**
   * 获取数组的长度
   * @param array
   * @returns
   */
  static getArraySize(arr: Array<any>): number {
    if (arr != undefined && arr != null) {
      return arr.length
    } else {
      return 0
    }
  }

  /**
   * 判断字符串是否为空
   * @param str
   * @returns true 是空字符串
   */
  static isEmptyString(str: string): boolean {
    return str == undefined || str == null || str.length == 0
  }

  /**
   * 判断字符串是否为空
   * @param str
   * @returns true 不是空字符串
   */
  static isNotEmptyString(str: string): boolean {
    return !this.isEmptyString(str)
  }

  /**
   * 判断对象是否正常
   * @param a
   * @returns true 不正常（undefined、null或NaN）
   */
  static isWrongAny(a: any) {
    return a == undefined || a == null || a == NaN
  }

  /**
   * 判断对象是否正常
   * @param a
   * @returns true 正常（非undefined、null或NaN）
   */
  static isNotWrongAny(a: any) {
    return !this.isWrongAny(a)
  }

  /**
   * 判断数字是否正常
   * @param num
   * @returns true 不正常（undefined、null或NaN）
   */
  static isWrongNumber(num: number) {
    return num == undefined || num == null || num == NaN
  }

  /**
   * 判断数字是否正常
   * @param num
   * @returns true 正常（非undefined、null或NaN）
   */
  static isNotWrongNumber(num: number) {
    return !this.isWrongNumber(num)
  }

  /**
   * 判断数字是否等于0
   * @param num
   * @returns true =0
   */
  static isZeroNumber(num: number) {
    return num == undefined || num == null || num == NaN || num === 0
  }

  /**
   * 判断数字是否等于0
   * @param num
   * @returns true !=0
   */
  static isNotZeroNumber(num: number) {
    return !this.isZeroNumber(num)
  }

  /**
   * 判断字符串是否为空，为空则返回"/"，不为空则返回原字符串
   * @param str
   * @returns
   */
  static formatString(str: string): string {
    if (str == undefined || str == null || str.length == 0) {
      return "/"
    } else {
      return str
    }
  }

  /**
   * 判断金额是否为空或等于0，满足条件则返回"/"，不满足条件则返回原字符串
   * @param money
   * @returns
   */
  static formatMoney(money: string): string {
    if (this.toNumber(money) === 0) {
      return "/"
    }
    return money
  }

  /**
   * string转换为number
   * @param str
   * @param returnNum
   * @returns
   */
  static toNumber(str: string, returnNum ?: number): number {
    try {
      if (this.isEmptyString(str)) {
        return returnNum??0
      }
      let num = Number(str)
      if (isNaN(num)) {
        return returnNum??0
      }
      return num
    } catch (err) {
    }
    return returnNum??0
  }

  /**
   * 判断字符串为空或转换为number后的值是否等于0
   * @param str
   * @returns
   */
  static isEmptyOrZero(str: string) {
    return this.toNumber(str) === 0
  }

  /**
   * 判断字符串是不是number
   * @param str
   * @returns
   */
  static isNumber(str: string) {
    let isElementNum = true
    // 判断是否为空，如果为空则返回false
    if (this.isEmptyString(str)) {
      isElementNum = false
    }
    try {
      let num = Number(str)
      if (num % 1.0 != 0) {
        isElementNum = false
      }
    } catch (err) {
      isElementNum = false
    }
    return isElementNum
  }

  /**
   * 获取金额价格模板字符串
   * @param num
   * @param decimal
   * @param unit
   * @returns "¥8,888,88.88/吨"
   */
  static toThreeDigitUnitStr(num: number | string, unit?: string, decimal?: number) {
    if (num === null ||
    num === undefined ||
    (typeof num === "number" && num === 0) ||
    (typeof num === "string" && num.length === 0)) {
      return "¥0.00"
    }
    return "¥" + this.toThreeDigit(num, decimal) + this.getUnitStr(unit)
  }

  /**
   * 价格超过五位数时，三位分节法展示
   * @param num
   * @param decimal 保留几位小数，默认两位
   * @returns
   */
  static toThreeDigit(num: number | string, decimal: number = 2): string {
    let numberTemp = 0
    if (num != null) {
      numberTemp = typeof num === 'number' ? num : Number(num)
    }
    let numbers: string | number
    numbers = typeof num === 'number' ? num.toFixed(decimal) : Number(num).toFixed(decimal)
    if (numberTemp >= 100000) {
      numbers = numbers.indexOf('.') < 0 ? numbers + '.' : numbers
      let newNumber = numbers.replace(/(\d)(?=(\d{3})+\.)/g, '$1,').replace(/\.$/, '')
      return newNumber
    } else {
      return numbers
    }
  }

  /**
   * 数字保留2位小数，带单位
   * @param num
   * @param decimal 保留几位小数，默认两位
   * @returns
   */
  static toDigitUnitStr(num: number | string, unit?: string, decimal?: number) {
    return "¥" + this.toDigit(num, decimal) + this.getUnitStr(unit)
  }

  /**
   * 数字保留2位小数
   * @param num
   * @param decimal 保留几位小数，默认两位
   * @returns
   */
  static toDigit(num: number | string, decimal: number = 2): string {
    if (num === null || num === undefined) {
      return "0.00"
    } else {
      let numbers: string | number = typeof num === 'number' ? num.toFixed(decimal) : Number(num).toFixed(decimal)
      return numbers
    }
  }

  /**
   * 单位加斜杠
   * @param unit
   * @returns
   */
  static getUnitStr(unit: string): string {
    if (unit == null || unit.length == 0) {
      return ""
    } else {
      return "/" + unit
    }
  }

  /**
   * 默认字符串
   * @param str
   * @returns
   */
  static getDefaultStr(str: string, def?: string): string {
    if (this.isEmptyString(str)) {
      return this.isEmptyString(def) ? "/" : def
    } else {
      return str
    }
  }

  /**
   * 返回默认字符串
   * @param a
   * @param def
   * @returns
   */
  static getDefaultAny(a?: any, def?: any) {
    if (this.isWrongAny(a)) {
      return def
    } else {
      return a
    }
  }

  /**
   * 时间格式转换
   * @param timestamp  13位时间戳 | new Date() | Date()
   *                   console.log(dateFormat(1714528800000, 'YY-MM-DD HH:mm:ss'))
   * @param format = YY：年，M：月，D：日，H：时，m：分钟，s：秒，SSS：毫秒
   * @returns
   */
  static dateFormat(timestamp: number | string | Date, format = 'YYYY-MM-DD HH:mm:ss'): string {
    var date = new Date(timestamp)

    function fixedTwo(value: number): string {
      return value < 10 ? '0' + value : String(value)
    }

    var showTime = format
    if (showTime.includes('SSS')) {
      const S = date.getMilliseconds()
      showTime = showTime.replace('SSS', '0'.repeat(3 - String(S).length) + S)
    }
    if (showTime.includes('YY')) {
      const Y = date.getFullYear()
      showTime = showTime.includes('YYYY') ? showTime.replace('YYYY', String(Y)) : showTime.replace('YY', String(Y)
        .slice(2, 4))
    }
    if (showTime.includes('M')) {
      const M = date.getMonth() + 1
      showTime = showTime.includes('MM') ? showTime.replace('MM', fixedTwo(M)) : showTime.replace('M', String(M))
    }
    if (showTime.includes('D')) {
      const D = date.getDate()
      showTime = showTime.includes('DD') ? showTime.replace('DD', fixedTwo(D)) : showTime.replace('D', String(D))
    }
    if (showTime.includes('H')) {
      const H = date.getHours()
      showTime = showTime.includes('HH') ? showTime.replace('HH', fixedTwo(H)) : showTime.replace('H', String(H))
    }
    if (showTime.includes('m')) {
      var m = date.getMinutes()
      showTime = showTime.includes('mm') ? showTime.replace('mm', fixedTwo(m)) : showTime.replace('m', String(m))
    }
    if (showTime.includes('s')) {
      var s = date.getSeconds()
      showTime = showTime.includes('ss') ? showTime.replace('ss', fixedTwo(s)) : showTime.replace('s', String(s))
    }
    return showTime
  }

  /**
   * 返回日期
   * @param milliseconds
   * @param def 默认返回的符号 例如 “/”
   * @param empty 时间未设置或==0时，返回的字符串，默认为""
   * @returns
   */
  static dateFormatDefaultStr(timestamp: number | string | Date, def: string = "", format = 'YYYY-MM-DD HH:mm:ss'): string {
    if (timestamp === null ||
    timestamp === undefined ||
    (typeof timestamp === "number" && timestamp === 0) ||
    (typeof timestamp === "string" && timestamp.length === 0)) {
      return def
    }
    return this.dateFormat(timestamp, format)
  }

  /**
   * 返回日期
   * @param milliseconds
   * @param empty 时间未设置或==0时，返回的字符串，默认为""
   * @returns
   */
  static getDateStringYMD(milliseconds: number | string | Date, empty = ""): string {
    return this.dateFormatDefaultStr(milliseconds, empty, "YYYY-MM-DD")
  }

  /*
   * 返回当前时间和传入时间戳的时间差
   *
   * @param timestamp 时间
   * @author 罗林轩
   * @date 2023/12/27 10:38
   */
  static getTimeDifference(timestamp: number): number[] {
    const now = new Date();
    const target = new Date(timestamp);
    const diff = timestamp - now.getTime();

    const isFuture = diff > 0;
    const absDiff = Math.abs(diff);

    const days = Math.floor(absDiff / (1000 * 60 * 60 * 24));
    const hours = Math.floor((absDiff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((absDiff % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((absDiff % (1000 * 60)) / 1000);
    return isFuture ? [days, hours, minutes, seconds] : [-days, -hours, -minutes, -seconds];
  }

  /**
   * 获取文本宽度
   * @param text
   * @param fontSize
   * @returns
   */
  static getStringWidth(text: string, fontSize: number): number {
    let textWidth: number = measure.measureText({
      textContent: text,
      fontSize: fontSize
    })
    return textWidth;
  }

  /**
   * 格式化
   * @param phoneNumber
   * @returns
   */
  static formatPhoneNum(phoneNumber: string): string {
    if (this.isEmptyString(phoneNumber)) {
      return '****'
    }
    // 如果电话号码长度小于等于5位，则隐藏所有数字
    if (phoneNumber.length <= 5) {
      return '****'
    } else if (phoneNumber.length < 11 && phoneNumber.length > 5) {
      return phoneNumber.substring(0, 3) + '****' + phoneNumber.substring(4)
    } else {
      return phoneNumber.substring(0, 3) + '****' + phoneNumber.substring(7)
    }
  }

  /**
   * 是否保留三位有效小数
   *
   * @param unit 商品的单位（例如：株、根、枝、升、吨、千克、米）
   * @return true : 保留三位小数  false : 保留整数位
   */
  static isDouble3(unit: string) {
    let UTILS_STR2 = ["升", "吨", "千克", "米", "立方米", "方", "平方米"]
    return this.isNotEmptyString(unit) && UTILS_STR2.includes(unit)
  }

  static getCompleteQuantity(s: string, unit: string) {
    let r = ""
    if (this.isNotEmptyString(s) && this.isNotEmptyString(unit)) {
      if (this.isDouble3(unit)) {
        this.toDigit(s, 3) + unit
      } else {
        this.toDigit(s, 0) + unit
      }
    }
    return r
  }

  /**
   * map转JSON
   * @param map
   * @returns
   */
  static map2Json(map: Map<any, any>) {
    let jsonObject: Record<any, any> = {}
    map.forEach((value, key) => {
      if (key != undefined && value != undefined) {
        jsonObject[key] = value
      }
    })
    let info: string = JSON.stringify(jsonObject)
    return info
  }

  /**
   * 判断是否是手机号
   * @param phone
   * @returns
   */
  static isMobileNum(phone: string) {
    const REGEX_MOBILE = "^1(3\\d|4[5-9]|5[0-35-9]|6[2567]|7[0-8]|8\\d|9[0-35-9])\\d{8}$"
    return phone.match(REGEX_MOBILE)
  }
}