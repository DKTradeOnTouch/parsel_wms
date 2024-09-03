part of persistent_bottom_nav_bar_v2;

class NavBarPadding {
  final double? top;
  final double? bottom;
  final double? right;
  final double? left;

  const NavBarPadding.only({
    this.top = 0.0,
    this.bottom = 0.0,
    this.right = 0.0,
    this.left = 0.0,
  });

  const NavBarPadding.symmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
  })  : top = vertical,
        bottom = vertical,
        right = horizontal,
        left = horizontal;

  const NavBarPadding.all(double? value)
      : top = value,
        bottom = value,
        right = value,
        left = value;

  const NavBarPadding.fromLTRB(
    this.left,
    this.top,
    this.right,
    this.bottom,
  );
}
