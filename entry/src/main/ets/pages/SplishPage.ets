import router from '@ohos.router'
PersistentStorage.PersistProp('userObj', '')
AppStorage.SetOrCreate('crurrentTabIndex',0)
@Entry
@Component
struct SplishPage {
  @State flag:boolean=false
  onPageShow(){
    animateTo({duration:1000,onFinish:()=>{
      setTimeout(()=>{
        router.replaceUrl({url:'pages/Index'})
      },200)
    }},()=>{
      this.flag=true
    })
  }
  build() {
    Column(){
      if (this.flag) {
        Image($r('app.media.app_icon'))
          .logoStyle()
          .transition({type:TransitionType.Insert,opacity:0,translate:{x:-150}})
        Text('哈卡菲纳')
          .titleStyle()
          .transition({type:TransitionType.Insert,opacity:0,translate:{x:150}})
      }
      Blank()
      Text('jja jdfbj sabagag')
        .footStyle()
    }
    .bgStyle()
  }
}

@Styles function bgStyle(){
  .width('100%')
  .height('100%')
  .backgroundImage($r('app.media.sbg'))
  .backgroundImageSize({width:'100%',height:'100%'})
}

@Extend(Image) function logoStyle(){
  .width(90)
  .height(90)
  .margin({top:120})
}

@Extend(Text) function titleStyle(){
  .fontSize(21)
  .fontColor('#546b9d')
  .fontWeight(700)
  .margin({top:30})
}

@Extend(Text) function footStyle(){
  .fontSize(12)
  .fontColor('#546b9d')
  .fontWeight(700)
  .margin({bottom:30})
}