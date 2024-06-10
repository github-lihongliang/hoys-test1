import { praticpageStatus } from '../enums/practicpageStatus'
import { answerStatus } from '../enums/answerStatus'
import { getRandomquest, quest, questionData } from '../model/quest'
import promptAction from '@ohos.promptAction'
import { optionStatus } from '../enums/optionStatus'
import { convertMillisecondsToTime } from '../utils/dateUtils'
import router from '@ohos.router'
import { dakaPost } from '../http/api'
import emitter from '@ohos.events.emitter'
// @Entry
@Component
export struct PracticPage {
  @State praticpageStatus: praticpageStatus = praticpageStatus.Stopped
  @State answerStatus: answerStatus = answerStatus.answering
  @State totalCount:number=3
  @State quests: quest[]= getRandomquest(this.totalCount)
  @State currentIndex:number=0
  @State slectOption: string = ''
  @State mansweredcount:number=0
  @State rightcount:number=0
  timerController:TextTimerController=new TextTimerController()
  timeused:number=0
  dialogcontroller:CustomDialogController=new CustomDialogController({
    builder:resultDialog({
      mansweredcount:this.mansweredcount,
      rightcount:this.rightcount,
      timeused:this.timeused,
      resetPratic:()=>{
        this.quests = getRandomquest(this.totalCount)
        this.currentIndex=0
        this.mansweredcount=0
        this.rightcount=0
        this.timeused=0
        this.timerController.reset()
        this.answerStatus = answerStatus.answering
      },
      startPratic:()=>{
        this.startPartic()
      }
    }),
    customStyle:true,
    autoCancel:false
  })

  startPartic () {
    this.praticpageStatus = praticpageStatus.Running
    this.timerController.start()
  }

  pausePartic () {
    this.praticpageStatus = praticpageStatus.Paused
    this.timerController.pause()
  }

  stopPartic () {
    this.praticpageStatus = praticpageStatus.Stopped
    this.timerController.pause()
    this.dialogcontroller.open()
  }

  build(){
    Column(){
      //   统计面板
      Column(){
        stateItem({
          icon:$r('app.media.app_icon'),
          name:'准确率',
          fontColor:Color.Black
        }){
          Text((this.rightcount===0?0:this.rightcount/this.mansweredcount*100).toFixed()+'%')
            .width(100)
            .textAlign(TextAlign.Center)
        }
        stateItem({
          icon:$r('app.media.app_icon'),
          name:'进度',
          fontColor:Color.Black
        }){
          Progress({value:this.mansweredcount,total:this.totalCount})
            .width(100)
        }
        stateItem({
          icon:$r('app.media.app_icon'),
          name:'个数',
          fontColor:Color.Black
        }){
          Button(this.totalCount.toString())
            .width(100)
            .height(25)
            .backgroundColor('#ebebeb')
            .fontColor('#000000')
            .enabled(this.praticpageStatus===praticpageStatus.Stopped)
            .onClick(()=>{
              TextPickerDialog.show({
                range:['1','2','3'],
                value:this.totalCount.toString(),
                onAccept:(r)=>{
                  this.totalCount = parseInt(r.value)
                  this.quests=getRandomquest(this.totalCount)
                }
              })
            })
         }
        stateItem({
          icon:$r('app.media.app_icon'),
          name:'用时',
          fontColor:Color.Black
        }){
          Row(){
            TextTimer({controller:this.timerController})
              .onTimer((utc,t)=>{this.timeused=t})
          }
          .width(100)
          .justifyContent(FlexAlign.Center)
        }
      }
      .statBgStyle()
      //   题目
      Column(){
        Text(this.quests[this.currentIndex].word)
          .wordStyle()
        Text(this.quests[this.currentIndex].sentence)
          .sentenceStyle()
      }
      //   选项
      Column({space:10}){
        ForEach(this.quests[this.currentIndex].options,(option)=>{
          optionButton({
            option:option,
            answerStatus:this.answerStatus,
            answer:this.quests[this.currentIndex].answer,
            slectOption:this.slectOption
          })
            .enabled(this.answerStatus === answerStatus.answering)
            .onClick(()=>{
              if (this.praticpageStatus !== praticpageStatus.Running) {
                promptAction.showToast({message:'请先点击测试'})
                return
              }
              this.slectOption = option
              this.mansweredcount++
              if (option===this.quests[this.currentIndex].answer){
                this.rightcount++
              }
              this.answerStatus = answerStatus.answered
              if (this.currentIndex<questionData.length-1) {
                setTimeout(()=>{
                  this.currentIndex++
                  this.answerStatus = answerStatus.answering
                },500)
              } else {
                this.stopPartic()
              }
            })
        },option=>this.quests[this.currentIndex].word+'-'+option)
      }
      Row({space: 50}){
        Button('停止测试')
          .controlButtonStyle({
            bg: Color.Transparent,
            font: this.praticpageStatus === praticpageStatus.Stopped?Color.Gray:Color.Black,
            border: this.praticpageStatus === praticpageStatus.Stopped?Color.Gray:Color.Black
          })
          .enabled(this.praticpageStatus != praticpageStatus.Stopped)
          .onClick(()=>{
            this.stopPartic()
          })
        Button(this.praticpageStatus === praticpageStatus.Running?'暂停测试':'开始测试')
          .controlButtonStyle({
            bg: this.praticpageStatus === praticpageStatus.Running?'#555555':Color.Black,
            font: Color.White,
            border: this.praticpageStatus === praticpageStatus.Running?'#555555':Color.Black
          })
          .stateEffect(false)
          .onClick(()=>{
            if (this.praticpageStatus === praticpageStatus.Running) {
              this.pausePartic()
            }else {
              this.startPartic()
            }
          })
      }
    }
    .practicpageStyle()
  }
}

