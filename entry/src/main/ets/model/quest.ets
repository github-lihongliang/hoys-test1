export interface quest{
  word:string,
  sentence:string,
  options:string[],
  answer:string
}
export const questionData:quest[]=[
  {
    word:'book',
    sentence:'book sdff ssss',
    options:['西游记','红楼梦','水浒传','三国','书籍'],
    answer:'书籍'
  },
  {
    word:'comper',
    sentence:'comper sdff ssss',
    options:['电脑','电视','洗衣机','冰箱','机电'],
    answer:'机电'
  },
  {
    word:'shuiguo',
    sentence:'shuiguo sdff ssss',
    options:['香蕉','苹果','榴莲','西瓜','水果'],
    answer:'水果'
  }
]
export function getRandomquest(count:Number){
  let length=questionData.length
  let indexs: number[] = []
  while (indexs.length<count){
    let index = Math.floor(Math.random()*length)
    if (!indexs.includes(index)) {
      indexs.push(index)
    }
  }
  return indexs.map(index=>questionData[index])
}
