import {instance} from './axios'
// 验证码
export function sendCode(phone:string){
  return instance.get('url',{params:{phone:phone}})
}
// 登录
export function login(phone:string,code:string){
  return instance.post('url',{params:{phone:phone, code: code}})
}

//打卡
export function dakaPost(post: {
  rightCount: number,
  answeredCount: number,
  timeUsed: number
}){
  return instance.post('/word/post/create',post)
}

// 答题数据List
export function getposInfo(page:number,total:number){
  return instance.post('url',{params:{page:page, total: total}})
}

//点赞
export function like(postId:number){
  return instance.get('/word/like/create',{params:{postId:postId}})
}
//取消点赞
export function cancellike(postId:number){
  return instance.get('/word/like/cancel',{params:{postId:postId}})
}

// 获取登录用户信息
export function info() {
  return instance.get('/word/user/info')
}
// 获取我的登录打卡记录
export function getMyPost(page:number,size:number){
 return instance.get('/word/post/getMine',{params:{page:page,size:size}})
}