# BaseLibrary

Reusable iOS base utilities and UIKit/Foundation extensions.

## Install From Git

```ruby
pod 'BaseLibrary', :git => 'https://github.com/kingdom/BaseLibrary.git', :tag => '0.1.0'
```

## Install From Local Path

```ruby
pod 'BaseLibrary', :path => './InternalSports/Screens/BaseLibrary'
```

## Release A New Version

1. Update `s.version` in `BaseLibrary.podspec`.
2. Commit and push changes.
3. Create a matching git tag, for example:

```sh
git tag 0.1.0
git push origin main --tags
```

Apps can then point to that tag in their `Podfile`.
