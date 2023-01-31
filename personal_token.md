## How to get Personal access tokens
- 登录 Github 账号
- 点击右上角头像，点击 `Set­tings`
<p align='center'>
    <img  src='https://i0.hdslb.com/bfs/article/fc3322beb3904be68da46bd67068ef0cba7f3884.png' alt=''>
</p>

- 左边菜单选择 “De­vel­oper Set­tings”

<p align='center'>
    <img  src='https://i0.hdslb.com/bfs/article/fa1fe494ecd96dbdbb7ee678eaab4e07a3476063.png' alt=''>
</p>

- 左侧选择 `Per­sonal ac­cess to­kens`

- 单击 `Gen­er­ate new to­ken` 按钮 

![img](https://i0.hdslb.com/bfs/article/f01b80f4729558b917f4e3b22ad5f35c1a228e78.png)

- 生成成功后复制到本项目即可

![img](https://i0.hdslb.com/bfs/article/9c564004f3da4c252ea7d9b59fd038c0714e3806.png)
### 检验状态
``` lua
--在androlua环境运行以下代码，@yourToken替换成您获取的token
local header={Authorization="token @yourToken"}
local url='https://api.github.com/repos/nirenr/AndroLua_pro';
Http.get(url,nil,nil,header,function(code,html,_,header)
  print(header['x-ratelimit-limit'])
end)
--如打印数值为60，则token验证失败，成功时数值在5000左右
```
### Tips
- token拥有极高权限，务必妥善保管
- token**不会显示第二次**，如丢失只能重新申请
- 本项目仅将token用于拓宽`Github Api`的申请次数限制，不会上传到云端