# cocoapods-podspec-binary

一个CocoaPods插件，可以根据podspec中指定的源代码生成SDK的二进制版本。它支持根据podspec生成framework或xcframework，旨在帮助开发人员加速编译过程。

## 为什么
当前开源的二进制插件较少，并且区别于很多都是基于全工程的插件，相对于组件化的工程，对于单Pod的二进制化显得尤为重要，最常用的cocoapods-package后续也不在维护，因此基于cocoapods的能力我们自研了基于单Pod的二进制插件。

## 二进制的优势
- **源代码保护：** 当你将应用的代码编译成二进制形式时，原始源代码就不再直接可见。这有助于保护知识产权，因为其他人很难直接查看和修改源代码。

- **发布和分发：** 将应用程序或库编译成二进制形式可以更轻松地分发给其他开发者或终端用户。这通常以动态链接库（Dynamic Link Libraries，DLLs）或框架的形式提供。

- **性能优化：** 二进制形式的代码可能经过优化，以提高执行速度和减少内存占用。这使得应用程序在运行时更加高效。

- **知识产权和商业机密：** 对于一些库或框架，开发者可能希望保护其实现细节或算法，以防止被轻松复制或修改。使用二进制形式有助于在一定程度上隐藏这些细节。

- **插件和模块化：** 在某些情况下，开发者可能将一些功能模块或插件编译为二进制，以便更轻松地集成到不同的项目中。

## 安装

```
$ gem install cocoapods-podspec-binary
```

## 使用

```
$ pod mbuild [NAME] [VERSION]

Options:

    --framework     Used to generate the framework
    --xcframework   Used to generate the xcframework
    --sources       The sources from which to pull dependent pods

Example：

$ pod mbuild AFNetworking 4.0.1
```

## 说明
1. 插件当前只支持静态库，因为动态库存在一些问题和风险，同时静态库和动态库混合使用也存在一些风险。
2. 使用者需要根据使用情况去修改对应的.podspec.json的source配置，因为我们无法预知使用者对于二进制文件的存储方式，具体用法可以参考后续的最佳实践。
3. 关于构建依赖问题，如果没有在podspec指定依赖的版本，正常情况下会使用最新的依赖，具体可以参考生成的Podfile.lock的文件。

## 最佳实践

cocoapods-podspec-binary只是用于SDK生成二进制及二进制的podspec，并不去管理对应的存储方式，对于最终的使用完全可以根据使用者自行定义。

**我推荐的做法是**

1. 可以将对应的二进制存储到静态服务，我们推荐使用maven，然后根据不同版本的二进制文件，存储不同的地址，当然您也可以使用其他的静态服务。
2. 对于podspec的管理，如果想支持源码版本和二进制的版本共存的情况下，我们建议使用通过版本来区分源码版本和二进制版本，例如：源码版本是4.1.0，那么对应的二进制版本可以定义为4.0.1.1-binary。