@CustomDialog
struct resultDialog{
  mansweredcount:number
  rightcount:number
  timeused:number
  resetPratic:()=>void
  startPratic:()=>void
  controller:CustomDialogController=new CustomDialogController({
    builder:resultDialog()
  })
  @StorageProp('userObj') userObj:string=''
  @StorageLink('crurrentTabIndex') crurrentTabIndex:number=0
  build(){
    Column({space:10}){
      Image($r('app.media.app_icon'))
        .width(25)
        .height(25)
        .alignSelf(ItemAlign.End)
      .onClick(()=>{
        this.controller.close()
        this.resetPratic()
      })
      Column({space:10}){
        Image($r('app.media.icon'))
          .width('90%')
          .borderRadius(10)
        stateItem({
          icon:$r('app.media.app_icon'),
          name:'用时',
          fontColor:Color.Black
        }){
          Text(convertMillisecondsToTime(this.timeused))
            .width(100)
            .textAlign(TextAlign.Center)
        }
        stateItem({
          icon:$r('app.media.app_icon'),
          name:'准确率',
          fontColor:Color.Black
        }){
          Text((this.rightcount===0?0:this.rightcount/this.mansweredcount*100).toFixed()+'%')
            .width(100)
            .textAlign(TextAlign.Center)
        }
        stateItem({
          icon:$r('app.media.app_icon'),
          name:'个数',
          fontColor:Color.Black
        }){
          Text(this.mansweredcount.toString())
            .width(100)
            .textAlign(TextAlign.Center)
        }
        Divider()
      }
      Row({space:30}){
        Button('在来一局')
          .controlButtonStyle({
            bg: Color.Transparent,
            font: Color.Black,
            border: Color.Black
          })
          .onClick(()=>{
            this.controller.close()
            this.resetPratic()
            this.startPratic()
          })
        Button(this.userObj?'立即打卡':'登录打卡')
          .controlButtonStyle({
            bg: Color.Black,
            font: Color.White,
            border: Color.Black
          })
          .onClick(async ()=>{
            this.controller.close()
            this.resetPratic()
            if (this.userObj){
              // await dakaPost({
              //   rightCount: this.rightcount,
              //   answeredCount: this.mansweredcount,
              //   timeUsed: this.timeused
              // })
              promptAction.showToast({message:'打卡成功'})
              this.crurrentTabIndex = 1
              // 监听个页面数据状态，通知刷新
              emitter.emit({eventId:1})
            } else {
              router.pushUrl({url:'pages/LoginPage',params:{
                rightCount: this.rightcount,
                answeredCount: this.mansweredcount,
                timeUsed: this.timeused
              }})
            }
          })
      }
    }
    .backgroundColor(Color.White)
    .width('80%')
  }
}

@Component
export struct stateItem{
  icon:Resource
  name:string
  @BuilderParam statcom:()=>void
  fontColor:Color
  build(){
    Row({space:10}){
      Image(this.icon)
        .width(14)
        .height(14)
      Text(this.name)
        .fontWeight(FontWeight.Medium)
        .fontSize(14)
        .fontColor(this.fontColor)
      Blank()
      this.statcom()
    }
    .width('100%')
    .height(30)
  }
}

@Component
struct optionButton{
  option:String
  answer:String
  @State optionStatus:optionStatus=optionStatus.Defualt
  @Prop slectOption: string
  @Prop @Watch('onanswerChange') answerStatus:answerStatus

  onanswerChange(){
    if (this.option===this.answer){
      this.optionStatus=optionStatus.Success
    } else {
      if(this.option===this.slectOption){
        this.optionStatus=optionStatus.wrong
      } else {
        this.optionStatus=optionStatus.Defualt
      }
    }
  }

  getColor(){
    switch (this.optionStatus){
      case optionStatus.Success:
        return '#1dbf7d'
      case optionStatus.wrong:
        return '#fa635f'
      default:
        return Color.White
    }
  }

  build(){
    Stack(){
      Button(this.option.toString())
        .optionButtonStyle({
          bg: this.getColor(),
          font: this.optionStatus===optionStatus.Defualt?Color.Black:Color.White
        })
      if (this.optionStatus===optionStatus.Success) {
        Text('✓')
          .offset({x:10})
      }else if (this.optionStatus===optionStatus.wrong){
        Text('x')
          .offset({x:10})
      }
    }
    .alignContent(Alignment.Start)
  }
}

@Extend(Column) function practicpageStyle(){
  .width('100%')
  .height('100%')
  .backgroundColor('#E6F7F0')
  .justifyContent(FlexAlign.SpaceEvenly)
}

@Styles function statBgStyle(){
  .width('90%')
  .backgroundColor(Color.White)
  .padding(20)
  .borderRadius(10)
}

@Extend(Text) function wordStyle(){
  .fontSize(50)
  .fontWeight(700)
}

@Extend(Text) function sentenceStyle(){
  .width('80%')
  .height(40)
  .fontSize(16)
  .fontColor('#9a1a5')
  .fontWeight(700)
  .textAlign(TextAlign.Center)
}

@Extend(Button) function optionButtonStyle(color:{
  bg: ResourceColor
  font: ResourceColor
}){
  .width(240)
  .height(40)
  .fontSize(16)
  .type(ButtonType.Normal)
  .fontWeight(700)
  .borderRadius(8)
  .backgroundColor(color.bg)
  .fontColor(color.font)
}

@Extend(Button) function controlButtonStyle(color:{
  bg: ResourceColor
  font: ResourceColor
  border: ResourceColor
}){
  .fontSize(16)
  .borderWidth(1)
  .backgroundColor(color.bg)
  .fontColor(color.font)
  .borderColor(color.border)
}