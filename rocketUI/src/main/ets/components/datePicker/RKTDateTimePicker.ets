export enum RKTDateTimePickerType {
  // 年月日
  date = 0,
  // 时分
  time,
  // 年月日时分
  dateAndTime,
}

@Component
export struct RKTDateTimePicker {
  pickerType: RKTDateTimePickerType = RKTDateTimePickerType.date
  titleName: string = "选择日期/时间"
  startDate: Date = new Date('1970-1-1')
  selectDate: Date = new Date()
  selectTime: Date = new Date()
  onCancel: () => void
  onEnter: (date: Date) => void

  build() {
    Column() {
      Blank().onClick(() => {
        if (this.onCancel) {
          this.onCancel()
        }
      })
      Column() {
        Stack() {
          Text(this.titleName)
            .fontColor("#969696")
            .width('100%')
            .height(48)
            .textAlign(TextAlign.Center)
          Row() {
            Text("取消")
              .fontColor("#666666")
              .textAlign(TextAlign.Center)
              .width(60)
              .height(48)
              .onClick(() => {
                if (this.onCancel) {
                  this.onCancel()
                }
              })
            Text("确定")
              .fontColor("#5792FD")
              .textAlign(TextAlign.Center)
              .width(60)
              .height(48)
              .onClick(() => {
                if (this.onEnter) {
                  if (this.pickerType == RKTDateTimePickerType.date) {
                    this.onEnter(this.selectDate)
                  }
                  if (this.pickerType == RKTDateTimePickerType.time) {
                    this.onEnter(this.selectTime)
                  }
                  if (this.pickerType == RKTDateTimePickerType.dateAndTime) {
                    this.onEnter(new Date(this.selectDate.getFullYear(), this.selectDate.getMonth() + 1, this.selectDate.getDate(), this.selectTime.getHours(), this.selectTime.getMinutes()))
                  }
                }
              })
          }
          .width('100%')
          .height(48)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .backgroundColor("#F5F5F5")

        Row() {
          if (this.pickerType == RKTDateTimePickerType.date || this.pickerType == RKTDateTimePickerType.dateAndTime) {
            DatePicker({ start: this.startDate })
              .height('100%')
              .layoutWeight(3)
              .onChange((value: DatePickerResult) => {
                this.selectDate.setFullYear(value.year, value.month, value.day)
              })
          }
          if (this.pickerType == RKTDateTimePickerType.time || this.pickerType == RKTDateTimePickerType.dateAndTime) {
            TimePicker()
              .useMilitaryTime(true)
              .height('100%')
              .layoutWeight(2)
              .onChange((value: TimePickerResult) => {
                this.selectTime.setHours(value.hour, value.minute)
              })
          }
        }
        .width('100%')
        .layoutWeight(1)
      }
      .backgroundColor(Color.White)
      .width('100%')
      .height(360)
      .justifyContent(FlexAlign.SpaceBetween)
      .borderRadius({ topLeft: 15, topRight: 15 })
      .clip(true)
    }
    .backgroundColor("#7F000000")
    .width('100%')
    .height('100%')
  }
}