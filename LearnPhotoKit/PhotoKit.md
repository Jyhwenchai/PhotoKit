#  PhotoKit

## 资产提取（Asset Retrieval）

## 资产加载（Asset Loading）

## 现场照片（Live Photos）

## 资产资源管理 (Asset Resource Management)

## 图片编辑扩展名（Photo Editing Extensions）



* 获取照片库权限
* 获取照片库中图片资源列表以缩略图展示
* 监听照片库的资产更新
* 通过选中的缩略图项目获取更详细的资产信息

### 相册列表操作

1. 获取相册
    * 全部照片
    * 智能相册
    * 自建相册

2. 获取相册数量、封面 asset、相册名称包装成模型

3. cell 加载封面

4. 监听资产的变化，同步最新资产到列表

#### Design

**PhotoManager**

- PHCachingImageManager
    

### 照片列表操作

1. 通过前面已获取的资产使用 `PHCachingImageManager` 加载图片（图片可能是视频的封面）


