import utest.Assert;
using doom.XmlNode;
import doom.Patch;

class TestXml extends TestBase {
  public function testToXml() {
    Assert.equals('<div name="value"><a/></div>', el4.toXml().toString());
  }

  public function testXmlPatch() {
    var xml = Xml.createElement("div"),
        patches = [
          SetAttribute("name", "value"),
          AddElement("a", ["href" => "#"], null, []),
          PatchChild(0, [AddText("hello")])
        ];
    XmlNode.applyPatches(patches, xml);
    Assert.equals('<div name="value"><a href="#">hello</a></div>', xml.toString());
  }
}
