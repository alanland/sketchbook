# 音乐控制
空格暂停或者播放音乐

# 天空
NightSky 使用 HSB 的色彩模式绘制了一个渐变，由于想使用蓝色多一点，在渐变的时候，使用sin函数偏向蓝色一点

# 星星
随机绘制一些ellipse在夜空中表示星星，并且改变 fillColor 的亮度来模仿星星的闪烁效果

# 流星
流行包含了长度、大小、滑行时间、起点、终点等属性。
由起点慢慢向终点运动，同时拖长尾巴，并改变流星大小，到达重点后如果流星大小大于1，那么继续滑行到滑行时间结束或者流行流星大小小于1.。

# 鼠标效果
通过颜色判断可点击区域时候，在鼠标周围绘制一些从小到大的园环（空心，来确保点击生效）表示可以点击。

# 花朵
## 点击绘制
点击在大树范围内，画一朵花朵，通过一个list记录所有花朵的位置。
## 闪烁
随机填充 strokeColor 达到闪烁效果。
## 旋转
## 加速
判断鼠标和花朵的距离，如果在花朵范围内，那么加速旋转。
## 移除所有花朵
c键会移除所有花朵

# 图片缩放
通过点击李白，缩小图片。再次点击，恢复。

# 字体效果
## 存储
字体内容通过list存储，每个汉字存储在一个HanZi类里面，包含起点终点，运动状态等信息。
## 背景
下面亮点确定汉字的幻影效果
 -  纸张背景PNG格式，有一定Alpha值
 -  白色背景用 rect 函数，同有具有alpha值
## 字体运动
点击李白后，
固定间隔，把所有汉字顺序从起点移动到重点然后固定。
## 字体擦除
点击触发，给每个汉字每个frame 设置一个随机加速度，出了字体范围之后，汉字消失。

