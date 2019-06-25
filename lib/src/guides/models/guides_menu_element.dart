/// PODO that describes element of guides menu
class GuidesMenuElement {
  final String title;
  final String subTitle;
  final String photoAsset;

  /// Index in menu, uses to send event to bloc,
  /// needs to simplify creating of menu
  final int menuIndex;

  GuidesMenuElement(
      {this.title, this.subTitle, this.photoAsset, this.menuIndex});
}
