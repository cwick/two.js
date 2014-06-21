`import AssetLoader from "asset_loader"`

describe "AssetLoader", ->
  describe "#join", ->
    it "joins two empty paths", ->
      expect(AssetLoader.join "", "").toEqual ""

    it "joins empty to non-empty", ->
      expect(AssetLoader.join "", "foo").toEqual "foo"
      expect(AssetLoader.join "", "/foo").toEqual "/foo"

    it "joins non-empty to empty", ->
      expect(AssetLoader.join "foo", "").toEqual "foo"

    it "joins two simple names", ->
      expect(AssetLoader.join "foo", "bar").toEqual "foo/bar"

    it "joins names with leading slashes", ->
      expect(AssetLoader.join "/foo", "bar").toEqual "/foo/bar"
      expect(AssetLoader.join "/foo", "/bar").toEqual "/foo/bar"
      expect(AssetLoader.join "foo", "/bar").toEqual "foo/bar"

    it "joins names with trailing slashes", ->
      expect(AssetLoader.join "foo/", "bar").toEqual "foo/bar"
      expect(AssetLoader.join "foo", "bar/").toEqual "foo/bar/"
      expect(AssetLoader.join "foo/", "bar/").toEqual "foo/bar/"

    it "joins names with leading and trailing slashes", ->
      expect(AssetLoader.join "/foo/", "/bar/").toEqual "/foo/bar/"
      expect(AssetLoader.join "foo", "/bar/").toEqual "foo/bar/"
      expect(AssetLoader.join "/foo/", "bar").toEqual "/foo/bar"

  describe "#stripExtension", ->
    it "strips the extension", ->
      expect(AssetLoader.stripExtension "foo.png").toEqual "foo"
