# cocoapods-podspec-binary

A CocoaPods plugin that can generate binary versions of an SDK from the source code specified in the podspec. It supports creating either a framework or an xcframework from the podspec, aiming to assist developers in speeding up the compilation process.

## Why
The number of open-source binary plugins is currently limited, and many of them are designed for entire projects. In contrast to projects emphasizing componentization, achieving binary integration for a single Pod becomes particularly crucial. The widely used cocoapods-package is no longer actively maintained. To address this, leveraging CocoaPods' capabilities, we have developed our own binary plugin tailored for individual Pods.

## Advantages
- **Source Code Protection:** Compiling the application code into binary form makes the original source code less directly accessible. This helps protect intellectual property, as others find it challenging to directly view or modify the source code.
- **Distribution and Deployment:**
  Compiling applications or libraries into binary form makes it easier to distribute to other developers or end-users. This is often provided in the form of Dynamic Link Libraries (DLLs) or frameworks.
- **Performance Optimization:** Binary code can be optimized to improve execution speed and reduce memory usage. This enhances the efficiency of the application during runtime.
- **Intellectual Property and Trade Secrets:** For certain libraries or frameworks, developers may want to protect implementation details or algorithms to prevent easy replication or modification. Using binary form helps conceal these details to some extent.
- **Plugins and Modularity:** In some cases, developers may compile functional modules or plugins into binary form for easier integration into different projects.

## Installation

```
$ gem install cocoapods-podspec-binary
```

## Usage

```
$ pod mbuild [NAME] [VERSION]

Options:

    --framework     Used to generate the framework
    --xcframework   Used to generate the xcframework
    --sources       The sources from which to pull dependent pods

Example：

$ pod mbuild AFNetworking 4.0.1
```

## Notes

1. The plugin currently only supports static libraries due to some issues and risks associated with dynamic libraries.   Additionally, there are potential risks when combining the use of static and dynamic libraries.
2. Users should customize the source configuration in the corresponding `.podspec.json` based on their use case since we cannot anticipate how users intend to store binary files. Specific usage guidelines will be provided in the upcoming best practices.
3. Regarding dependency resolution, if no version is specified in the podspec, the default behavior is to use the latest available version. For specific details, you can refer to the generated `Podfile.lock` file.

## Best Practices

cocoapods-podspec-binary is designed solely for generating binary SDKs and their corresponding podspecs. It does not manage the storage method, leaving it entirely to the discretion of the user.

Here are recommended practices:

1. Store the binary in a static service, and Maven is recommended for this purpose. Different addresses can be used for storing binaries of different versions.
2. For podspec management, if you intend to support both source code and binary versions concurrently, we recommend distinguishing them by version numbers. For example, if the source code version is 4.1.0, the corresponding binary version can be defined as 4.0.1.1-binary