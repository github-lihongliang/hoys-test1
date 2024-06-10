import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { dakaPost, login, sendCode } from '../http/api'
import emitter from '@ohos.events.emitter'

// @Entry
@Component
struct LoginPage{
  @State phone:string=''
  @State code:string=''
  @StorageLink('userObj') userObj:string=''
  @StorageLink('crurrentTabIndex') crurrentTabIndex:number=0
  build(){
    Column(){
      Image($r("app.media.app_icon"))
        .backStyle()
        .alignSelf(ItemAlign.Start)
        .onClick(() =>{
          // 返回上一页面
          router.back()
        })
      Blank()
      Column(){
        Text('欢迎登录')
        .titleStyle()
        .margin({top:20})
        Row(){
          Image($r('app.media.app_icon'))
            .iconStyle()
          TextInput({placeholder:'请输入手机号码',text:this.phone})
            .inputStyle()
        }
        .margin({top:30})
        Divider()
          .color(Color.Black)
        Row(){
          Image($r('app.media.app_icon'))
            .iconStyle()
          TextInput({placeholder:'请输入验证码',text:this.code})
            .inputStyle()
            .onChange((v)=>{
              this.code=v
            })
          Button('获取验证码')
            .buttonStyle(Color.White,Color.Black)
            .onClick(async ()=>{
              // let data = await sendCode(this.phone)
              // this.code = data.data
            })
        }
        .margin({top:20})
        Divider()
          .margin({right:120})
          .color(Color.Black)
        Button('立即登录')
          .buttonStyle(Color.Black,Color.White)
          .width('100%')
          .margin({top:30})
          .onClick(async ()=>{
            // let data = await login(this.phone,this.code)
            this.userObj = 'data.data'
            if (this.crurrentTabIndex===0){
              let params = router.getParams()
              // dakaPost({
              //   rightCount: params['rightCount'],
              //   answeredCount: params['answeredCount'],
              //   timeUsed: params['timeUsed']
              // })
              promptAction.showToast({message:'打卡成功'})
              this.crurrentTabIndex=1
              // 监听个页面数据状态，通知刷新
              emitter.emit({eventId:1})
            }
            router.back()
          })
        Row(){
          Text('登录即表明已同意')
            .fontSize(12)
            .fontColor('#546b9d')
          Text('《用户使用协议》')
            .fontSize(12)
            .fontColor('#00b3ff')
        }
        .fromOnStyle()
        Row({space:10}){
          Image($r('app.media.app_icon'))
            .iconStyle()
          Text('我是副部信息------')
            .fontColor(Color.Black)
            .margin({bottom:10})
        }
      }
      .backgroundColor(Color.White)
      .borderRadius(5)
      .alignSelf(ItemAlign.Start)
      .padding({left:20,right:20})
    }
    .loginBgStyle()
  }
}

@Extend(TextInput) function inputStyle(){
  .height(40)
  .layoutWeight(1)
  .fontSize(14)
  .backgroundColor(Color.Transparent)
  .type(InputType.Normal)
}
@Extend(Button) function buttonStyle(bgColor:ResourceColor,fontColor:ResourceColor){
  .type(ButtonType.Normal)
  .fontSize(14)
  .fontWeight(700)
  .borderRadius(5)
  .backgroundColor(bgColor)
  .fontColor(fontColor)
  .borderWidth(1)
}
@Styles function backStyle(){
  .width(25)
  .height(25)
}
@Styles function iconStyle(){
  .width(24)
  .height(24)
}
@Extend(Text) function titleStyle(){
  .fontWeight(700)
  .fontSize(22)
}
@Styles function fromOnStyle(){
  .backgroundColor(Color.White)
  .padding(20)
  .borderRadius(20)
}
@Styles function loginBgStyle(){
  .width('100%')
  .height('100%')
  .backgroundImage($r('app.media.sbg'))
  .backgroundImageSize({width:'100%',height:'100%'})
  .padding({top:30,bottom:140,left:20,right:20})
}
