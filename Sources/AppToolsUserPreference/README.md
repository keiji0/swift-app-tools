# UserPreference

ユーザー設定を保存するためのパッケージになります。
`UserDefaults`や`NSUbiquitousKeyValueStore`へのユーティリティで、Codableに準拠した値を保存できます。

## Features

### 保存Storeの指定

UserPreferenceには`KeyValueStorable`プロトコルに準拠したストアを指定することができます。
デフォルトでは`UserDefaults`や`NSUbiquitousKeyValueStore`を`KeyValueStorable`に準拠させています。

```swift
class Preference: UserPreferences {
    /// 保存するストアを指定
    var store: KeyValueStorable { UserDefaults.standard }
    /// v1というプロパティを定義
    @UserPreferenceValue("v1", defaultValue: 0)
    var v1: Int
}
```

### plistに合わせたデータ保存

独自のEncoderを使い、Codableな値をplistの構造に合わせた形式に変換して保存します。
よくあるUserDefaults系のラッパーは、CodableのEncodeにJSONEncoder.encode()の`Data`を直接保存するためplistにはData形式で保存されてしまいます。
そうするとargumentDomainを使用する場合や、plistを開いて編集することが困難になるため、KeydContainerな値はplistのDictionaryとして保存されます。

### カテゴリ別の保存

複数のUserPreferenceを使用する場合、UserDefaultsのキーが競合しないようにCategoryを設定することができます。

```swift
class UserTheme1: UserPreferences {
    /// 保存するカテゴリを指定
    var category: Category = .init("theme1")
    /// v1というプロパティを定義
    @UserPreferenceValue("v1", defaultValue: 0)
    var v1: Int
}

class UserTheme2: UserPreferences {
    /// 保存するカテゴリを指定
    var category: Category = .init("theme2")
    /// カテゴリが分かれているので同名のプロパティ名でも問題ない
    @UserPreferenceValue("v1", defaultValue: 0)
    var v1: Int
}
```
